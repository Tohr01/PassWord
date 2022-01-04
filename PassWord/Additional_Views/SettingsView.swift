//
//  SettingsView.swift
//  PassWord
//
//  Created by Carl Raabe on 27.12.21.
//

import SwiftUI

struct language: Hashable {
    var language_display_name : String
    var language_identifier : String
}

struct SettingsView: View {
    @State var languages : [language] = [
        .init(language_display_name: "Deutsch", language_identifier: "de"),
        .init(language_display_name: "English", language_identifier: "eng")
    ]
    
    @State private var selected_language_index : Int = 1
    
    @Binding var current_language : String
    @Binding var equal_words : Bool
    @Binding var limit_chars : Bool
    @State private var limit_chars_wrapper : Bool = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                // MARK: Language selection
                Text(current_language == "eng" ? "Language selection:" : "Sprachauswahl:")
                    .font(.headline)
                Picker(selection: $selected_language_index.onChange({ _ in
                    let new_lang = languages[selected_language_index].language_identifier
                    
                    UserDefaults.standard.set(new_lang, forKey: "lang")
                    current_language = new_lang
                }), content: {
                        ForEach(0..<self.languages.count) { index in
                            Text(self.languages[index].language_display_name)
                        }
                }, label: {})
                
                Divider()
                
                Text(current_language == "eng" ? "Password settings:" : "Passworteinstellungen")
                    .font(.headline)
                
                // MARK: Equal word length selection
                Toggle(isOn: $equal_words.onChange({ _ in
                    
                }), label: {
                    Text("Equal word selection")
                })
                Text(current_language == "eng" ? "The password generator will try to select two words with the same length." : "Der Passwortgenerator versucht, zwei Wörter mit der gleichen Länge auszuwählen.")
                    .font(.footnote)
                    .opacity(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                    .opacity(0.5)
                
                // MARK: Limit characters of password
                Toggle(isOn: $limit_chars_wrapper.onChange({ _ in
                    UserDefaults.standard.set(limit_chars_wrapper, forKey: "limit_chars")
                    limit_chars = limit_chars
                })) {
                    Text(current_language == "eng" ? "Limit maximal password length" : "Maximale Passwortlänge begrenzen")
                }
                Text(current_language == "eng" ? "Limits the maximal word length to a default of 31 characters. If you want to generate longer passwords uncheck this option." : "Begrenzt die maximale Wortlänge auf einen Standardwert von 31 Zeichen. Wenn Sie längere Passwörter generieren möchten, deaktivieren Sie diese Option.")
                    .font(.footnote)
                    .opacity(0.7)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(width: 400, height: 250)
        .onAppear {
            limit_chars_wrapper = limit_chars
            selected_language_index = languages.map({$0.language_identifier}).firstIndex(of: current_language) ?? 0
    }
    }
}
/*
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
*/
