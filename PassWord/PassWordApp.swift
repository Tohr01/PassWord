//
//  PassWordApp.swift
//  PassWord
//
//  Created by Carl Raabe on 08.12.21.
//

import SwiftUI

var appDelegate = OldAppDelegate()

/// Entry point
@main
enum AppUISelector {
    static func main() {
        if #available(macOS 11.0, *) {
            NewUIApp.main()
        } else {
            OldUIApp.main()
        }
    }
}

/// Handler for macOS Big Sur and up
@available(macOS 11.0, *)
struct NewUIApp: App {
    @NSApplicationDelegateAdaptor(NewAppDelegate.self) var app_delegate

    var body: some Scene {
        WindowGroup {
            MainView()
                .frame(width: 550, height: 170)
        }
        .windowFitToContentSize()
    }
}

/// Handler for macOS Catalina
enum OldUIApp {
    static func main() {
        NSApplication.shared.setActivationPolicy(.regular)

        let nib = NSNib(nibNamed: NSNib.Name("MainMenu"), bundle: Bundle.main)
        nib?.instantiate(withOwner: NSApplication.shared, topLevelObjects: nil)

        NSApp.delegate = appDelegate
        NSApp.activate(ignoringOtherApps: true)
        NSApp.run()
    }
}

/// App Delegate use by NewUIApp
class NewAppDelegate: NSObject, NSApplicationDelegate {
    var about_window: NSWindow!

    func applicationWillBecomeActive(_: Notification) {
        // Load menu
        let nib = NSNib(nibNamed: NSNib.Name("MainMenu"), bundle: Bundle.main)
        nib?.instantiate(withOwner: NSApplication.shared, topLevelObjects: nil)
    }

    func applicationDidFinishLaunching(_: Notification) {
        _ = NSApplication.shared.windows.map({
            $0.tabbingMode = .disallowed
            $0.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        }
        )
    }

    @IBAction func about(_ sender: Any) {
        // Open about window (or bring to front if already open)
        openAboutWin(window: &about_window)
    }
}

/// App Delegate use by OldUIApp
class OldAppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var about_window: NSWindow!

    func applicationDidFinishLaunching(_: Notification) {
        let contentView = MainView()

        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 500, height: 500), styleMask: [.titled, .miniaturizable, .resizable], backing: .buffered, defer: false)

        window.title = "PassWord"
        window.isReleasedWhenClosed = true
        window.center()
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    @IBAction func about(_ sender: Any) {
        openAboutWin(window: &about_window)
    }
}

/**
 Opens the About View in a NSWindow reference
 */
func openAboutWin(window: inout NSWindow!) {
    if window == nil || !window.isVisible {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 500, height: 500), styleMask: [.titled, .closable], backing: .buffered, defer: false)

        window.title = "PassWord Creator - About"
        window.isReleasedWhenClosed = false
        window.center()
        window.contentView = NSHostingView(rootView: AboutView())
        window.makeKeyAndOrderFront(nil)
    } else {
        window.makeKeyAndOrderFront(nil)
    }
}
