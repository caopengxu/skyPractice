//
//  WeekWeatherViewModel.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/22.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

struct WeekWeatherViewModel {
    
    var weatherData: [WeekData]
    
    var numberOfSections: Int
    {
        return 1
    }
    
    var numberOfDays: Int
    {
        return weatherData.count
    }
    
    func viewModel(for index: Int) -> WeekWeatherDayRepresentable
    {
        return WeekWeatherDayViewModel(weatherData: weatherData[index])
    }
}


