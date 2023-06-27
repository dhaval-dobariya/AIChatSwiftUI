//
//  OpenAIService.swift
//  ChatGPTDemo
//
//  Created by Dhaval Dobariya on 24/04/23.
//

import Foundation
import Alamofire

class OpenAIService {
    private let endpointUri = "https://api.openai.com/v1/chat/completions"
    
    
    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map({ OpenAIChatMessage(role: $0.role, content: $0.content) })

        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages)

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAPIKey)"
        ]

        return try? await AF.request(endpointUri, method: .post, parameters: body, encoder: .json, headers:headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}
