//
//  CurrentWeatherController.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/21.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CurrentWeatherControllerDelegate: class
{
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
    
    fileprivate var bag = DisposeBag()
    var weatherVM: BehaviorRelay<CurrentWeatherViewModel> = BehaviorRelay(value: CurrentWeatherViewModel.empty)
    var locationVM: BehaviorRelay<CurrentLocationViewModel> = BehaviorRelay(value: CurrentLocationViewModel.empty)
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // 订阅
        Observable.combineLatest(locationVM, weatherVM) {
            return ($0, $1)
        }
        .filter {
            let (location, weather) = $0
            return !(location.isEmpty) && !(weather.isEmpty)
        }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {
            [unowned self] in
            let (location, weather) = $0
            
            self.activityIndicatorView.stopAnimating()
            self.weatherContainerView.isHidden = false
            
            self.locationLabel.text = location.city
            self.temperatureLabel.text = weather.temperature
            self.weatherIcon.image = weather.weatherIcon
            self.humidityLabel.text = weather.humidity
            self.summaryLabel.text = weather.summary
            self.dateLabel.text = weather.date
        }).disposed(by: bag)
    }

    
    // 更新UI
    func updateView()
    {
        weatherVM.accept(weatherVM.value)
        locationVM.accept(locationVM.value)
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


