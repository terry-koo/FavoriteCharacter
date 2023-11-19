//
//  FavoriteCharacterViewModel.swift
//  FavoriteCharacter
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation

protocol FavoriteCharacterViewModelProtocol: FavoriteCharacterRemoveManageable { }

struct FavoriteCharacterViewModel: FavoriteCharacterViewModelProtocol {

    var favoriteCharacterData: Observable<[CharacterData]> = Observable([])
    var apiError: Observable<APIError?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    
    private var repositoryManeger: FavoriteCharacterStorable
    
    init(repositoryManeger: FavoriteCharacterStorable = FavoriteCharacterCoreDataManager()) {
        self.repositoryManeger = repositoryManeger
        fetchFavoriteCharacters()
    }
    
    // -- FavoriteCharacterRemoveManageable -- //
    
    func getFavoriteCharacterDataCount() -> Int {
        favoriteCharacterData.value.count
    }
    
    func getFavoriteCharacter(index: Int) -> CharacterData? {
        favoriteCharacterData.value[index]
    }
    
    func fetchFavoriteCharacters() {
        isLoading.value = true
        repositoryManeger.fetchFavoriteCharacters { characters in
            self.favoriteCharacterData.value.removeAll()
            favoriteCharacterData.value = characters.compactMap { character in
                favoriteCharacterDataToCharacterData(character)
            }
            
            isLoading.value = false
        }
    }
    
    func deSelectFavoriteCharacter(index: Int) {
        let character = getFavoriteCharacter(index: index)
        
        isLoading.value = true
        
        repositoryManeger.removeFavoriteCharacter(id: character!.id) {
            fetchFavoriteCharacters()
        }
    }
    
    private func favoriteCharacterDataToCharacterData(_ favoriteCharacter: FavoriteCharacter) -> CharacterData? {
        guard let id = favoriteCharacter.id,
              let name = favoriteCharacter.characterName,
              let description = favoriteCharacter.characterDescription,
              let imageStr = favoriteCharacter.characterImage,
              let imageURL = URL(string: imageStr)
        else { return nil }
        
        return CharacterData(id: id, name: name, description: description, imageURL: imageURL)
    }

}
