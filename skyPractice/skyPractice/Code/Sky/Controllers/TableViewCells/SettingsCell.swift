//
//  SettingsCell.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/23.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    static let reuseIdentifier = "SettingsCell"
    
    @IBOutlet weak var label: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    func configure(with vm: SettingsRepresentable)
    {
        label.text = vm.labelText
        accessoryType = vm.accessory
    }
}
