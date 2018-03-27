//
//  SkyUIImage.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/21.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

extension UIImage
{    
    // 判断天气
    class func weatherIcon(of name: String) -> UIImage?
    {
        switch name {
        case "clear-day":
            return UIImage(named: "clear-day")
        case "clear-night":
            return UIImage(named: "clear-night")
        case "rain":
            return UIImage(named: "rain")
        case "snow":
            return UIImage(named: "snow")
        case "sleet":
            return UIImage(named: "sleet")
        case "wind":
            return UIImage(named: "wind")
        case "cloudy":
            return UIImage(named: "cloudy")
        case "partly-cloudy-day":
            return UIImage(named: "partly-cloudy-day")
        case "partly-cloudy-night":
            return UIImage(named: "partly-cloudy-night")
        default:
            return UIImage(named: "clear-day")
        }
    }
}


