//
//  CharatersResponseDTO.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation

// MARK: - CharatersResponseDTO
struct CharatersResponseDTO: Codable {
    let code: Int?
    let data: Response?
}

// MARK: - Response
struct Response: Codable {
    let offset, limit, total, count: Int?
    let results: [Character]?
}

// MARK: - Character
struct Character: Codable {
    let id: Int?
    let name, description: String?
    let thumbnail: Thumbnail?
}

}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path, thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}


