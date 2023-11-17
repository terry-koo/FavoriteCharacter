//
//  Service.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation

struct CharacterService: Serviceable {
    func fetchCharacterCollections(limit: Int, offset: Int, completion: @escaping (Result<CharatersResponseDTO, APIError>) -> Void) {
        makeRequest(with: EndPoint.getCharacterCollection(limit: limit, offset: offset).asURLRequest()) { (response: CharatersResponseDTO?, error) in
            if let error = error {
                debugPrint("[ERROR \(#function)] \(error)")
                completion(.failure(error))
                return
            }
            
            if let response = response {
                completion(.success(response))
            }
        }
    }
    
    func fetchCharacterCollectionsWithNameStart(name: String, limit: Int, offset: Int, completion: @escaping (Result<CharatersResponseDTO, APIError>) -> Void) {
        makeRequest(with: EndPoint.getCharacterCollectionWithName(limit: limit, offset: offset, name: name).asURLRequest()) { (response: CharatersResponseDTO?, error) in
            if let error = error {
                debugPrint("[ERROR \(#function)] \(error)")
                completion(.failure(error))
                return
            }
            
            if let response = response {
                completion(.success(response))
            }
        }
    }
}
