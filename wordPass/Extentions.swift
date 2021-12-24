//
//  Extentions.swift
//  wordPass
//
//  Created by Carl Raabe on 21.12.21.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func is_hidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
}
