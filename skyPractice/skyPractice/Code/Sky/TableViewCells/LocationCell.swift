
//
//  LocationCell.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/28.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    static let reuseIdentifier = "LocationCell"

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    
    func configure(with vm: LocationRepresentable)
    {
        label.text = vm.labelText
    }
}


