//
//  Tone.swift
//  Alarm
//
//  Created by Yujin Kim on 2023-10-02.
//

import Foundation

class Tone: Codable {
    
    let name: String
    let filename: String
    
    init(name: String, filename: String) {
        self.name = name
        self.filename = filename
    }
    
    convenience init() {
        self.init(name: "기본", filename: "default.mp3")
    }
    
}
