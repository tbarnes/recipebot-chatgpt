//
//  ChatMessages.swift
//  RecipeBot
//
//  Created by tbarnes
//

import SwiftUI

struct ChatMessage: Identifiable, Encodable, Decodable {
    let id: UUID
    let text: String
    let isMe: Bool
}
