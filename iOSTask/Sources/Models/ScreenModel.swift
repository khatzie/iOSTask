//
//  ScreenModel.swift
//  iOSTask
//
//  Created by Katherine Petalio on 11/13/24.
//

import Foundation

struct Screens: Codable {
    
    let screens: [ScreenModel]
    
}

struct ScreenModel: Codable{
    
    let id: String
    let type: String
    let question: String
    let multipleChoicesAllowed: Bool
    let choices: [ChoicesModel]
}

struct ChoicesModel: Codable{
    
    let id: String
    let text: String
    let emoji:String
    
}
