//
//  FavoriteCharacterCoreDataManager.swift
//  FavoriteCharacter
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation
import CoreData

final class FavoriteCharacterCoreDataManager: FavoriteCharacterStorable {
    
    func saveFavoriteCharacter(id: String, characterName: String, characterDescription: String, characterImage: String, saveDate: Date, completion: @escaping () -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let favoriteCharacter = FavoriteCharacter(context: context)
            favoriteCharacter.id = id
            favoriteCharacter.characterName = characterName
            favoriteCharacter.characterDescription = characterDescription
            favoriteCharacter.characterImage = characterImage
            favoriteCharacter.saveDate = saveDate
            
            do {
                try context.save()
                CoreDataStack.shared.saveContext()
                completion()
            } catch {
                print("Error saving favorite character: \(error)")
            }
        }
    }
    
    func removeOldestFavoriteCharacter(completion: @escaping () -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "saveDate", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            if let oldestCharacter = try? context.fetch(fetchRequest).first {
                context.delete(oldestCharacter)
                do {
                    try context.save()
                    CoreDataStack.shared.saveContext()
                    completion()
                } catch {
                    print("Remove oldest favorite character error : \(error)")
                }
            }
        }
    }
    
    func removeFavoriteCharacter(id: String, completion: @escaping () -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
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
                    print("Remove favorite character error : \(error)")
                }
            }
        }
    }
    
    func fetchFavoriteCharacters(completion: @escaping ([FavoriteCharacter]) -> Void) {
        CoreDataStack.shared.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
            
            if let result = try? context.fetch(fetchRequest) {
                completion(result)
            } else {
                completion([])
            }
        }
    }
    
}
