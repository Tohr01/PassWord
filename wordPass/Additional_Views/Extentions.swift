//
//  Extentions.swift
//  wordPass
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
        })
    }
}
