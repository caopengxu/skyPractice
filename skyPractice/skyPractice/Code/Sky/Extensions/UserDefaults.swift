//
//  UserDefaults.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/23.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import Foundation

enum DateModel: Int
{
    case text
    case digit
    
    var format: String
    {
        return self == .text ? "E, dd MMMM" : "EEEEE, MM/dd"
    }
}


enum TemperatureModel: Int
{
    case celsius
    case fahrenheit
}


struct UserDefaultsKeys {
    static let dateModel = "dateModel"
    static let temperatureModel = "temperatureMode"
    static let locations = "locations"
}


extension UserDefaults
{
    // Date
    static func dateModel() -> DateModel
    {
        let value = UserDefaults.standard.integer(forKey: UserDefaultsKeys.dateModel)
        
        return DateModel(rawValue: value) ?? DateModel.text
    }
    static func setDateMode(to value: DateModel)
    {
        UserDefaults.standard.set(value.rawValue, forKey: UserDefaultsKeys.dateModel)
    }

    // Temperature
    static func temperatureModel() -> TemperatureModel
    {
        let value = UserDefaults.standard.integer(forKey: UserDefaultsKeys.temperatureModel)
        
        return TemperatureModel(rawValue: value) ?? TemperatureModel.celsius
    }
    static func setTemperatureModel(to value: TemperatureModel)
    {
        UserDefaults.standard.set(value.rawValue, forKey: UserDefaultsKeys.temperatureModel)
    }
    
    // Locations
    static func addLocation(_ location: Location)
    {
        var locations = loadLocations()
        locations.append(location)
        
        saveLocations(locations)
    }
    static func removeLocation(_ location: Location)
    {
        var locations = loadLocations()
        guard let index = locations.index(of: location) else
        {
            return
        }
        
        locations.remove(at: index)
        saveLocations(locations)
    }
    static func loadLocations() -> [Location]
    {
        let data = UserDefaults.standard.array(forKey: UserDefaultsKeys.locations)
        guard let dictionaries = data as? [[String: Any]] else {
            return []
        }
        
        return dictionaries.compactMap {
            return Location(from: $0)
        }
    }
    static func saveLocations(_ locations: [Location])
    {
        let dictionarys: [[String: Any]] = locations.map {$0.toDictionary}
        
        UserDefaults.standard.set(dictionarys, forKey: UserDefaultsKeys.locations)
    }
}


