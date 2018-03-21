//
//  WeatherData.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/21.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

struct WeatherData: Codable {
    var latitude: Double
    var longitude: Double
    let currently: CurrentWeather
    
    struct CurrentWeather: Codable {
        var time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
}


extension WeatherData: Equatable
{
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool
    {
        return lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.currently == rhs.currently
    }
}


extension WeatherData.CurrentWeather: Equatable
{
    static func == (lhs: WeatherData.CurrentWeather, rhs: WeatherData.CurrentWeather) -> Bool
    {
        return lhs.time == rhs.time &&
            lhs.summary == rhs.summary &&
            lhs.icon == rhs.icon &&
            lhs.temperature == rhs.temperature &&
            lhs.humidity == rhs.humidity
    }
}

