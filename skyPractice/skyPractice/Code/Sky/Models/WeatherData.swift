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
    let daily: WeekWeather
    
    struct CurrentWeather: Codable {
        var time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
    
    struct WeekWeather: Codable {
        let data: [WeekData]
    }
    
    static let empty = WeatherData(latitude: 0, longitude: 0, currently: CurrentWeather(time: Date(), summary: "", icon: "", temperature: 0, humidity: 0), daily: WeekWeather(data: []))
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


extension WeatherData.WeekWeather: Equatable
{
    static func == (lhs: WeatherData.WeekWeather, rhs: WeatherData.WeekWeather) ->Bool
    {
        return lhs.data == rhs.data
    }
}


