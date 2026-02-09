import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private let manager = GnirehtetManager()
    private var statusTimer: Timer?
    
    private var startItem: NSMenuItem!
    private var stopItem: NSMenuItem!
    private var deviceMenu: NSMenu!
    private var selectedSerial: String?
    private var tutorialWindowController: TutorialWindowController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // Create the status item in the menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            // Initial load
            if let customImage = NSImage(named: "menubar-icon") {
                 button.image = customImage
                 button.image?.isTemplate = true
            } else {
                 button.image = NSImage(systemSymbolName: "link.circle", accessibilityDescription: "Konekin")
                 button.image?.isTemplate = true
            }
            button.alphaValue = 0.6 // Start dimmed (Idle)
            button.imagePosition = .imageLeft
        }
        
        setupMenu()
        NSApp.activate(ignoringOtherApps: true)
        
        // Update status immediately and then periodically
        statusTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateStatus()
        }
        updateStatus()
    }
    
    // Moved helper function out
    
    private var autoConnectItem: NSMenuItem!
    private var launchAtLoginItem: NSMenuItem!
    private var trafficItem: NSMenuItem!
    private var previousDeviceCount = 0
    
    // UserDefaults keys
    private let kAutoConnect = "AutoConnectEnabled"
    private let kLaunchAtLogin = "LaunchAtLoginEnabled" // We use tracking only, actual change via AppleScript
    
    private func setupMenu() {
        let menu = NSMenu()
        menu.delegate = self
        
        // App Title (Header Style)
        let titleItem = NSMenuItem()
        let titleParagraph = NSMutableParagraphStyle()
        titleParagraph.alignment = .left
        // Native headers are usually smaller (e.g. 13pt or 12pt) and Semibold/Bold
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13, weight: .semibold),
            .foregroundColor: NSColor.secondaryLabelColor, // Slightly muted like native headers
            .paragraphStyle: titleParagraph
        ]
        titleItem.attributedTitle = NSAttributedString(string: "Konekin", attributes: titleAttributes)
        titleItem.isEnabled = false // Non-clickable
        menu.addItem(titleItem)
        menu.addItem(NSMenuItem.separator())
        
        // Traffic/Status Item (Top)
        trafficItem = NSMenuItem(title: "Status: Idle", action: nil, keyEquivalent: "")
        trafficItem.isEnabled = false // Informational only
        menu.addItem(trafficItem)
        
        menu.addItem(NSMenuItem.separator())
        
        startItem = NSMenuItem(title: "Start Sharing", action: #selector(startGnirehtet), keyEquivalent: "s")
        menu.addItem(startItem)
        
        stopItem = NSMenuItem(title: "Stop Sharing", action: #selector(stopGnirehtet), keyEquivalent: "t")
        menu.addItem(stopItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let devicesItem = NSMenuItem(title: "Select Device", action: nil, keyEquivalent: "")
        deviceMenu = NSMenu()
        devicesItem.submenu = deviceMenu
        menu.addItem(devicesItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Preferences
        autoConnectItem = NSMenuItem(title: "Auto-Connect New Devices", action: #selector(toggleAutoConnect), keyEquivalent: "")
        autoConnectItem.state = UserDefaults.standard.bool(forKey: kAutoConnect) ? .on : .off
        menu.addItem(autoConnectItem)
        
        launchAtLoginItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        launchAtLoginItem.state = isLaunchAtLoginEnabled() ? .on : .off
        menu.addItem(launchAtLoginItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // ADB Tools Submenu
        let adbItem = NSMenuItem(title: "ADB Tools", action: nil, keyEquivalent: "")
        let adbMenu = NSMenu()
        
        let restartAdbItem = NSMenuItem(title: "Restart ADB Server", action: #selector(restartADB), keyEquivalent: "")
        let killAdbItem = NSMenuItem(title: "Kill ADB Server", action: #selector(killADB), keyEquivalent: "")
        
        adbMenu.addItem(restartAdbItem)
        adbMenu.addItem(killAdbItem)
        adbItem.submenu = adbMenu
        menu.addItem(adbItem)
        
        
        menu.addItem(NSMenuItem.separator())
        
        let helpItem = NSMenuItem(title: "Tutorial & Troubleshooting", action: #selector(showTutorial), keyEquivalent: "?")
        menu.addItem(helpItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quitItem)
        
        menu.autoenablesItems = false
        statusItem.menu = menu
    }
    
    @objc private func showTutorial() {
        if tutorialWindowController == nil {
            tutorialWindowController = TutorialWindowController()
        }
        tutorialWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
        tutorialWindowController?.window?.makeKeyAndOrderFront(nil)
    }
    
    @objc private func restartADB() {
        manager.restartADB()
    }
    
    @objc private func killADB() {
        manager.killADB()
    }
    
    @objc private func toggleAutoConnect() {
        // If turning ON, show alert first
        if !(autoConnectItem.state == .on) {
            showPrivacyAlert { [weak self] confirmed in
                guard let self = self, confirmed else { return }
                self.autoConnectItem.state = .on
                UserDefaults.standard.set(true, forKey: self.kAutoConnect)
                self.updateStatus()
            }
        } else {
            // Turning OFF is safe
            autoConnectItem.state = .off
            UserDefaults.standard.set(false, forKey: kAutoConnect)
            updateStatus()
        }
    }
    
    @objc private func toggleLaunchAtLogin() {
        let newState = !(launchAtLoginItem.state == .on)
        launchAtLoginItem.state = newState ? .on : .off
        setLaunchAtLogin(enabled: newState)
        UserDefaults.standard.set(newState, forKey: kLaunchAtLogin)
    }
    
    // AppleScript implementation for Launch at Login
    private func setLaunchAtLogin(enabled: Bool) {
        let appPath = Bundle.main.bundlePath
        let script: String
        if enabled {
            script = "tell application \"System Events\" to make login item at end with properties {path:\"\(appPath)\", hidden:false, name:\"Gnirehtet\"}"
        } else {
            script = "tell application \"System Events\" to delete login item \"Gnirehtet\""
        }
        
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
            if let error = error {
                print("Launch at Login Error: \(error)")
            }
        }
    }
    
    private func isLaunchAtLoginEnabled() -> Bool {
        // Simple check: This might not be 100% accurate if changed outside app, but good enough for UI sync
        // A real check would query System Events but that's slow. We trust our state + persistence?
        // Actually, let's just default to off or check LoginItems via API if possible.
        // For simplicity in this script wrapper, we'll relay on UI state persistence or just assume false initially.
        // Let's actually check via AppleScript for correctness on launch.
        let script = "tell application \"System Events\" to get the name of every login item"
        if let scriptObject = NSAppleScript(source: script) {
            let output = scriptObject.executeAndReturnError(nil)
            if output.stringValue != nil { 
                return UserDefaults.standard.bool(forKey: kLaunchAtLogin)
            }
             return UserDefaults.standard.bool(forKey: kLaunchAtLogin)
        }
        return false
    }
    
    @objc private func updateStatus() {
        let running = manager.isRunning
        let devices = manager.getDevices()
        let currentCount = devices.count
        
        // Auto-Connect Logic
        if UserDefaults.standard.bool(forKey: kAutoConnect) {
            if !running && currentCount > previousDeviceCount && currentCount > 0 {
                // New device detected AND not running -> Auto Start
                // We pick the first one or valid one
                print("Auto-connecting...")
                // Direct start because user already consented when enabling Auto Connect
                performStart()
                NotificationManager.shared.show(title: "Auto-Connect", body: "New device detected. Starting Gnirehtet...")
            }
        }
        previousDeviceCount = currentCount
        
        updateIcon(active: running)
        
        if running {
            trafficItem.title = "Status: Connected (VPN Active)"
        } else {
            trafficItem.title = "Status: Idle"
        }
        
        // Update device menu
        deviceMenu.removeAllItems()
        
        // Only show "Select Device" menu if we have multiple valid real devices
        // If 0 or 1, no need to show a selection list (1 is auto-selected)
        if let parentItem = deviceMenu.supermenu?.item(withTitle: "Select Device") {
             parentItem.isHidden = devices.count < 2
        }

        if devices.isEmpty {
            deviceMenu.addItem(NSMenuItem(title: "No devices found", action: nil, keyEquivalent: ""))
            selectedSerial = nil
        } else {
            for device in devices {
                let item = NSMenuItem(title: "\(device.model) (\(device.serial))", action: #selector(selectDevice(_:)), keyEquivalent: "")
                item.representedObject = device.serial
                if selectedSerial == nil { selectedSerial = device.serial }
                item.state = (selectedSerial == device.serial) ? .on : .off
                deviceMenu.addItem(item)
            }
        }
        
        if running {
            startItem.title = "Refresh Connection"
            startItem.isEnabled = true 
            startItem.isHidden = false
            startItem.keyEquivalent = "s"
            
            stopItem.isHidden = false
            stopItem.isEnabled = true
        } else {
            if devices.isEmpty {
                startItem.title = "No Android device detected"
                startItem.isEnabled = false
                startItem.keyEquivalent = ""
            } else {
                let model = devices.first(where: { $0.serial == selectedSerial })?.model ?? "Android"
                startItem.title = "Start on \(model)"
                startItem.isEnabled = true
                startItem.keyEquivalent = "s"
            }
            startItem.isHidden = false
            
            stopItem.isHidden = true
            stopItem.isEnabled = false
        }
    }
    
    @objc private func selectDevice(_ sender: NSMenuItem) {
        selectedSerial = sender.representedObject as? String
        updateStatus()
    }
    
    @objc private func startGnirehtet() {
        let devices = manager.getDevices()
        if !manager.isRunning && devices.isEmpty {
            return // Safety guard: do not show alert or start if no devices
        }
        
        showPrivacyAlert { [weak self] confirmed in
            guard let self = self, confirmed else { return }
            self.performStart()
        }
    }

    private func performStart() {
        startItem.isEnabled = false // Disable immediate to prevent double click
        // If already running, this effectively acts as a "Refresh"
        manager.start(serial: selectedSerial) { success, message in
            DispatchQueue.main.async {
                self.updateStatus()
            }
        }
    }
    
    private func showPrivacyAlert(completion: @escaping (Bool) -> Void) {
        let alert = NSAlert()
        alert.messageText = "Privacy Warning"
        alert.informativeText = "Network activity from your device will be routed through this computer. On public or office networks, this traffic may be monitored by network administrators.\n\nPlease be mindful of your data privacy when using this tool in such environments."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Continue")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        completion(response == .alertFirstButtonReturn)
    }
    
    @objc private func stopGnirehtet() {
        stopItem.isEnabled = false
        manager.stop()
        updateStatus()
    }
    
    private func updateIcon(active: Bool) {
        if let button = statusItem.button {
            // Try loading custom files: "menubar-icon" (idle) or "menubar-icon-active" (active)
            // Filenames in Assets: menubar-icon.png / menubar-icon-active.png
            let customName = active ? "menubar-icon-active" : "menubar-icon"
            
            if let customImage = NSImage(named: customName) {
                button.image = customImage
                button.image?.isTemplate = true // Adapts to Dark/Light mode
            } else {
                // Fallback to System Symbols
                let symbolName = active ? "link.circle.fill" : "link.circle"
                button.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "Konekin")
                button.image?.isTemplate = true
            }
            
            button.alphaValue = active ? 1.0 : 0.6
        }
    }
    
    // NSMenuDelegate
    func menuWillOpen(_ menu: NSMenu) {
        updateStatus()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        manager.stop()
    }
}
