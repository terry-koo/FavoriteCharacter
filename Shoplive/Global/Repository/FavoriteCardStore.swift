//
//  Persistable.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation

protocol FavoriteCardStore {
    func saveFavoriteCard(id: String, characterName: String, characterDescription: String, characterImage: String, saveDate: Date, completion: @escaping () -> Void)

    func removeOldestFavoriteCard(completion: @escaping () -> Void)

    func removeFavoriteCard(id: String, completion: @escaping () -> Void)

    func fetchFavoriteCards(completion: @escaping ([FavoriteCard]) -> Void)
}

