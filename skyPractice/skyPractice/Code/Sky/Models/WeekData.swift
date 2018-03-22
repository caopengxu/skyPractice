
//
//  WeekData.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/22.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import Foundation

struct WeekData: Codable {
    var time: Date
    let temperatureLow: Double
    let temperatureHigh: Double
    let icon: String
    let humidity: Double
}


extension WeekData: Equatable
{
    static func == (lhs: WeekData, rhs: WeekData) -> Bool
    {
        return lhs.time == rhs.time &&
            lhs.temperatureLow == rhs.temperatureLow &&
            lhs.temperatureHigh == rhs.temperatureHigh &&
            lhs.icon == rhs.icon &&
            lhs.humidity == rhs.humidity
    }
}

