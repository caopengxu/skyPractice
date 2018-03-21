//
//  CurrentWeatherController.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/21.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

protocol CurrentWeatherControllerDelegate: class {
    func locationButtonPressed(controller: CurrentWeatherController)
    func settingsButtonPressed(controller: CurrentWeatherController)
}


class CurrentWeatherController: WeatherController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: CurrentWeatherControllerDelegate?
    var now: WeatherData?
    {
        didSet
        {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    var location: Location?
    {
        didSet
        {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    // 更新UI(1)
    func updateView()
    {
        activityIndicatorView.stopAnimating()
        
        if let now = now,
            let location = location
        {
            updateWeatherContainer(with: now, at: location)
        }
        else
        {
            loadingFailedLabel.isHidden = false
        }
    }
    
    
    // 更新UI(2)
    fileprivate func updateWeatherContainer(with data: WeatherData, at location: Location)
    {
        weatherContainerView.isHidden = false
        
        locationLabel.text = location.name
        temperatureLabel.text = String(format: "%.1f °C", data.currently.temperature.toCelcius())
        weatherIcon.image = weatherIcon(of: data.currently.icon)
        humidityLabel.text = String(format: "%.1f %%", data.currently.humidity * 100)
        summaryLabel.text = data.currently.summary
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        dateLabel.text = formatter.string(from: data.currently.time)
    }
    
    
    // 点击定位按钮
    @IBAction func locationButtonClick(_ sender: UIButton)
    {
        delegate?.locationButtonPressed(controller: self)
    }
    
    
    // 点击设置按钮
    @IBAction func settingsButtonClick(_ sender: UIButton)
    {
        delegate?.settingsButtonPressed(controller: self)
    }
}


