//
//  SkyController.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/21.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupActiveNotification()
    }
    
    
    // CurrentWeatherController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case segueCurrentWeather:
            guard let destination = segue.destination as? CurrentWeatherController else
            {
                fatalError("Invalid destination view controller.")
            }
            
            destination.delegate = self
            currentWeatherController = destination
        default:
            break
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
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            locationManager.requestLocation()
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    // 地理编码获取城市信息
    func fetchCity()
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
                let l = Location(name: city, latitude: lat, longitude: lon)
                
                self.currentWeatherController.location = l
            }
        })
    }
    
    
    // 根据地理位置获取天气信息
    func fetchWeather()
    {
        guard let currentLocation = currentLocation else {return}
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon) { (weatherData, error) in
            
            if let error = error
            {
                dump(error)
            }
            else if let weatherData = weatherData
            {
                self.currentWeatherController.now = weatherData
            }
        }
    }
}



extension SkyController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            currentLocation = location
            manager.delegate = nil
            
            manager.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            manager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        dump(error)
    }
}


extension SkyController: CurrentWeatherControllerDelegate
{
    func locationButtonPressed(controller: CurrentWeatherController)
    {
        print("Open locations")
    }
    func settingsButtonPressed(controller: CurrentWeatherController)
    {
        print("Open settings")
    }
}


