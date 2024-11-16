//
//  ScreenModel.swift
//  iOSTask
//
//  Created by Katherine Petalio on 11/13/24.
//

import Foundation

struct ActivityResponse: Codable {
    let title: String
    let description: String
    let duration: String
    let activity: Screens
}

struct Screens: Codable{
    let screens : [Screen]
}

struct Screen: Codable{
    
    let id: String
    let type: String
    let question: String?
    var multipleChoicesAllowed: Bool? = false
    let choices: [Choices]?
    let eyebrow: String?
    let body: String?
    let answers: [Answers]?
    let correctAnswer: String?
    
}

struct Choices: Codable{
    
    let id: String
    let text: String
    let emoji: String
    
}

struct Answers: Codable{
    let id: String
    let text: String
}
