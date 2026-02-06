import Cocoa

class TutorialWindowController: NSWindowController {
    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 600),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Konekin: Share Mac Network to Android"
        window.center()
        self.init(window: window)
        
        let contentView = NSView(frame: window.contentView!.bounds)
        window.contentView = contentView
        
        // Scroll View
        let scrollView = NSScrollView(frame: contentView.bounds)
        scrollView.hasVerticalScroller = true
        scrollView.autoresizingMask = [.width, .height]
        contentView.addSubview(scrollView)
        
        // Text View
        let textView = NSTextView(frame: scrollView.bounds)
        textView.isEditable = false
        textView.isRichText = true
        textView.autoresizingMask = [.width]
        textView.textContainer?.widthTracksTextView = true
        
        // Content
        let content = NSMutableAttributedString()
        
        func addHeader(_ text: String) {
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.boldSystemFont(ofSize: 18),
                .foregroundColor: NSColor.labelColor
            ]
            content.append(NSAttributedString(string: "\n" + text + "\n\n", attributes: attrs))
        }
        
        func addBody(_ text: String) {
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 14),
                .foregroundColor: NSColor.secondaryLabelColor
            ]
            content.append(NSAttributedString(string: text + "\n", attributes: attrs))
        }
        
        func addBullet(_ text: String) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.headIndent = 15
            paragraphStyle.firstLineHeadIndent = 0
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 14),
                .foregroundColor: NSColor.secondaryLabelColor,
                .paragraphStyle: paragraphStyle
            ]
            content.append(NSAttributedString(string: "• " + text + "\n", attributes: attrs))
        }
        
        addHeader("How to Connect")
        addBody("1. Enable Developer Options on your Android device:")
        addBullet("Go to Settings > About Phone.")
        addBullet("Tap 'Build Number' 7 times until you see a toast message.")
        
        addBody("\n2. Enable USB Debugging:")
        addBullet("Go to Settings > System > Developer Options.")
        addBullet("Toggle 'USB Debugging' to ON.")
        
        addBody("\n3. Connect and Authorize:")
        addBullet("Plug your phone into this Mac via USB.")
        addBullet("Check your phone screen for a popup 'Allow USB debugging?'.")
        addBullet("Check 'Always allow from this computer' and tap Allow.")
        
        addBody("\n4. Start Gnirehtet:")
        addBullet("Click 'Start Gnirehtet' in the menu bar menu.")
        addBullet("Accept the 'VPN Connection' request on your phone if prompted.")
        
        addHeader("Troubleshooting")
        addBody("Problem: 'No Android device detected'")
        addBullet("Check your USB cable (some are charge-only).")
        addBullet("Ensure USB Debugging is ON.")
        addBullet("Try revoking USB authorizations in Developer Options and reconnect.")
        
        addBody("\nProblem: 'Gnirehtet is Running' but no internet")
        addBullet("Check if the Key icon (VPN) is visible on your phone status bar.")
        addBullet("Stop Gnirehtet and try again.")
        addBullet("Ensure your Mac has a working internet connection.")
        
        textView.textStorage?.setAttributedString(content)
        
        scrollView.documentView = textView
    }
}
