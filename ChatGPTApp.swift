//
//  ChatGPTApp.swift
//  RecipeBot
//
//  Created by tbarnes
//

import SwiftUI

@main
struct ChatGPTApp: App {
    
    @AppStorage("isOnboarding") var isOnboarding = true
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnBoarding()
            } else {
                SplashScreen()
            }
        }
    }
}
