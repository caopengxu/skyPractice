//
//  WeatherController.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/21.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

class WeatherController: UIViewController {

    @IBOutlet weak var weatherContainerView: UIView!
    @IBOutlet weak var loadingFailedLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    
    // 初始化界面
    fileprivate func setupView()
    {
        weatherContainerView.isHidden = true
        loadingFailedLabel.isHidden = true
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }
}


