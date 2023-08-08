//
//  SettingsView.swift
//  TodoApp2
//
//  Created by Terry Kuo on 2021/8/6.
//

import SwiftUI

struct SettingsView: View {
    
    //MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings: IconName
    
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    
    //MARK: - Body
    
    var body: some View {
        
        
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                //MARK: - FORM
                
                Form {
                    //MARK: - Secition 1
                    Section(header: Text("Choose the app icon")) {
                        Picker(selection: $iconSettings.currentIndex, label:
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .strokeBorder(Color.primary, lineWidth: 2)
                                        Image(systemName: "paintbrush")
                                            .font(.system(size: 28, weight: .regular, design: .default))
                                            .foregroundColor(Color.primary)
                                    }
                                    .frame(width: 44, height: 44)
                                    Text("App Icon".uppercased())
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.primary)
                                }
                               , content: {
                                
                            ForEach(0..<iconSettings.iconNames.count, id: \.self) { index in
                                    HStack {
//                                        Image(uiImage: UIImage(named: iconSettings.iconNames[index] ?? "Default Blue") ?? UIImage())
//                                            .renderingMode(.original)
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 44, height: 44, alignment: .center)
//                                            .cornerRadius(8)
//                                        Spacer().frame(width: 8)
                                        Text(iconSettings.iconNames[index] ?? "Default Blue")
                                            .frame(alignment: .leading)
                                    }//: HStack
                                    
                                    .padding(3)
                                    
                                }
                               })
                            .onReceive([self.iconSettings.currentIndex].publisher.first(), perform: { (value) in
                                let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                                if index != value {
                                    UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                                        if let error = error {
                                            print(error.localizedDescription)
                                        } else {
                                            print("Success changing icon")
                                        }
                                    }
                                }
                            })
                    } //: Section 1
                    .padding(.vertical,3)
                    
                    //MARK: - Section 2
                    Section(header:
                                HStack {
                                    Text("Choose the app theme")
                                    
                                    Circle()
                                        .fill(themes[self.theme.themeSettings].themeColor)
                                        .frame(width: 10, height: 10, alignment: .center)
                                }) {
                        List {
                            ForEach(themes, id: \.id) { item in
                                Button(action: {
                                    self.theme.themeSettings = item.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                }, label: {
                                    HStack {
                                        Circle()
                                            .fill(item.themeColor)
                                            .frame(width: 14, height: 14, alignment: .center)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 1.8))
                                        Text("\(item.themeName)")
                                    }//: HStack
                                })//: Button
                                .accentColor(.primary)
                            }//: ForEach
                        }//: List
                    } //: Section 2
                    .padding(.vertical, 3)
                    
                    //MARK: - Section 3
                    
                    Section(header: Text("Follow us on social media")) {
                        FormRowLinkView(icon: "globe", color: Color.pink, text: "Website", link: "")
                        FormRowLinkView(icon: "link", color: Color.blue, text: "Twitter", link: "https://twitter.com/home")
                        FormRowLinkView(icon: "play.rectangle", color: Color.green, text: "Courses", link: "https://www.youtube.com/channel/UCuafBQTj7JGByhzVuMhcOZg")
                    }
                    .padding(.vertical, 3)
                    
                    
                    //MARK: - Section 4
                    Section(header: Text("About the application")) {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Terry Kuo")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Universeye")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }
                    .padding(.vertical, 3)
                    
                    
                } //: Form
                
                //                .environment(\.horizontalSizeClass, .compact)
                
                //MARK: - Footer
                Text("Cpoyright All rights reserved. \nBetter Apps Less Code")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.secondary)
                
            }//: VStack
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }))
            .navigationBarTitle("Settings", displayMode: .inline)
            .background(Color("ColorBackground").edgesIgnoringSafeArea(.all))
            
        }//: NavigationView\
        .accentColor(themes[self.theme.themeSettings].themeColor)
    }
}


//MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(IconName())
    }
}
