//
//  FavoriteCharacterRemoveManageable.swift
//  FavoriteCharacter
//
//  Created by Terry Koo on 11/18/23.
//

import Foundation

protocol FavoriteCharacterRemoveManageable {
    
    var favoriteCharacterData: Observable<[CharacterData]> { get }
    var apiError: Observable<APIError?> { get }
    var isLoading: Observable<Bool> { get }
    
    func fetchFavoriteCharacters()
    func deSelectFavoriteCharacter(index: Int)
    func getFavoriteCharacterDataCount() -> Int
    func getFavoriteCharacter(index: Int) -> CharacterData?
    
}
