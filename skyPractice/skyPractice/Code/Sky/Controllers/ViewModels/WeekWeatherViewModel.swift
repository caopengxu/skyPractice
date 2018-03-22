//
//  WeekWeatherViewModel.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/22.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

struct WeekWeatherViewModel {
    
    var weekData: [WeekData]
    
    private let dateFormatter = DateFormatter()
    
    
    var numberOfSections: Int
    {
        return 1
    }
    
    var numberOfDays: Int
    {
        return weekData.count
    }
    
    
    func week(for index: Int) -> String
    {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: weekData[index].time)
    }
    
    func date(for index: Int) -> String
    {
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: weekData[index].time)
    }
    
    func temperature(for index: Int) -> String
    {
        let min = String(format: "%.0f °C", weekData[index].temperatureLow.toCelsius())
        let max = String(format: "%.0f °C", weekData[index].temperatureHigh.toCelsius())
        return min + max
    }
    
    func weatherIcon(for index: Int) -> UIImage?
    {
        return UIImage.weatherIcon(of: weekData[index].icon)
    }
    
    func humidity(for index: Int) -> String
    {
        return String(format: "%.0f %%", weekData[index].humidity * 100)
    }
}


