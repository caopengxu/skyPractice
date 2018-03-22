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
    
    var viewMdoel: CurrentWeatherViewModel?
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
        
        if let viewModel = viewMdoel, viewModel.isUpdateReady
        {
            updateWeatherContainer(with: viewMdoel!)
        }
        else
        {
            loadingFailedLabel.isHidden = false
        }
    }
    
    
    // 更新UI(2)
    fileprivate func updateWeatherContainer(with viewModel: CurrentWeatherViewModel)
    {
        weatherContainerView.isHidden = false
        
        locationLabel.text = viewModel.city
        temperatureLabel.text = viewModel.temperature
        weatherIcon.image = viewModel.weatherIcon
        humidityLabel.text = viewModel.humidity
        summaryLabel.text = viewModel.summary
        dateLabel.text = viewModel.date
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


