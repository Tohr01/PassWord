//
//  ContentView.swift
//  PassWord
//
//  Created by Carl Raabe on 08.12.21.
//

import SwiftUI

struct MainView: View {
    // Current password
    @State private var current_password: String = ""
    @State private var handler: word_handler = .init(index: word_index_english)

    // Increase or decrease word length
    @ObservedObject private var stepper_model: StepperViewModel = .init(start_val: 15, min_value: 6, max_value: 31)

    // Language selection
    @ObservedObject var lang_model = LanguageViewModel()

    // Base settings
    @State private var show_settings: Bool = false
    @State private var equal_words: Bool = true
    @State private var limit_chars: Bool = true

    // Scalings
    @State private var scale_copy: CGFloat = 1
    @State private var scale_generate_new: CGFloat = 1
    @State private var scale_minus: CGFloat = 1
    @State private var scale_plus: CGFloat = 1
    @State private var scale_settings: CGFloat = 1

    func initView() {
        var index: [Int: String] = word_index_english
        print("Langcode \(Locale.current.languageCode!)")
        if let current_lang_code = Locale.current.languageCode, UserDefaults.standard.value(forKey: "firstLaunch") == nil {
            print("Code \(current_lang_code)")
            switch current_lang_code {
            case "de":
                UserDefaults.standard.set("de", forKey: "lang")
            default:
                break
            }
            UserDefaults.standard.set(false, forKey: "firstLaunch")
        }
        
        if let lang = UserDefaults.standard.value(forKey: "lang") as? String {
            print(lang)
            lang_model.lang_set = true
            lang_model.current_lang = lang
            switch lang {
            case "de":
                index = word_index_german
            case "en":
                print("en")
                index = word_index_english
            default:
                lang_model.lang_set = false
            }
        }
        if let equal_words = UserDefaults.standard.value(forKey: "equal_words") as? Bool {
            self.equal_words = equal_words
        }
        if let limit_chars = UserDefaults.standard.value(forKey: "limit_chars") as? Bool {
            self.limit_chars = limit_chars
        }

        handler = word_handler(index: index)

        if let generated_password = genPass(targetLength: stepper_model.value, handler: handler), let maxLength = handler.getMaximumDefaultLength(), let minLength = handler.getMinimumDefaultLength() {
            print("reached")
            current_password = generated_password
            print(minLength, maxLength)
            stepper_model.value = 15
            stepper_model.min_value = minLength - 1
            stepper_model.max_value = limit_chars ? 31 : maxLength
        }
    }

    func easy_gen_pass() {
        // Get current length
        let length = stepper_model.value
        if let new_pw = genPass(targetLength: length, handler: handler, evenWords: equal_words) {
            current_password = new_pw
        }
    }

    var body: some View {
        // MARK: Main Generator

        VStack(spacing: 10.0) {
            // MARK: Logo

            HStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            .frame(height: 30)
            /// # Password row
            HStack {
                // MARK: Password field

                HStack {
                    Image("key")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                        .foregroundColor(Color("default_fg_important"))
                    TextField("Generated password", text: $current_password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: 15, weight: .semibold, design: .monospaced))
                        .truncationMode(.tail)
                        .focusable(false)
                }
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color("default_fg_important"), lineWidth: 1))

                // MARK: Copy to clipboard button

                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(current_password, forType: .string)
                } label: {
                    Image("doc.on.doc")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.7)
                        .foregroundColor(Color("default_fg_important"))
                }
                .buttonStyle(PlainButtonStyle())
                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                .frame(width: 40, height: 40)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("default_bg"))
                    .shadow(color: Color("default_shadow"), radius: 6, x: 0, y: 4))
                .scaleEffect(scale_copy)
                .animation(Animation.easeInOut, value: scale_copy)

                .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { _ in
                        scale_copy = 0.8
                    }
                    .onEnded { _ in
                        scale_copy = 1
                    })
            }

            /// # Button row
            HStack {
                // MARK: Generate new password

                HStack {
                    Spacer()
                    Image("arrow.clockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                    Text("Generate new")
                        .font(Font.custom("Rubik-SemiBold", size: 15))
                        .truncationMode(.tail)
                    Spacer()
                }
                .foregroundColor(Color("default_fg"))
                .padding()
                .frame(height: 40)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("default_bg"))
                    .shadow(color: Color("default_shadow"), radius: 6, x: 0, y: 4))
                .scaleEffect(scale_generate_new)
                .animation(Animation.easeInOut, value: scale_generate_new)
                .onTapGesture(perform: {
                    easy_gen_pass()
                })
                .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { _ in
                        scale_generate_new = 0.8
                    }
                    .onEnded { _ in
                        scale_generate_new = 1
                    })

                Spacer()
                
                // MARK: Custom stepper

                // Increase word length button
                HStack {
                    Image("minus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.5)
                        .frame(width: 40, height: 40)
                        .contentShape(Rectangle())
                        .scaleEffect(scale_minus)
                        .animation(Animation.easeInOut, value: scale_minus)
                        .onTapGesture(perform: {
                            self.stepper_model.increase = false
                            self.stepper_model.increaseValue()
                            easy_gen_pass()
                        })
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged { _ in

                                self.stepper_model.increase = false
                                self.stepper_model.start()
                            }
                            .onEnded { _ in

                                self.stepper_model.stop()
                                easy_gen_pass()
                            }
                        )
                        .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged { _ in
                                scale_minus = 1.2
                            }
                            .onEnded { _ in
                                scale_minus = 1
                            }
                        )

                    Text(String(stepper_model.value))
                        .font(Font.custom("Rubik-SemiBold", size: 15))
                        .padding()

                    Image("plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.5)
                        .frame(width: 40, height: 40)
                        .contentShape(Rectangle())
                        .scaleEffect(scale_plus)
                        .animation(Animation.easeInOut, value: scale_plus)
                        .onTapGesture(perform: {
                            self.stepper_model.increase = true
                            self.stepper_model.increaseValue()
                            easy_gen_pass()
                        })
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged { _ in
                                self.stepper_model.increase = true
                                self.stepper_model.start()
                            }
                            .onEnded { _ in

                                self.stepper_model.stop()
                                easy_gen_pass()
                            }
                        )
                        .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged { _ in
                                scale_plus = 1.2
                            }
                            .onEnded { _ in
                                scale_plus = 1
                            }
                        )
                }
                .padding(.leading, 1)
                .padding(.trailing, 1)
                .frame(height: 40)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("default_bg"))
                    .shadow(color: Color("default_shadow"), radius: 6, x: 0, y: 4))

                // MARK: Settings
                Button {
                    self.show_settings.toggle()
                } label: {
                    Image("gearshape")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.7)
                        .foregroundColor(Color("default_fg"))
                }
                .popover(isPresented: $show_settings, arrowEdge: .bottom) {
                    SettingsView(current_language: $lang_model.current_lang.onChange { _ in
                        initView()
                    }, equal_words: $equal_words.onChange { _ in
                        easy_gen_pass()
                    }, limit_chars: $limit_chars.onChange { _ in
                        stepper_model.value = 15
                        initView()
                    })
                }
                .buttonStyle(PlainButtonStyle())
                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                .frame(width: 40, height: 40)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("default_bg"))
                    .shadow(color: Color("default_shadow"), radius: 6, x: 0, y: 4))
                .scaleEffect(scale_settings)
                .animation(Animation.easeInOut, value: scale_settings)
                .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { _ in
                        scale_settings = 0.8
                    }
                    .onEnded { _ in
                        scale_settings = 1
                    }
                )
            }
        }
        .padding()
        .zIndex(1)
        .onAppear {
            initView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
