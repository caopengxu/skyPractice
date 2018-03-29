//
//  SettingsTemperatureViewModel.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/23.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

struct SettingsTemperatureViewModel {
    
    let temperatureMode: TemperatureModel
}


extension SettingsTemperatureViewModel: SettingsRepresentable
{
    var labelText: String
    {
        return temperatureMode == .celsius ? "Celsius" : "Fahrenhait"
    }
    var accessory: UITableViewCellAccessoryType
    {
        if UserDefaults.temperatureModel() == temperatureMode
        {
            return .checkmark
        }
        else
        {
            return .none
        }
    }
}


