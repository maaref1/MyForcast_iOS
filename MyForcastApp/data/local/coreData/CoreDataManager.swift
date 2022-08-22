//
//  CoreDataManager.swift
//  MyForcastApp
//
//  Created by MacBook Air on 20/08/2022.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    public static var shared = CoreDataManager()
    
    private override init() { }
    
    // Helper func for getting the current context.
    private func getContext() -> NSManagedObjectContext? {
        // guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return PersistenceService.context
    }
    
    /*
     This function will delete a table from CoreData
     */
    func deleteAllData(_ entity: String, completion:  @escaping (Bool) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try PersistenceService.context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                PersistenceService.context.delete(objectData)
                print("Entity '\(entity)' Deleted")
            }
            PersistenceService.saveContext()
            print("All entity '\(entity)' Data deleted successfully _ save changes")
            completion(true)
        } catch let error {
            print("Detele all data in \(entity) error :", error)
            completion(false)
        }
    }
}

extension CoreDataManager {
    /*
     This function will get list cities saved on DB
     */
    func getListCities() -> [ResultCity] {
        let fetchData: NSFetchRequest<CDCityModel> = CDCityModel.fetchRequest()
        do {
            let listCities: [CDCityModel] = try PersistenceService.context.fetch(fetchData)
            
            return listCities.map { model in
                return ResultCity(name: model.name ?? "",
                                  localNames: [:],
                                  lat: model.lat,
                                  lon: model.lon,
                                  country: model.country ?? "",
                                  state: model.state ?? "")
            }
        } catch let except {
            print("Exception occured = \(except.localizedDescription)")
        }
        return []
    }
    
    /*
     This function will get single city by name from DB
     */
    func getCityFromDb(name: String) -> CDCityModel? {
        let fetchData: NSFetchRequest<CDCityModel> = CDCityModel.fetchRequest()
        guard let obj = try? PersistenceService.context.fetch(fetchData) else {
            return nil
        }
        return obj.filter({$0.name?.lowercased() == name.lowercased()}).first
    }
    
    /*
     This function will add new city to DB
     */
    func addCityToLocalList(city: ResultCity) {
        guard let context = self.getContext() else {
            return
        }
        if let oldObj = self.getCityFromDb(name: city.name) {
            PersistenceService.context.delete(oldObj)
            PersistenceService.saveContext()
        }
        let model = CDCityModel(context: context)
        model.name = city.name
        model.country = city.country
        model.state = city.state
        model.lon = city.lon
        model.lat = city.lat
        PersistenceService.saveContext()
    }
    
    /*
     This function will remove a city by name from the DB
     */
    func removeCityFromLocalList(name: String) {
        if let oldObj = self.getCityFromDb(name: name) {
            PersistenceService.context.delete(oldObj)
            PersistenceService.saveContext()
            self.removeWeatherFromLocalList(name: name)
        }
    }
}

extension CoreDataManager {
    /*
     This function will get all list of weathers items saved on DB
     */
    func getListWeathers() -> [WeatherResponse] {
        let fetchData: NSFetchRequest<CDWeatherModel> = CDWeatherModel.fetchRequest()
        do {
            let listCities: [CDWeatherModel] = try PersistenceService.context.fetch(fetchData)
            return listCities.map { model in
                let city = self.getCityFromDb(name: model.name ?? "")
                return WeatherResponse(cityName: model.name ?? "",
                                       districtName: model.desc ?? "",
                                       lat: city?.lat ?? 0,
                                       lon: city?.lon ?? 0,
                                       timezone: nil,
                                       timezoneOffset: nil,
                                       current: .init(temp: model.temp ,
                                                      pressure: Int(model.pressure),
                                                      humidity: Int(model.humidity),
                                                      clouds: Int(model.humidity),
                                                      windSpeed: model.windSpeed,
                                                      weather: [
                                                        Weather(
                                                            icon: model.imgWeather ?? "")
                                                      ]))
            }
        } catch let except {
            print("Exception occured = \(except.localizedDescription)")
        }
        return []
    }
    
    /*
     This function will get weather by name from DB
     */
    func getWeatherFromDb(name: String) -> CDWeatherModel? {
        let fetchData: NSFetchRequest<CDWeatherModel> = CDWeatherModel.fetchRequest()
        guard let obj = try? PersistenceService.context.fetch(fetchData) else {
            return nil
        }
        return obj.filter({$0.name?.lowercased() == name.lowercased()}).first
    }
    
    /*
     This function will set new list of weathers to DB
     */
    func setWeatherList(list: [WeatherResponse]) {
        let fetchData: NSFetchRequest<CDWeatherModel> = CDWeatherModel.fetchRequest()
        guard let arr = try? PersistenceService.context.fetch(fetchData) else {
            return
        }
        arr.forEach { item in
            PersistenceService.context.delete(item)
            PersistenceService.saveContext()
        }
        
        list.forEach { item in
            self.saveSingleWeatherToDb(weatherModel: item)
        }
    }
    
    /*
     This function will add a single item weather to DB
     */
    func addWeatherToLocalList(weatherModel: WeatherResponse) {
        if let oldObj = self.getCityFromDb(name: weatherModel.cityName) {
            PersistenceService.context.delete(oldObj)
            PersistenceService.saveContext()
        }
        self.saveSingleWeatherToDb(weatherModel: weatherModel)
    }
    
    func saveSingleWeatherToDb(weatherModel: WeatherResponse) {
        let model = CDWeatherModel(context: PersistenceService.context)
        model.name = weatherModel.cityName
        model.desc = weatherModel.districtName
        model.temp = weatherModel.current?.temp ?? 0
        model.windSpeed = weatherModel.current?.windSpeed ?? 0
        model.humidity = Double(weatherModel.current?.humidity ?? 0)
        model.pressure = Double(weatherModel.current?.pressure ?? 0)
        model.clouds = Double(weatherModel.current?.clouds ?? 0)
        model.imgWeather = weatherModel.current?.weather.first?.icon ?? ""
        PersistenceService.saveContext()
    }
    
    /*
     This function will remove weather by name from DB 
     */
    func removeWeatherFromLocalList(name: String) {
        if let oldObj = self.getWeatherFromDb(name: name) {
            PersistenceService.context.delete(oldObj)
            PersistenceService.saveContext()
        }
    }
    
}
