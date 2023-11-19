//
//  FavoriteCharacter+CoreDataProperties.swift
//  Shoplive
//
//  Created by Terry Koo on 11/17/23.
//
//

import Foundation
import CoreData


extension FavoriteCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCharacter> {
        return NSFetchRequest<FavoriteCharacter>(entityName: "FavoriteCharacter")
    }

    @NSManaged public var id: String?
    @NSManaged public var characterName: String?
    @NSManaged public var characterDescription: String?
    @NSManaged public var characterImage: String?
    @NSManaged public var saveDate: Date?

}

extension FavoriteCharacter : Identifiable {

}
