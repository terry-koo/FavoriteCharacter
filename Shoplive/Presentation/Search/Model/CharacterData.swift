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
    
    init(id: String, name: String, description: String, imageURL: URL) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }
}
