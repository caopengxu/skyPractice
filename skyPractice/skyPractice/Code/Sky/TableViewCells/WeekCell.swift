//
//  WeekCell.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/22.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

class WeekCell: UITableViewCell {
    
    static let reuseIdentifier = "WeekWeatherCell"
    
    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humid: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    func configure(with vm: WeekWeatherDayRepresentable)
    {
        week.text = vm.week
        date.text = vm.date
        temperature.text = vm.temperature
        weatherIcon.image = vm.weatherIcon
        humid.text = vm.humidity
    }
}


