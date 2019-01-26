//
//  DetailsVC.swift
//  MapSave
//
//  Created by Admin on 26.01.2019.
//  Copyright © 2019 furrki. All rights reserved.
//

import UIKit
import MapKit
class DetailsVC: UIViewController, MKMapViewDelegate {

    var runDistance = 0.0
    var counter = 0
    var pace = 0.0
    var poses: [[Double]] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        createPolyline(mapView: mapView)
    }
    
    func createPolyline(mapView: MKMapView) {
        
        var points: [CLLocationCoordinate2D] = []
        for pos in poses {
            points.append(CLLocationCoordinate2D(latitude: pos[0], longitude: pos[1]))
            print(pos)
        }
        
        let geodesic = MKPolyline(coordinates: points, count: points.count)
        mapView.addOverlay(geodesic)
        
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region1 = MKCoordinateRegion(center: points[0], span: span)
            self.mapView.setRegion(region1, animated: true)
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
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
