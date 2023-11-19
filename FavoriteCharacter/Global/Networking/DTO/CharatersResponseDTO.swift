//
//  CharatersResponseDTO.swift
//  FavoriteCharacter
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

extension Character {
    func toCharacterData() -> CharacterData? {
        guard let id = self.id,
              let name = self.name,
              let description = self.description,
              let thumbnail = self.thumbnail,
              let thumbnailPath = thumbnail.path,
              let thumbnailExtension = thumbnail.thumbnailExtension else {
            return nil
        }
        
        let url = URL(string: (thumbnailPath + "." + thumbnailExtension).convertToHTTPS())!
        
        return CharacterData(id: id.str, name: name, description: description, imageURL: url)
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


