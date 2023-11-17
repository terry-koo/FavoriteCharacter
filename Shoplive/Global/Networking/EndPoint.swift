//
//  EndPoint.swift
//  Jobplanet
//
//  Created by Terry Koo on 10/28/23.
//

import Foundation

enum EndPoint: APIRouter {
    case getCharacterCollection(limit: Int, offset: Int)
    case getCharacterCollectionWithName(limit: Int, offset: Int, name: String)
    
    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com:443")!
    }
    
    var method: String {
        switch self {
        case .getCharacterCollection: return "GET"
        case .getCharacterCollectionWithName: return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .getCharacterCollection: return "/v1/public/characters"
        case .getCharacterCollectionWithName: return "/v1/public/characters"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getCharacterCollection(let limit, let offset):
            let timeStamp = String(Date().timeIntervalSince1970)
            let hash = (timeStamp + Bundle.main.PRIVATE_API_KEY + Bundle.main.PUBLIC_API_KEY).md5()
            
            return [
                "limit": limit,
                "offset": offset,
                "apikey": Bundle.main.PUBLIC_API_KEY,
                "ts": timeStamp,
                "hash": hash
            ]
        case .getCharacterCollectionWithName(let limit, let offset, let name):
            let timeStamp = String(Date().timeIntervalSince1970)
            let hash = (timeStamp + Bundle.main.PRIVATE_API_KEY + Bundle.main.PUBLIC_API_KEY).md5()
            
            return [
                "nameStartsWith": name,
                "limit": limit,
                "offset": offset,
                "apikey": Bundle.main.PUBLIC_API_KEY,
                "ts": timeStamp,
                "hash": hash
            ]
        }
    }
}
