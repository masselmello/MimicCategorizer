//
//  Emotion.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 30.04.21.
//

import Foundation

class Emotion {
    let name: String
    let id: Int
    var recognized: Bool = false
    var recognizedEmotion: String
    static let neutralID = 0
    static let happyID = 1
    static let sadID = 2
    static let angryID = 3
    static let surpriseID = 4
    static let fearID = 5
    static let disgustID = 6
    static let contemptID = 7
   
    
    init(name: String, id: Int){
        self.name = name
        self.id = id
        self.recognizedEmotion = ""
    }
}
