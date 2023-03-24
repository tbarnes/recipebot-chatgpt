//
//  ViewModel.swift
//  RecipeBot
//
//  Created by tbarnes
//

import SwiftUI
import OpenAISwift


final class ViewModel: ObservableObject {
    private var client: OpenAISwift?
    
    //TODO: figure out how to properly store secrets in swift
    func setup() {
        client = OpenAISwift(authToken: "")
    }
    
    // Send Func to API to get response
    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text,
                               maxTokens: 500,
                               completionHandler: { result in
            switch result {
            case .success(let response):
                completion(response.choices.first?.text ?? "")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }
}
