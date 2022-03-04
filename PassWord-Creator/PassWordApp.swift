//
//  PassWordApp.swift
//  PassWord
//
//  Created by Carl Raabe on 08.12.21.
//

import SwiftUI

var appDelegate = OldAppDelegate()

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

@available(macOS 11.0, *)
struct NewUIApp: App {
    @NSApplicationDelegateAdaptor(NewAppDelegate.self) var app_delegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

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

class NewAppDelegate: NSObject, NSApplicationDelegate {
    var about_window: NSWindow!

    func applicationWillBecomeActive(_: Notification) {
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
        if about_window == nil || !about_window.isVisible {
            about_window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 500, height: 500), styleMask: [.titled, .closable], backing: .buffered, defer: false)

            about_window.title = "PassWord Creator - About"
            about_window.isReleasedWhenClosed = false
            about_window.center()
            about_window.contentView = NSHostingView(rootView: AboutView())
            about_window.makeKeyAndOrderFront(nil)
        } else {
            about_window.makeKeyAndOrderFront(nil)
        }
    }
}

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

    func applicationWillTerminate(_: Notification) {}

    @IBAction func about(_ sender: Any) {
        if about_window == nil || !about_window.isVisible {
            about_window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 500, height: 500), styleMask: [.titled, .closable], backing: .buffered, defer: false)

            about_window.title = "PassWord Creator - About"
            about_window.isReleasedWhenClosed = false
            about_window.center()
            about_window.contentView = NSHostingView(rootView: AboutView())
            about_window.makeKeyAndOrderFront(nil)
        } else {
            about_window.makeKeyAndOrderFront(nil)
        }
    }
}
