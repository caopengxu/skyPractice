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
    var viewModel = AddLocationViewModel()
    
    
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
        
        
        viewModel.queryingStatusDidChange = {
            [unowned self] isQuerying in
            if isQuerying
            {
                self.title = "搜索中..."
            }
            else
            {
                self.title = "添加"
            }
        }
        viewModel.locationsDidChange = {
            [unowned self] locations in
            self.tableView.reloadData()
        }
    }
}


// MARK: === tableView相关
extension AddLocationController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.numberOfLocations;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseIdentifier, for: indexPath) as? LocationCell else
        {
            fatalError("cell error")
        }
        
        if let viewModel = viewModel.locationViewModel(at: indexPath.row)
        {
            cell.configure(with: viewModel)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let location = viewModel.location(at: indexPath.row)
        {
            delegate?.controller(self, location: location)
            navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: === searchBar相关
extension AddLocationController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        viewModel.queryText = searchBar.text ?? ""
    }
}


