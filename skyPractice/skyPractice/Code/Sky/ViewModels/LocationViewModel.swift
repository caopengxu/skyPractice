//
//  LocationViewModel.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/28.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationViewModel {
    
    let location: CLLocation?
    let locationText: String?
}


extension LocationViewModel: LocationRepresentable
{
    var labelText: String
    {
        if let locationText = locationText
        {
            return locationText
        }
        else if let location = location
        {
            return location.toString
        }
        
        return "Unknown position"
    }
}


