//
//  CharacterSearchViewModelProtocol.swift
//  FavoriteCharacter
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation

protocol CharacterSearchViewModelProtocol: CharacterSearchable, FavoriteCharacterManageable { }

final class CharacterSearchViewModel: CharacterSearchViewModelProtocol {
    
    var characterCollectionDatas: Observable<[CharacterData]> = Observable([])
    var apiError: Observable<APIError?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var favoriteCharacterIds: [String] = []
    
    private var characterService: CharacterService
    private var repositoryManager: FavoriteCharacterStorable
    
    private var userInput: String = ""
    
    private var pageSize = 10
    private var currentPage = 1
    private var totalItems = 0
    
    init(characterService: CharacterService = CharacterService(),
         repositoryManager: FavoriteCharacterStorable = FavoriteCharacterCoreDataManager()
    ) {
        self.characterService = characterService
        self.repositoryManager = repositoryManager
        
        fetchCharactersWithPagination()
        fetchFavoriteCharacters()
    }
    
    // -- CharacterSearchable -- //
    
    func fetchCharactersWithPagination() {
        if !isLoading.value {
            isLoading.value = true
            
            characterService.fetchCharacterCollections(limit: pageSize, offset: (currentPage - 1) * pageSize) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    self.handleSuccessResponse(response)
                case .failure(let error):
                    self.handleErrorResponse(error)
                }
                
                isLoading.value = false
            }
        }
    }
    
    func getCharacterCollectionDataCount() -> Int {
        return characterCollectionDatas.value.count
    }
    
    func getCharacterData(index: Int) -> CharacterData {
        return characterCollectionDatas.value[index]
    }
    
    func searchCharacterWithName(_ name: String) {
        if !isLoading.value {
            isLoading.value = true
            
            characterService.fetchCharacterCollectionsWithNameStart(name: name, limit: pageSize, offset: (currentPage - 1) * pageSize) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    self.handleSuccessResponse(response)
                case .failure(let error):
                    self.handleErrorResponse(error)
                }
                
                isLoading.value = false
            }
        }
    }
    
    func searchTextDidChange(_ searchText: String) {
        searchDebouncer.call()
        self.userInput = searchText
    }
    
    private func getCharacterData(id: String) -> CharacterData? {
        return characterCollectionDatas.value.filter { $0.id == id }.first
    }
    
    private func resetPagination() {
        currentPage = 1
        totalItems = 0
        characterCollectionDatas.value = []
    }
    
    private lazy var searchDebouncer: Debouncer = {
        return Debouncer(delay: 0.3) { [weak self] in
            self?.performSearch()
        }
    }()
    
    private func performSearch() {
        if userInput.isEmpty {
            resetPagination()
            fetchCharactersWithPagination()
        }
        
        if userInput.count >= 2 {
            resetPagination()
            searchCharacterWithName(userInput)
        }
    }
    
    private func handleSuccessResponse(_ response: CharatersResponseDTO) {
        guard let data = response.data?.results,
              let total = response.data?.total
        else { return }
        
        self.totalItems = total
        self.currentPage += 1
        
        characterCollectionDatas.value += data.compactMap { value in
            value.toCharacterData()
        }
        apiError.value = nil
    }
    
    private func handleErrorResponse(_ error: APIError) {
        apiError.value = error
    }
    
    // -- FavoriteCharacterManageable -- //
    
    func fetchFavoriteCharacters() {
        isLoading.value = true
        
        repositoryManager.fetchFavoriteCharacters { characters in
            self.favoriteCharacterIds.removeAll()
            characters.forEach { character in
                guard let id = character.id else { return }
                self.favoriteCharacterIds.append(id)
            }
            self.isLoading.value = false
        }
    }
    
    func selectFavoriteCharacter(index: Int) {
        let character = getCharacterData(index: index)
        
        isLoading.value = true
        
        if isFavoriteCharacter(id: character.id) {
            removeFavoriteCharacter(character)
        } else {
            handleNonFavoriteCharacter(character)
        }
    }
    
    func isFavoriteCharacter(id: String) -> Bool {
        return favoriteCharacterIds.contains(where: { $0 == id })
    }
    
    private func removeFavoriteCharacter(_ character: CharacterData) {
        repositoryManager.removeFavoriteCharacter(id: character.id) { [weak self] in
            self?.fetchFavoriteCharacters()
        }
    }
    
    private func handleNonFavoriteCharacter(_ character: CharacterData) {
        if favoriteCharacterIds.count >= 5 {
            removeOldestAndSaveNewFavoriteCharacter(character)
        } else {
            saveNewFavoriteCharacter(character)
        }
    }
    
    private func removeOldestAndSaveNewFavoriteCharacter(_ character: CharacterData) {
        repositoryManager.removeOldestFavoriteCharacter { [weak self] in
            self?.saveNewFavoriteCharacter(character)
        }
    }
    
    private func saveNewFavoriteCharacter(_ character: CharacterData) {
        repositoryManager.saveFavoriteCharacter(
            id: character.id,
            characterName: character.name,
            characterDescription: character.description,
            characterImage: character.imageURL.absoluteString,
            saveDate: Date()
        ) { [weak self] in
            self?.fetchFavoriteCharacters()
        }
    }
    
}
