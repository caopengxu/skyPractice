//
//  AddLocationViewModel.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/30.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import Foundation
import CoreLocation

class AddLocationViewModel
{
    private lazy var geocoder = CLGeocoder()
    
    var queryText: String = ""
    {
        didSet
        {
            geocode(address: queryText)
        }
    }
    private var isQuerying = false
    {
        didSet
        {
            queryingStatusDidChange?(isQuerying)
        }
    }
    private var locations: [Location] = []
    {
        didSet
        {
            locationsDidChange?(locations)
        }
    }
    
    var queryingStatusDidChange: ((Bool) -> Void)?
    var locationsDidChange: (([Location]) -> Void)?
    
    var numberOfLocations: Int
    {
        return locations.count
    }
    var hasLocationsResult: Bool
    {
        return numberOfLocations > 0
    }
    
    
    // 搜索位置、地理编码
    private func geocode(address: String?)
    {
        if let address = address
        {
            isQuerying = true
            
            geocoder.geocodeAddressString(address, completionHandler: {
                [weak self] (placemarks, error) in
                DispatchQueue.main.async {
                    self?.processResponse(placemarks: placemarks, error: error)
                }
            })
        }
        else
        {
            locations = []
        }
    }
    
    
    // 设置locations数据
    private func processResponse(placemarks: [CLPlacemark]?, error: Error?)
    {
        isQuerying = false
        
        if let error = error
        {
            print("Cannot handle Geocode Address! \(error)")
        }
        else if let results = placemarks
        {
            locations = results.compactMap {
                guard let name = $0.name else {return nil}
                guard let location = $0.location else {return nil}
                
                return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
    
    
    func locationViewModel(at index: Int) -> LocationRepresentable?
    {
        guard let location = location(at: index) else
        {
            return nil
        }
        return LocationViewModel(location: location.location, locationText: location.name)
    }
    
    func location(at index: Int) -> Location?
    {
        guard index < numberOfLocations else
        {
            return nil
        }
        return locations[index]
    }
}


