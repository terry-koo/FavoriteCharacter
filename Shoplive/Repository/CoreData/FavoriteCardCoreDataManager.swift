//
//  FavoriteCardCoreDataManager.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation
import CoreData

class FavoriteCardCoreDataManager: FavoriteCardStore {
    
    func saveFavoriteCard(id: String, characterName: String, characterDescription: String, characterImage: String, saveDate: Date, completion: @escaping () -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let favoriteCard = FavoriteCard(context: context)
            favoriteCard.id = id
            favoriteCard.characterName = characterName
            favoriteCard.characterDescription = characterDescription
            favoriteCard.characterImage = characterImage
            favoriteCard.saveDate = saveDate
            
            do {
                try context.save()
                CoreDataStack.shared.saveContext()
                completion()
            } catch {
                print("Error saving favorite card: \(error)")
            }
        }
    }
    
    func removeOldestFavoriteCard(completion: @escaping () -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<FavoriteCard> = FavoriteCard.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "saveDate", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let oldestCard = try? context.fetch(fetchRequest).first {
                context.delete(oldestCard)
                do {
                    try context.save()
                    CoreDataStack.shared.saveContext()
                    completion()
                } catch {
                    print("Remove oldest favorite card error : \(error)")
                }
            }
        }
    }
    
    func removeFavoriteCard(id: String, completion: @escaping () -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<FavoriteCard> = FavoriteCard.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            if let result = try? context.fetch(fetchRequest) {
                for object in result {
                    context.delete(object)
                }
                do {
                    try context.save()
                    CoreDataStack.shared.saveContext()
                    completion()
                } catch {
                    print("Remove favorite card error : \(error)")
                }
            }
        }
    }
    
    func fetchFavoriteCards(completion: @escaping ([FavoriteCard]) -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<FavoriteCard> = FavoriteCard.fetchRequest()
            
            if let result = try? context.fetch(fetchRequest) {
                completion(result)
            } else {
                completion([])
            }
        }
    }
    
}
