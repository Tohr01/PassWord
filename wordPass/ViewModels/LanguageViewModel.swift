//
//  LanguageViewModel.swift
//  wordPass
//
//  Created by Carl Raabe on 22.12.21.
//

import SwiftUI

class LanguageViewModel: ObservableObject {
    @Published var lang_set : Bool
    @Published var current_lang : String
    {
        didSet {
            old_lang = oldValue
        }
    }
    @Published var old_lang : String
    
    init(lang_set : Bool = false, current_lang : String = "eng", old_lang : String = "") {
        self.lang_set = lang_set
        self.current_lang = current_lang
        self.old_lang = old_lang
    }
}
