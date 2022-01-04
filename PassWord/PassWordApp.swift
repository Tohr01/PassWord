//
//  PassWordApp.swift
//  PassWord
//
//  Created by Carl Raabe on 08.12.21.
//

import SwiftUI

var appDelegate = OldAppDelegate()

@main
struct AppUISelector {
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
        .commands {
            EmptyCommands()
        }
    }
}

struct OldUIApp {
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
    func applicationDidFinishLaunching(_ notification: Notification) {
        let _ = NSApplication.shared.windows.map({
            $0.tabbingMode = .disallowed
            $0.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        }
        )
        
        let nib = NSNib(nibNamed: NSNib.Name("MainMenu"), bundle: Bundle.main)
        nib?.instantiate(withOwner: NSApplication.shared, topLevelObjects: nil)
        //if let menu = NSApplication.shared.menu, let appname = Bundle.main.infoDictionary!["CFBundleName"] as? String {
        //    menu.items = menu.items.filter({$0.title == appname})
        //}
    }
}

class OldAppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = MainView()
        
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 500, height: 500), styleMask: [.titled, .miniaturizable, .resizable], backing: .buffered, defer: false)
        
        window.title = "Word Pass"
        window.isReleasedWhenClosed = true
        window.center()
        window.setFrameAutosaveName("Word Pass - Main")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        
    }
}

