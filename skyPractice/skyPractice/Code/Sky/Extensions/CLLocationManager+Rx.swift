//
//  CLLocationManager+Rx.swift
//  skyPractice
//
//  Created by caopengxu on 2018/4/8.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

extension CLLocationManager: HasDelegate
{
    public typealias Delegate = CLLocationManagerDelegate
}


class CLLocationManagerDelegateProxy:
    DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
    DelegateProxyType,
    CLLocationManagerDelegate
{
    weak private(set) var locationManager: CLLocationManager?
    
    init(locationManager: ParentObject)
    {
        self.locationManager = locationManager
        super.init(parentObject: locationManager, delegateProxy: CLLocationManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations()
    {
        self.register {CLLocationManagerDelegateProxy(locationManager: $0)}
    }
}


extension Reactive where Base: CLLocationManager
{
    var delegate: CLLocationManagerDelegateProxy
    {
        return CLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocations: Observable<[CLLocation]>
    {
        let sel = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
        
        return delegate.methodInvoked(sel).map { parameters in
            parameters[1] as! [CLLocation]
        }
    }
}


