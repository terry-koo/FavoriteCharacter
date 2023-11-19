//
//  CharacterSearchable.swift
//  FavoriteCharacter
//
//  Created by Terry Koo on 11/18/23.
//

import Foundation

protocol CharacterSearchable {
    
    var characterCollectionDatas: Observable<[CharacterData]> { get }
    var apiError: Observable<APIError?> { get }
    var isLoading: Observable<Bool> { get }

    func fetchCharactersWithPagination()
    func getCharacterCollectionDataCount() -> Int
    func getCharacterData(index: Int) -> CharacterData
    func searchCharacterWithName(_ name: String)
    func searchTextDidChange(_ searchText: String)
    
}
