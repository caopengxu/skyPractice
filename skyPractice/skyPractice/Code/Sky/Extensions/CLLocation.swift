//
//  CLLocation.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/28.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocation
{
    var toString: String
    {
        let latitude = String(format: "%.3f", coordinate.latitude)
        let longitude = String(format: "%.3f", coordinate.longitude)
        
        return latitude + "," + longitude
    }
}


