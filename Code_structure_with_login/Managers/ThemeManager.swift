//
//  ThemeManager.swift
//  Inheritx Solutions
//

import UIKit

struct AppColors {
    static let primary = UIColor(named: "primaryColor") ?? .systemBlue
    static let accent = UIColor(named: "buttonColor") ?? .systemIndigo
    static let background = UIColor.systemBackground
    static let error = UIColor.systemRed
    static let success = UIColor.systemGreen
}

struct AppFonts {
    static func bold(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    static func regular(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
}

class ThemeManager {
    static let shared = ThemeManager()
    
    func applyTheme() {
        // Global UI appearance settings
        UINavigationBar.appearance().tintColor = AppColors.primary
        UITextField.appearance().tintColor = AppColors.accent
    }
}
