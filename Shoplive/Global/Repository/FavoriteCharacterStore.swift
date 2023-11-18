//
//  Persistable.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation

protocol FavoriteCharacterStorable {
    
    func saveFavoriteCharacter(id: String, characterName: String, characterDescription: String, characterImage: String, saveDate: Date, completion: @escaping () -> Void)
    func removeOldestFavoriteCharacter(completion: @escaping () -> Void)
    func removeFavoriteCharacter(id: String, completion: @escaping () -> Void)
    func fetchFavoriteCharacters(completion: @escaping ([FavoriteCharacter]) -> Void)
    
}

