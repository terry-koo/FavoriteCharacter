//
//  Service.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation

struct CharacterService: Serviceable {
    typealias ResponseType = CharatersResponseDTO
    
    func fetchResource(limit: Int, offset: Int, completion: @escaping (Result<ResponseType, APIError>) -> Void) {
        makeRequest(with: EndPoint.getCharacterCollection(limit: limit, offset: offset).asURLRequest()) { (response: ResponseType?, error) in
            if let error = error {
                debugPrint("[ERROR] \(error)")
                completion(.failure(error))
                return
            }
            
            if let response = response {
                completion(.success(response))
            }
        }
    }
}
