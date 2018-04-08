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
        let viewModel = Observable.combineLatest(locationVM, weatherVM) {
            return ($0, $1)
        }
        .filter {
            let (location, weather) = $0
            return !(location.isEmpty) && !(weather.isEmpty)
        }
        .share(replay: 1, scope: .whileConnected)
        .asDriver(onErrorJustReturn: (CurrentLocationViewModel.empty, CurrentWeatherViewModel.empty))
    
        viewModel.map {_ in false}.drive(self.activityIndicatorView.rx.isAnimating).disposed(by: bag)
        viewModel.map {_ in false}.drive(self.weatherContainerView.rx.isHidden).disposed(by: bag)
        
        viewModel.map {$0.0.city}.drive(self.locationLabel.rx.text).disposed(by: bag)
        viewModel.map {$0.1.temperature}.drive(self.temperatureLabel.rx.text).disposed(by: bag)
        viewModel.map {$0.1.weatherIcon}.drive(self.weatherIcon.rx.image).disposed(by: bag)
        viewModel.map {$0.1.humidity}.drive(self.humidityLabel.rx.text).disposed(by: bag)
        viewModel.map {$0.1.summary}.drive(self.summaryLabel.rx.text).disposed(by: bag)
        viewModel.map {$0.1.date}.drive(self.dateLabel.rx.text).disposed(by: bag)
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


