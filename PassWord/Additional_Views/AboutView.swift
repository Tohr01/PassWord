//
//  AboutView.swift
//  PassWord
//
//  Created by Carl Raabe on 10.01.22.
//

import SwiftUI

struct AboutView: View {
    @State var current_lang: String = "eng"
    @State var current_version: String = "1.0"
    private func initView() {
        if let current_language = UserDefaults.standard.value(forKey: "lang") as? String {
            current_lang = current_language
        }
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            current_version = appVersion
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("Version: \(current_version)")

            HStack {
                Image("hammer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .foregroundColor(Color("default_fg"))
                Divider()
                VStack(alignment: .leading) {
                    Text("Carl Raabe")
                        .font(.headline)

                    Text("Developer")
                        .font(.footnote)
                        .opacity(0.7)
                }
                Spacer()
                Image("github-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(0.7)
                    .foregroundColor(Color("default_fg"))
                    .opacity(0.8)
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: "https://github.com/Tohr01")!)
                    }
                Image("globe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(0.8)
                    .foregroundColor(Color("default_fg"))
                    .opacity(0.8)
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: "https://pixeldogs.de")!)
                    }
            }
            .frame(height: 35)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("default_fg")).opacity(0.1))
            Text("Copyright © 2021 - 2022 Carl Raabe")
                .font(.footnote)
                .opacity(0.7)
        }
        .padding()
        .frame(width: 350, height: 170)
        .onAppear {
            initView()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
