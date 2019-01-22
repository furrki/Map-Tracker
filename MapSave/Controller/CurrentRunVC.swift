//
//  CurrentRunVC.swift
//  MapSave
//
//  Created by Admin on 23.12.2018.
//  Copyright © 2018 furrki. All rights reserved.
//

import UIKit
import MapKit

class CurrentRunVC: LocationVC {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var runDistance = 0.0
    var counter = 0
    var pace = 0.0
    var poses: [[Double]] = []
    var timer = Timer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    func startRun(){
        manager?.startUpdatingLocation()
        startTimer()
    }
    func endRun(){
        manager?.stopUpdatingLocation()
    }
    func startTimer(){
        durationLabel.text = "\(counter.formatTimeDurationToString())"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    func calculatePace(time seconds:Int, meters: Double) -> String{
        pace = (meters / Double(seconds)).round(to: 2)
        return "\(pace)"
    }
    @objc func updateCounter(){
        counter += 1
        durationLabel.text = "\(counter.formatTimeDurationToString())"
        
    }
    
    @IBAction func StopBtnClicked(_ sender: Any) {
        manager?.stopUpdatingLocation()
        RunObject.insert(dist: runDistance, duration: counter, poses: poses)
        print(RunObject.getRuns()!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func PauseBtnClicked(_ sender: Any) {
        if timer.isValid {
            pauseRun()
        } else {
            startRun()
            pauseBtn.setTitle("Pause", for: .normal)
        }
    }
    
    func pauseRun(){
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseBtn.setTitle("Resume", for: .normal)
    }
}

extension CurrentRunVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            checkLocationAuthStatus()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
            
            poses.append([locations.first!.coordinate.latitude, locations.first!.coordinate.longitude])
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location).round(to: 2)
            distanceLabel.text = "\(runDistance)"
            if counter > 0 && runDistance > 0 {
                paceLabel.text = calculatePace(time: counter, meters: runDistance)
                poses.append([location.coordinate.latitude, location.coordinate.longitude])
            }
        }
        lastLocation = locations.last
    }
}
