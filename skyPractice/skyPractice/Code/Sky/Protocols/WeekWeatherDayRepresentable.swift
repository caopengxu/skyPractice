//
//  WeekWeatherDayRepresentable.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/27.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

protocol WeekWeatherDayRepresentable
{
    var week: String {get}
    var date: String {get}
    var temperature: String {get}
    var weatherIcon: UIImage? {get}
    var humidity: String {get}
}


