//
//  CharacterData.swift
//  Shoplive
//
//  Created by Terry Koo on 11/16/23.
//

import Foundation

struct CharacterData {
    let id: String
    let name: String
    let description: String
    let imageURL: URL
    let savedDate: Date?
    
    init(id: String, name: String, description: String, imageURL: URL, savedDate: Date? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.savedDate = savedDate
    }
}
