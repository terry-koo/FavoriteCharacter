//
//  SearchViewModel.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation

class SearchViewModel {
    var characterCollectionDatas: Observable<[CharacterData]> = Observable([])
    var apiError: Observable<APIError?> = Observable(nil)
    var isFetching: Observable<Bool> = Observable(false)
    
    var characterService: CharacterService
    private var pageSize = 10 // 페이지당 아이템 개수
    private var currentPage = 1 // 현재 페이지
    private var totalItems = 0 // 전체 아이템 개수
    
    init(characterService: CharacterService = CharacterService()) {
        self.characterService = characterService
        getCharaterCollections()
    }
    
    // -- 전체 영웅 불러오기 -- //
    
    func getCharaterCollections() {
        if !isFetching.value {
            isFetching.value = true
            
            characterService.fetchCharacterCollections(limit: pageSize, offset: (currentPage - 1) * pageSize) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    self.handleSuccessResponse(response)
                case .failure(let error):
                    self.handleErrorResponse(error)
                }
                
                isFetching.value = false
            }
        }
    }
    
    func getCharacterCollectionDataCount() -> Int {
        return characterCollectionDatas.value.count
    }
    
    func getCharacterData(index: Int) -> CharacterData {
        return characterCollectionDatas.value[index]
    }
    
    // -- 데이터 응답 결과 처리 -- //
    
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
    
}

