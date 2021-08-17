//
//  ThemeSettings.swift
//  TodoApp2
//
//  Created by Terry Kuo on 2021/8/16.
//

import SwiftUI

//MARK: - Theme Class

class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
}
