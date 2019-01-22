//
//  LocationVC.swift
//  MapSave
//
//  Created by Admin on 23.12.2018.
//  Copyright © 2018 furrki. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController, MKMapViewDelegate {
    
    var manager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
        // Do any additional setup after loading the view.
    }
    
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            manager?.requestAlwaysAuthorization()
        }
    } 
}

