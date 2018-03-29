//
//  AddLocationController.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/28.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddLocationControllerDelegate
{
    func controller(_ controller: AddLocationController, location: Location)
}


class AddLocationController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate: AddLocationControllerDelegate?
    private var locations: [Location] = []
    private lazy var geocoder = CLGeocoder()
    
    
    // 界面显示前后
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: LocationCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: LocationCell.reuseIdentifier)
    }

    
    // 搜索位置、地理编码
    private func geocode(address: String?)
    {
        if let address = address
        {
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
            tableView.reloadData()
        }
    }
    
    
    // 设置数据、刷新界面
    private func processResponse(placemarks: [CLPlacemark]?, error: Error?)
    {
        if let error = error
        {
            print("Cannot handle Geocode Address! \(error)")
        }
        else if let results = placemarks
        {
            locations = results.flatMap {
                result -> Location? in
                
                guard let name = result.name else {return nil}
                guard let location = result.location else {return nil}
                
                return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
            
            tableView.reloadData()
        }
    }
}

extension AddLocationController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locations.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseIdentifier, for: indexPath) as? LocationCell else
        {
            fatalError("cell error")
        }
        
        let location = locations[indexPath.row]
        let vm = LocationViewModel(location: location.location, locationText: location.name)
        cell.configure(with: vm)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let location = locations[indexPath.row]
        delegate?.controller(self, location: location)
        
        navigationController?.popViewController(animated: true)
    }
}


extension AddLocationController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        geocode(address: searchBar.text)
    }
}


