//
//  SplashScreen.swift
//  RecipeBot
//
//  Created by tbarnes
//


import SwiftUI

struct SplashScreen: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    // SplashScreen
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                VStack {
                    VStack {
                        HStack(spacing:2) {
                            // Logo Text
                            Text("RecipeBot")
                                .font(.title)
                                .foregroundColor(Color("text"))
                                .bold()
                            Image(systemName: "frying.pan")
                                .font(.system(size: 22))
                                .foregroundColor(.orange)
                        }
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
            }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
