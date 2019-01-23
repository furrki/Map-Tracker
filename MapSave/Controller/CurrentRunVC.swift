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
    
    @IBOutlet weak var containerView: UIView!
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        containerView.layer.cornerRadius = 5
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
        durationLabel.text = "\(CurrentRun.counter.formatTimeDurationToString())"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    func calculatePace(time seconds:Int, meters: Double) -> String{
        CurrentRun.pace = (meters / Double(seconds)).round(to: 2)
        return "\(CurrentRun.pace)"
    }
    @objc func updateCounter(){
        CurrentRun.counter += 1
        durationLabel.text = "\(CurrentRun.counter.formatTimeDurationToString())"
        
    }
    
    @IBAction func StopBtnClicked(_ sender: Any) {
        manager?.stopUpdatingLocation()
        RunObject.insert(dist: CurrentRun.runDistance, duration: CurrentRun.counter, poses: CurrentRun.poses)
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
            CurrentRun.poses.append([locations.first!.coordinate.latitude, locations.first!.coordinate.longitude])
        } else if let location = locations.last {
            
            CurrentRun.runDistance += lastLocation.distance(from: location).round(to: 2)
            distanceLabel.text = "\(CurrentRun.runDistance)"
            if CurrentRun.counter > 0 && CurrentRun.runDistance > 0 {
                paceLabel.text = calculatePace(time: CurrentRun.counter, meters: CurrentRun.runDistance)
                CurrentRun.poses.append([location.coordinate.latitude, location.coordinate.longitude])
            }
        }
        lastLocation = locations.last
    }
}
