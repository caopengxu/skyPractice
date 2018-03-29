//
//  WeekWeatherController.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/22.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

class WeekWeatherController: WeatherController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: WeekWeatherViewModel?
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
    
    
    // 刷新界面
    func updateView()
    {
        activityIndicatorView.stopAnimating()
        
        if let _ = viewModel
        {
            weatherContainerView.isHidden = false
            tableView.reloadData()
        }
        else
        {
            loadingFailedLabel.isHidden = false
        }
    }
}


// MARK: === tableView相关
extension WeekWeatherController: UITableViewDelegate, UITableViewDataSource
{
    // 设置tableView
    func setupTableView()
    {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000.0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfDays
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekCell.reuseIdentifier, for: indexPath) as? WeekCell else
        {
            fatalError("cell error")
        }
        
        if let weatherDay = viewModel?.viewModel(for: indexPath.row)
        {
            cell.configure(with: weatherDay)
        }
        
        return cell
    }
}


