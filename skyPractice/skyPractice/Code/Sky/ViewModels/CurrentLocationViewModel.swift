//
//  CurrentLocationViewModel.swift
//  skyPractice
//
//  Created by caopengxu on 2018/3/31.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import Foundation

struct CurrentLocationViewModel {
    
    var location: Location
    var city: String
    {
        return location.name
    }
    var isEmpty: Bool
    {
        return self.location == Location.empty
    }
    
    static let empty = CurrentLocationViewModel(location: Location.empty)
}


