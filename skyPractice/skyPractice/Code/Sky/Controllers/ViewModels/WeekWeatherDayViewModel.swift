//
//  WeekWeatherDayViewModel.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/27.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

struct WeekWeatherDayViewModel {
    
    let weatherData: WeekData
    
    private let dateFormatter = DateFormatter()
    
    var week: String
    {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: weatherData.time)
    }
    
    var date: String
    {
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: weatherData.time)
    }
    
    var temperature: String
    {
        let min = format(temperature: weatherData.temperatureLow)
        let max = format(temperature: weatherData.temperatureHigh)
        return min + "~" + max
    }
    
    var weatherIcon: UIImage?
    {
        return UIImage.weatherIcon(of: weatherData.icon)
    }
    
    var humidity: String
    {
        return String(format: "%.0f %%", weatherData.humidity * 100)
    }
    
    // helpers
    private func format(temperature: Double) -> String
    {
        switch UserDefaults.temperatureModel() {
        case .fahrenheit:
            return String(format: "%.1f °F", temperature)
        case .celsius:
            return String(format: "%.1f °C", temperature.toCelsius())
        }
    }
}


extension WeekWeatherDayViewModel: WeekWeatherDayRepresentable {}


