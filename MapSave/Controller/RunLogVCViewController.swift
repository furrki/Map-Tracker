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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runlogTable.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runlogTable.delegate = self
        runlogTable.dataSource = self
        
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
            cell.metersLabel.text = "\(runs[indexPath.row].dist) m"
            cell.avgPaceLabel.text = "\((runs[indexPath.row].dist/Double(runs[indexPath.row].duration)).round(to: 3))"
            cell.timeLabel.text = "\(runs[indexPath.row].duration.formatTimeDurationToString())"
        }
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

