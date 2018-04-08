//
//  SkyController.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/21.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

class SkyController: UIViewController {

    var currentLocation: CLLocation?
    {
        didSet
        {
            fetchCity()
            fetchWeather()
        }
    }
    fileprivate lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        
        return manager
    }()
    
    var currentWeatherController: CurrentWeatherController!
    fileprivate let segueCurrentWeather = "SegueCurrentWeather"
    
    var weekWeatherController: WeekWeatherController!
    fileprivate let segueWeekWeather = "SegueWeekWeather"
    
    fileprivate let segueSettings = "SegueSettings"
    fileprivate let segueLocation = "SegueLocation"
    
    private var bag = DisposeBag()
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {}
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupActiveNotification()
    }
    
    
    // prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let identifier = segue.identifier
        {
            switch identifier {
            case "":
                fatalError("没有设置identifier")
            case segueCurrentWeather:
                guard let destination = segue.destination as? CurrentWeatherController else
                {
                    fatalError("Invalid destination view controller.")
                }
                
                destination.delegate = self
                currentWeatherController = destination
            case segueWeekWeather:
                guard let destination = segue.destination as? WeekWeatherController else
                {
                    fatalError("Invalid destination view controller.")
                }
                
                weekWeatherController = destination
            case segueSettings:
                guard let navigationController = segue.destination as? UINavigationController else
                {
                    fatalError("Invalid destination view controller.")
                }
                
                guard let destination = navigationController.topViewController as? SettingsController else
                {
                    fatalError("Invalid destination view controller.")
                }
                
                destination.delegate = self
            case segueLocation:
                guard let navigationController = segue.destination as? UINavigationController else
                {
                    fatalError("segue error")
                }
                
                guard let destination = navigationController.topViewController as? LocationController else
                {
                    fatalError("segue error")
                }
                
                destination.delegate = self
                destination.currentLocation = currentLocation
            default:
                break
            }
        }
    }
    
    
    // 设置地理授权的通知
    fileprivate func setupActiveNotification()
    {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(notification:)),
            name: Notification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }
    
    
    // 请求地理授权
    @objc func applicationDidBecomeActive(notification: Notification)
    {
//        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
//            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.rx.didUpdateLocations.take(1).subscribe(
                onNext: {
                    self.currentLocation = $0.first
            }).disposed(by: bag)
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    // 地理编码获取城市信息
    private func fetchCity()
    {
        guard let currentLocation = currentLocation else {return}
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {
            placemarks, error in
            if let error = error
            {
                dump(error)
            }
            else if let city = placemarks?.first?.locality
            {
                let location = Location(name: city, latitude: lat, longitude: lon)
                
                self.currentWeatherController.locationVM.accept(CurrentLocationViewModel(location: location))
            }
        })
    }
    
    
    // 根据地理位置获取天气信息
    private func fetchWeather()
    {
        guard let currentLocation = currentLocation else {return}
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        let weather = WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon)
            .share(replay: 1, scope: .whileConnected)
//            .asDriver(onErrorJustReturn: WeatherData.empty)
        
        
//        weather.map {CurrentWeatherViewModel(weather: $0)}.drive(self.currentWeatherController.weatherVM).disposed(by: bag)
//        weather.map {}
        weather.map { CurrentWeatherViewModel(weather: $0) }
            .bind(to: self.currentWeatherController.weatherVM)
            .disposed(by: bag)
//        weather.map { WeekWeatherViewModel(weatherData: $0.daily.data) }
//            .subscribe({
//                self.weekWeatherController.viewModel = $0
//            })
//            .disposed(by: bag)
        
        
        
        
//            .subscribe(onNext: {
//                self.currentWeatherController.weatherVM.accept(CurrentWeatherViewModel(weather: $0))
//                self.weekWeatherController.viewModel = WeekWeatherViewModel(weatherData: $0.daily.data)
//            }).disposed(by: bag)
    }
}



//extension SkyController: CLLocationManagerDelegate
//{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        if let location = locations.first
//        {
//            currentLocation = location
//            manager.delegate = nil
//
//            manager.stopUpdatingLocation()
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
//    {
//        if status == .authorizedWhenInUse
//        {
//            manager.requestLocation()
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
//    {
//        dump(error)
//    }
//}


extension SkyController: CurrentWeatherControllerDelegate
{
    func locationButtonPressed(controller: CurrentWeatherController)
    {
        performSegue(withIdentifier: segueLocation, sender: self)
    }
    func settingsButtonPressed(controller: CurrentWeatherController)
    {
        performSegue(withIdentifier: segueSettings, sender: self)
    }
}


extension SkyController: SettingsViewControllerDelegate
{
    func controllerDidChangeTimeMode(controller: SettingsController)
    {
        reloadUI()
    }
    func controllerDidChangeTemperatureMode(controller: SettingsController)
    {
        reloadUI()
    }
    
    func reloadUI()
    {
        currentWeatherController.updateView()
        weekWeatherController.updateView()
    }
}


extension SkyController: LocationControllerDelegate
{
    func controller(_ controller: LocationController, location: CLLocation)
    {
        currentLocation = location
    }
}


