//
//  LocationController.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/28.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationControllerDelegate
{
    func controller(_ controller: LocationController, location: CLLocation)
}


class LocationController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: LocationControllerDelegate?
    var currentLocation: CLLocation?
    let segueAddLocation = "SegueAddLocation"
    fileprivate var favourites = UserDefaults.loadLocations()
    fileprivate var hasFavourites: Bool
    {
        return favourites.count > 0
    }
    
    @IBAction func unwindToLocationsViewController(segue: UIStoryboardSegue) {}
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: LocationCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: LocationCell.reuseIdentifier)
    }

    
    // prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let identifier = segue.identifier
        {
            switch identifier {
            case "":
                fatalError("没有设置identifier")
            case segueAddLocation:
                guard let destination = segue.destination as? AddLocationController else
                {
                    fatalError("segue error")
                }
                
                destination.delegate = self
            default:
                break
            }
        }
    }
}


extension LocationController: UITableViewDelegate, UITableViewDataSource
{
    fileprivate enum Section: Int {
        case current
        case favourite
        
        static var count: Int
        {
            return Section.favourite.rawValue + 1
        }
        
//        var numberOfRows: Int
//        {
//            switch self {
//            case .current:
//                return 1
//            case .favourite:
//                return max(favourites.count, 1)
//            }
//        }
//
//        var title: String
//        {
//            switch self {
//            case .current:
//                return "默认位置"
//            case .favourite:
//                return "收藏的位置"
//            }
//        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return Section.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let section = Section(rawValue: section) else
        {
            fatalError("section error")
        }
        
        switch section {
        case .current:
            return 1
        case .favourite:
            return max(favourites.count, 1)
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        guard let section = Section(rawValue: section) else
        {
            fatalError("section error")
        }
        
        switch section {
        case .current:
            return "当前位置"
        case .favourite:
            return "收藏的位置"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseIdentifier, for: indexPath) as? LocationCell else
        {
            fatalError("cell error")
        }
        
        guard let section = Section(rawValue: indexPath.section) else
        {
            fatalError("section error")
        }
        
        var vm: LocationRepresentable?
        
        switch section {
        case .current:
            if let currentLocation = currentLocation
            {
                vm = LocationViewModel(location: currentLocation, locationText: nil)
            }
            else
            {
                cell.label.text = "获取当前位置失败"
            }
        case .favourite:
            if favourites.count > 0
            {
                let fav = favourites[indexPath.row]
                vm = LocationViewModel(location: fav.location, locationText: fav.name)
            }
            else
            {
                cell.label.text = "还没有收藏位置"
            }
        }
        
        if let vm = vm
        {
            cell.configure(with: vm)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let section = Section(rawValue: indexPath.section) else
        {
            fatalError("section error")
        }
        
        var location: CLLocation?
        
        switch section {
        case .current:
            if let currentLocation = currentLocation
            {
                location = currentLocation
            }
        case .favourite:
            if hasFavourites
            {
                location = favourites[indexPath.row].location
            }
        }
        
        if let location = location
        {
            delegate?.controller(self, location: location)
            dismiss(animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        guard let section = Section(rawValue: indexPath.section) else
        {
            fatalError("section error")
        }
        
        switch section {
        case .current:
            return false
        case .favourite:
            return hasFavourites
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let location = favourites[indexPath.row]
        UserDefaults.removeLocation(location)
        
        favourites.remove(at: indexPath.row)
        tableView.reloadData()
    }
}


extension LocationController: AddLocationControllerDelegate
{
    func controller(_ controller: AddLocationController, location: Location)
    {
        UserDefaults.addLocation(location)
        favourites.append(location)
        tableView.reloadData()
    }
}

