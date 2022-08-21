//
//  CDCityModel+CoreDataProperties.swift
//  MyForcastApp
//
//  Created by MacBook Air on 20/08/2022.
//
//

import Foundation
import CoreData

extension CDCityModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCityModel> {
        return NSFetchRequest<CDCityModel>(entityName: "CDCityModel")
    }

    @NSManaged public var country: String?
    @NSManaged public var id: NSDecimalNumber?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var state: String?

}
