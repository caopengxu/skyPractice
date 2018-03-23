//
//  SettingsController.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/23.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func controllerDidChangeTimeMode(controller: SettingsController)
    func controllerDidChangeTemperatureMode(controller: SettingsController)
}


class SettingsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    
    
    

}




extension SettingsController: UITableViewDataSource, UITableViewDelegate
{
    fileprivate enum Section: Int
    {
        case date
        case temperature
        
        static var count: Int
        {
            return Section.temperature.rawValue + 1
        }
        
        var numberOfRows: Int
        {
            return 2
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return Section.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let section = Section(rawValue: section) else
        {
            fatalError("Unexpected section index")
        }
        
        return section.numberOfRows
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0
        {
            return "Date format"
        }
        else
        {
            return "Temperature unit"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as? SettingsCell else
        {
            fatalError("Unexpected talbe view cell")
        }
        
        guard let section = Section(rawValue: indexPath.section) else
        {
            fatalError("Unexpected section index")
        }
        
        var vm: SettingsRepresentable?
        
        switch section {
        case .date:
            guard let dateModel = DateModel(rawValue: indexPath.row) else
            {
                fatalError("Invalide IndexPath")
            }
            
            vm = SettingsDateViewModel(dateMode: dateModel)
        case .temperature:
            guard let temperatureModel = TemperatureModel(rawValue: indexPath.row) else
            {
                fatalError("Invalide IndexPath")
            }
            
            vm = SettingsTemperatureViewModel(temperatureMode: temperatureModel)
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
            fatalError("Unexpected section index")
        }
        
        switch section {
        case .date:
            let dateModel = UserDefaults.dateModel()
            
            guard indexPath.row != dateModel.rawValue else {return}
            
            if let newModel = DateModel(rawValue: indexPath.row)
            {
                UserDefaults.setDateMode(to: newModel)
            }
            
            delegate?.controllerDidChangeTimeMode(controller: self)
        case .temperature:
            let temperatureModel = UserDefaults.temperatureModel()
            
            guard indexPath.row != temperatureModel.rawValue else {return}
            
            if let newModel = TemperatureModel(rawValue: indexPath.row)
            {
                UserDefaults.setTemperatureModel(to: newModel)
            }
            
            delegate?.controllerDidChangeTemperatureMode(controller: self)
        }
        
        let sections = IndexSet(integer: indexPath.section)
        tableView.reloadSections(sections, with: .none)
    }
}


