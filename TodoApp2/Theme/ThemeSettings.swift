//
//  ThemeSettings.swift
//  TodoApp2
//
//  Created by Terry Kuo on 2021/8/16.
//

import SwiftUI

//MARK: - Theme Class

class ThemeSettings: ObservableObject {
    @Published private(set) var activeError: String?
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            print("Setting theme")
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
            self.activeError = "Success changing theme"
        }
    }
    
    var isPresentingAlert: Binding<Bool> {
        return Binding<Bool>(get: {
            return self.activeError != nil
        }, set: { newValue in
            guard !newValue else { return }
            self.activeError = nil
        })
    }
    
    func showAlertView(with error: String) {
        activeError = error
    }
}
