//
//  SettingsDateViewModel.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/23.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

struct SettingsDateViewModel {
    
    let dateMode: DateModel
}


extension SettingsDateViewModel: SettingsRepresentable
{
    var labelText: String
    {
        return dateMode == .text ? "Fri, 01 December" : "F, 12/01"
    }
    
    var accessory: UITableViewCellAccessoryType
    {
        if UserDefaults.dateModel() == dateMode
        {
            return .checkmark
        }
        else
        {
            return .none
        }
    }
}


