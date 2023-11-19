//
//  FavoriteCharacterManageable.swift
//  FavoriteCharacter
//
//  Created by Terry Koo on 11/18/23.
//

import Foundation

protocol FavoriteCharacterManageable {
    
    var isLoading: Observable<Bool> { get }
    
    func fetchFavoriteCharacters()
    func selectFavoriteCharacter(index: Int)
    func isFavoriteCharacter(id: String) -> Bool
    
}
