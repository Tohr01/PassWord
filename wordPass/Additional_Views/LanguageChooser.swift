//
//  LanguageChooser.swift
//  wordPass
//
//  Created by Carl Raabe on 17.12.21.
//

import SwiftUI

struct LanguageChooser: View {
    @Binding var opacity : Double
    @Binding var current_language : String
    
    var body: some View {
        ZStack {
                Rectangle()
                    .fill(Color("default_appearance_inv"))
            VStack {
                Spacer()
                Text("Wähle eine Sprache / Select a language")
                    .foregroundColor(Color("default_appearance"))
                    .opacity(0.6)
                Spacer()
                HStack {
                    Spacer()
                    Spacer()
                    Button {
                        UserDefaults.standard.set("de", forKey: "lang")
                        current_language = "de"
                        self.opacity = 0
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(Color("default_appearance_inv"))
                                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                .frame(width: 100)
                            VStack {
                                Image("german_flag")
                                    .resizable()
                                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
                                .frame(width: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                Text("Deutsch")
                                    .foregroundColor(Color("default_appearance"))
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .shadow(radius: 15)
                    
                    Spacer()
                    
                    Button {
                        UserDefaults.standard.set("eng", forKey: "lang")
                        current_language = "eng"
                        self.opacity = 0
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(Color("default_appearance_inv"))
                                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                .frame(width: 100)
                        VStack {
                            Image("english_flag")
                                .resizable()
                            .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
                            .frame(width: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                            Text("English")
                                .foregroundColor(Color("default_appearance"))
                        }.contentShape(Rectangle())
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .shadow(radius: 15)
                    Spacer()
                    Spacer()
                }
                Spacer()
            }
        }
        .opacity(self.opacity)
        .animation(Animation.easeInOut, value: self.opacity)
    }
}
/*
struct LanguageChooser_Previews: PreviewProvider {
    static var previews: some View {
        LanguageChooser()
    }
}
*/
