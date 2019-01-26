//
//  RunLogVCViewController.swift
//  MapSave
//
//  Created by Admin on 20.12.2018.
//  Copyright © 2018 furrki. All rights reserved.
//

import UIKit
import RealmSwift
class RunLogVCViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource{
    
    var runs: Results<RunObject>? {
        return  RunObject.getRuns()
        
    }
    @IBOutlet weak var runlogTable: UITableView!
    @IBOutlet weak var bg: UIImageView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runlogTable.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runlogTable.delegate = self
        runlogTable.dataSource = self
        view.sendSubviewToBack(bg)
        runlogTable.allowsSelection = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let runs = RunObject.getRuns() {
            return runs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.runlogTable.dequeueReusableCell(withIdentifier: "RunLogCell") as! LogCell
        if let runs = runs {
            cell.dateLabel.text = "\(runs[indexPath.row].date)"
            cell.metersLabel.text = "\(runs[indexPath.row].dist.round(to: 2)) m"
            cell.avgPaceLabel.text = "\((runs[indexPath.row].dist/Double(runs[indexPath.row].duration)).round(to: 3))"
            cell.timeLabel.text = "\(runs[indexPath.row].duration.formatTimeDurationToString())"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsSegue", sender: indexPath.row)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailsVC {
            let run = runs![sender as! Int]
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.pace = (run.dist/Double(run.duration)).round(to: 3)
            destinationVC.runDistance = run.dist
            destinationVC.counter = run.duration
            for i in 0..<run.lats.count {
                destinationVC.poses.append([run.lats[i], run.lons[i]])
            }
        }
    }
    
}

