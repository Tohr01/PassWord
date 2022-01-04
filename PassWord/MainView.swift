//
//  ContentView.swift
//  PassWord
//
//  Created by Carl Raabe on 08.12.21.
//

import SwiftUI
import Combine

struct MainView: View {
    // Current password
    @State var current_password: String = ""
    @State var handler: word_handler = word_handler(index: word_index_english)
    
    // Increase or decrease word length
    @ObservedObject var stepper_model : StepperViewModel = StepperViewModel(start_val: 15, min_value: 6, max_value: 31)
    
    // Language selection
    @ObservedObject var lang_model = LanguageViewModel()
    
    // Base settings
    @State var show_settings: Bool = false
    @State var equal_words: Bool = true
    @State var limit_chars: Bool = true
    
    // Button background opacities
    @State var opacity_generate_new_button = 0.1
    @State var opacity_minus_button = 0.0
    @State var opacity_plus_button = 0.0
    @State var opacity_settings_button = 0.1
    @State var opacity_copy_buttom = 0.1
    
    func initView() {
        var index : [Int : String] = word_index_english
        if let lang = UserDefaults.standard.value(forKey: "lang") as? String {
            print(lang)
            lang_model.lang_set = true
            lang_model.current_lang = lang
            switch lang {
            case "de":
                index = word_index_german
            case "eng":
                print("eng")
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
#warning("settings for even words")
        if let new_pw = genPass(targetLength: length, handler: handler, evenWords: equal_words) {
            current_password = new_pw
        }
    }
    
    var body: some View {
        ZStack {
            // MARK: Main Generator
            VStack(spacing: 10.0) {
                ///# Password row
                HStack {
                    // MARK: Password field
                    HStack {
                        Image("key")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundColor(Color("default_appearance"))
                        TextField(lang_model.current_lang == "de" ? "Generiertes Passwort" : "Generated password", text: $current_password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.system(size: 15, weight: .semibold, design: .monospaced))
                            .truncationMode(.tail)
                            .focusable(false)
                        
                    }.frame(height: 40)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(Color("default_appearance"), lineWidth: 2))
                    
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
                            .foregroundColor(Color("default_appearance"))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .aspectRatio(CGSize(width: 1, height: 1) ,contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .opacity(0.5)
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("default_appearance")).opacity(opacity_copy_buttom))
                    .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ _ in
                        self.opacity_copy_buttom = 0.2
                    })
                                            .onEnded({ _ in
                        self.opacity_copy_buttom = 0.1
                    }))
                }
                
                ///# Button row
                HStack {
                    // MARK: Generate new password
                    HStack {
                        Spacer()
                        Image("arrow.clockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundColor(Color("default_appearance"))
                        Text(lang_model.current_lang == "de" ? "Neu generieren" : "Generate new")
                            .font(.system(size: 15, weight: .semibold, design: .monospaced))
                            .truncationMode(.tail)
                        Spacer()
                    }
                    .padding()
                    .frame(height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("default_appearance")).opacity(opacity_generate_new_button))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .onTapGesture(perform: {
                        easy_gen_pass()
                    })
                    .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ _ in
                        self.opacity_generate_new_button = 0.2
                    })
                                            .onEnded({ _ in
                        self.opacity_generate_new_button  = 0.1
                    }))
                    
                    // MARK: Custom stepper
                    // Increase word length button
                    HStack {
                        Image("minus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(0.5)
                            .frame(width: 40, height: 40)
                            .contentShape(Rectangle())
                            .overlay(RoundedRectangle(cornerRadius: 0).fill(Color("default_appearance").opacity(opacity_minus_button)))
                            .onTapGesture(perform: {
                                self.stepper_model.increase = false
                                self.stepper_model.increaseValue()
                                easy_gen_pass()
                            })
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                        .onChanged({ _ in
                                self.opacity_minus_button = 0.2
                                self.stepper_model.increase = false
                                self.stepper_model.start()
                            })
                                        .onEnded({ _ in
                                opacity_minus_button = 0.1
                                self.stepper_model.stop()
                                easy_gen_pass()
                            })
                            )
                            .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                                    .onChanged({ _handler in
                                self.opacity_minus_button = 0.1
                            })
                                                    .onEnded({ _ in
                                self.opacity_minus_button = 0.0
                            })
                            )
                        
                        Text(String(stepper_model.value))
                            .font(.system(size: 15, weight: .medium, design: .monospaced))
                            .padding()
                        
                        Image("plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(0.5)
                            .frame(width: 40, height: 40)
                            .contentShape(Rectangle())
                            .overlay(RoundedRectangle(cornerRadius: 0).fill(Color("default_appearance").opacity(opacity_plus_button)))
                            .onTapGesture(perform: {
                                self.stepper_model.increase = true
                                self.stepper_model.increaseValue()
                                easy_gen_pass()
                            })
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                        .onChanged({ _ in
                                self.stepper_model.increase = true
                                self.stepper_model.start()
                            })
                                        .onEnded({ _ in
                                self.opacity_plus_button = 0.0
                                self.stepper_model.stop()
                                easy_gen_pass()
                            })
                            )
                            .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                                    .onChanged({ _handler in
                                self.opacity_plus_button = 0.1
                            })
                                                    .onEnded({ _ in
                                self.opacity_plus_button = 0.0
                            })
                            )
                    }
                    .padding(.leading, 1)
                    .padding(.trailing, 1)
                    .frame(height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("default_appearance")).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .frame(height: 40)
                    
                    // MARK: Settings
                    Button {
                        self.show_settings.toggle()
                    } label: {
                            Image("gear")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(0.7)
                                .opacity(0.5)
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                    .popover(isPresented: $show_settings, arrowEdge: .bottom) {
                        SettingsView(current_language: $lang_model.current_lang.onChange({ _ in
                            initView()
                        }), equal_words: $equal_words.onChange({ _ in
                            easy_gen_pass()
                        }), limit_chars: $limit_chars.onChange({ _ in
                            stepper_model.value = 15
                            initView()
                        }))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("default_appearance")).opacity(opacity_settings_button))
                    
                   

                }
            }
            .padding()
            .zIndex(1)
        }
        .frame(minWidth: 470, idealWidth: 470, maxWidth: 800, minHeight: 125, idealHeight: 125, maxHeight: 150)
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
