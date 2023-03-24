//
//  OnBoarding.swift
//  RecipeBot
//
//  Created by tbarnes
//

import SwiftUI


struct OnBoarding: View {
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
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
                        
                        Text("Your AI Bot For Recipes")
                            .font(.title2).bold()
                            .padding(8)
                        Text("Find out what's for dinner to night. Just ask RecipeBot and you'll get inspo and recipes in one place.")
                            .font(.subheadline).bold()
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                    }
                    
                    Button(action: {
                        isOnboarding = false
                    }) {
                        HStack {
                            Text("GET STARTED")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                        }
                        .padding()
                        .frame(width: 320, height: 65)
                        .background(.orange)
                        .cornerRadius(500)
                        
                    }.padding()
                    
                    Spacer()
                }
            }
        }
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding()
    }
}
