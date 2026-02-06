import Foundation

class GnirehtetManager {
    private var process: Process?
    
    // Dynamic paths based on bundle resources
    private var resourcesPath: String {
        return Bundle.main.resourcePath ?? ""
    }
    
    private var adbPath: String {
        return (resourcesPath as NSString).appendingPathComponent("adb")
    }
    
    private var jarPath: String {
        return (resourcesPath as NSString).appendingPathComponent("gnirehtet.jar")
    }
    
    var isRunning: Bool {
        if let process = process, process.isRunning {
            return true
        }
        return checkSystemStatus()
    }
    
    struct Device {
        let serial: String
        let model: String
    }
    
    func getDevices() -> [Device] {
        guard FileManager.default.fileExists(atPath: adbPath) else {
            print("ADB not found at: \(adbPath)")
            return []
        }
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: adbPath)
        task.arguments = ["devices", "-l"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            let lines = output.components(separatedBy: .newlines)
            
            var devices: [Device] = []
            for line in lines {
                let parts = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
                if parts.count >= 2 && parts[1] == "device" {
                    let serial = parts[0]
                    // Filter out emulators
                    if serial.contains("emulator") {
                        continue
                    }
                    var model = "Unknown Device"
                    // Parse model name from adb devices -l output (e.g., model:Pixel_4)
                    if let modelPart = parts.first(where: { $0.hasPrefix("model:") }) {
                        model = modelPart.replacingOccurrences(of: "model:", with: "").replacingOccurrences(of: "_", with: " ")
                    }
                    devices.append(Device(serial: serial, model: model))
                }
            }
            return devices
        } catch {
            return []
        }
    }

    private func checkSystemStatus() -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/pgrep")
        // Check for gnirehtet.jar which is what the script runs
        task.arguments = ["-f", "gnirehtet.jar"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            return output != nil && !output!.isEmpty
        } catch {
            return false
        }
    }
    
    func start(serial: String? = nil, completion: @escaping (Bool, String) -> Void) {
        stop()
        Thread.sleep(forTimeInterval: 0.5) 
        
        guard FileManager.default.fileExists(atPath: jarPath), 
              FileManager.default.fileExists(atPath: adbPath) else {
            let msg = "Dependencies missing in app bundle"
            completion(false, msg)
            NotificationManager.shared.show(title: "Start Failed", body: msg, isError: true)
            return
        }
        
        let newProcess = Process()
        // We use system java, assuming it's installed. 
        newProcess.executableURL = URL(fileURLWithPath: "/usr/bin/java")
        
        var args = ["-jar", jarPath, "run"]
        if let serial = serial {
            args.append(serial)
        }
        newProcess.arguments = args
        // Set working directory to resources so it finds gnirehtet.apk if needed
        newProcess.currentDirectoryURL = URL(fileURLWithPath: resourcesPath)
        
        var env = ProcessInfo.processInfo.environment
        // Tell gnirehtet where ADB is
        env["ADB"] = adbPath
        // Also add ADB dir to PATH for good measure
        let adbDir = (adbPath as NSString).deletingLastPathComponent
        let currentPath = env["PATH"] ?? ""
        env["PATH"] = "\(adbDir):\(currentPath)"
        newProcess.environment = env
        
        let pipe = Pipe()
        newProcess.standardOutput = pipe
        newProcess.standardError = pipe
        
        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                print("Gnirehtet: \(output)")
                // Detect specific error or success patterns if desired
            }
        }
        
        do {
            try newProcess.run()
            self.process = newProcess
            completion(true, "Started")
            NotificationManager.shared.show(title: "Gnirehtet Started", body: "Tethering is now active.")
        } catch {
            let msg = "Failed to start: \(error.localizedDescription)"
            completion(false, msg)
            NotificationManager.shared.show(title: "Start Failed", body: msg, isError: true)
        }
    }
    
    func stop() {
        if let process = process, process.isRunning {
            process.terminate()
            NotificationManager.shared.show(title: "Gnirehtet Stopped", body: "Tethering deactivated.")
        }
        process = nil

        // 2. Kill all gnirehtet related processes aggressively
        let killCommands = [
            ["-f", "gnirehtet.jar"],
            ["-f", "gnirehtet relay"]
        ]
        
        for args in killCommands {
            let killTask = Process()
            killTask.executableURL = URL(fileURLWithPath: "/usr/bin/pkill")
            killTask.arguments = args
            try? killTask.run()
            killTask.waitUntilExit()
        }
    }
    
    // MARK: - ADB Management
    
    func killADB() {
        runADBCommand(args: ["kill-server"])
        NotificationManager.shared.show(title: "ADB Killed", body: "ADB server has been stopped.")
    }
    
    func restartADB() {
        runADBCommand(args: ["kill-server"])
        Thread.sleep(forTimeInterval: 0.5)
        runADBCommand(args: ["start-server"])
        NotificationManager.shared.show(title: "ADB Restarted", body: "ADB server has been restarted.")
    }
    
    
    // MARK: - Traffic Monitor
    private func runADBCommand(args: [String]) {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: adbPath)
        task.arguments = args
        try? task.run()
        task.waitUntilExit()
    }
}
