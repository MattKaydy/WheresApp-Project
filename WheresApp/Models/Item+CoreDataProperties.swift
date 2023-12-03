//
//  Item+CoreDataProperties.swift
//  WheresApp
//
//  Created by macuser on 29/5/2023.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var credit_card_expiry_date: String?
    @NSManaged public var credit_card_name: String?
    @NSManaged public var credit_card_no: String?
    @NSManaged public var image_data: Data?
    @NSManaged public var keywords: [String]?
    @NSManaged public var loc_langtitude: String?
    @NSManaged public var loc_longtitude: String?
    @NSManaged public var loc_string: String?
    @NSManaged public var name: String?
    @NSManaged public var nature: String?
    @NSManaged public var receipt_grand_total: Float
    @NSManaged public var receipt_item_names: [String]?
    @NSManaged public var receipt_item_prices: [Decimal]?
    @NSManaged public var receipt_location: String?
    @NSManaged public var receipt_name: String?
    @NSManaged public var receipt_time: String?
    @NSManaged public var type: String?
    @NSManaged public var keywords_string: String?
}

extension Item : Identifiable {

}
