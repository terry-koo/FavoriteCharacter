//
//  FavoriteCard+CoreDataProperties.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//
//

import Foundation
import CoreData


extension FavoriteCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCard> {
        return NSFetchRequest<FavoriteCard>(entityName: "FavoriteCard")
    }

    @NSManaged public var saveDate: Date?
    @NSManaged public var characterImage: String?
    @NSManaged public var characterDescription: String?
    @NSManaged public var characterName: String?
    @NSManaged public var id: String?

}

extension FavoriteCard : Identifiable {

}
