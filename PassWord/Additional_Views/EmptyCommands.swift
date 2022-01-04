//
//  EmptyCommands.swift
//  PassWord
//
//  Created by Carl Raabe on 03.01.22.
//

import SwiftUI

struct EmptyCommands: Commands {
    @available(macOS 11.0, *)
    var body: some Commands {
        CommandGroup(replacing: .saveItem) {
            EmptyView()
        }
        CommandGroup(replacing: .undoRedo) {
            EmptyView()
        }
        CommandGroup(replacing: .pasteboard) {
            EmptyView()
        }
        CommandGroup(replacing: .newItem) {
            EmptyView()
        }
    }
}
