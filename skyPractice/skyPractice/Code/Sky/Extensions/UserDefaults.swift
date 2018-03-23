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
}


extension UserDefaults
{
    static func dateModel() -> DateModel
    {
        let value = UserDefaults.standard.integer(forKey: UserDefaultsKeys.dateModel)
        
        return DateModel(rawValue: value) ?? DateModel.text
    }
    
    static func setDateMode(to value: DateModel)
    {
        UserDefaults.standard.set(value.rawValue, forKey: UserDefaultsKeys.dateModel)
    }
    
    static func temperatureModel() -> TemperatureModel
    {
        let value = UserDefaults.standard.integer(forKey: UserDefaultsKeys.temperatureModel)
        
        return TemperatureModel(rawValue: value) ?? TemperatureModel.celsius
    }
    
    static func setTemperatureModel(to value: TemperatureModel)
    {
        UserDefaults.standard.set(value.rawValue, forKey: UserDefaultsKeys.temperatureModel)
    }
}


