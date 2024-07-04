//
//  Extentions.swift
//  PassWord
//
//  Created by Carl Raabe on 28.12.21.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selec in
                self.wrappedValue = selec
                handler(selec)
            }
        )
    }
}

@available(macOS 11.0, *)
extension Scene {
    func windowFitToContentSize() -> some Scene {
            if #available(macOS 13.0, *) {
                return windowResizability(.contentSize)
            } else {
                return self
            }
        }
}
