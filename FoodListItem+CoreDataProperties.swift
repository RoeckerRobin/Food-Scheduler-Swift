//
//  FoodListItem+CoreDataProperties.swift
//  Food Scheduler Swift
//
//  Created by Robin Röcker on 05.12.22.
//
//

import Foundation
import CoreData


extension FoodListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodListItem> {
        return NSFetchRequest<FoodListItem>(entityName: "FoodListItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var expiryDate: Date?

}

extension FoodListItem : Identifiable {

}
