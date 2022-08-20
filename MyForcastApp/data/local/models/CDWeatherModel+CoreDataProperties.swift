//
//  CDWeatherModel+CoreDataProperties.swift
//  MyForcastApp
//
//  Created by MacBook Air on 20/08/2022.
//
//

import Foundation
import CoreData


extension CDWeatherModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWeatherModel> {
        return NSFetchRequest<CDWeatherModel>(entityName: "CDWeatherModel")
    }

    @NSManaged public var clouds: Double
    @NSManaged public var desc: String?
    @NSManaged public var humidity: Double
    @NSManaged public var imgWeather: String?
    @NSManaged public var name: String?
    @NSManaged public var pressure: Double
    @NSManaged public var temp: Double
    @NSManaged public var windSpeed: Double

}
