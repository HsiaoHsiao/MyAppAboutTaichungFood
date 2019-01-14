//
//  DetailViewController + Extension.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2019/1/14.
//  Copyright © 2019年 蕭偉志. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension DetailViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations.first!
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude)
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
    }
}

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        render.lineWidth = 2.0
        return render
    }
}



extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DetailViewCell
        
        if indexPath.row == 0 {
            let attriburted = NSMutableAttributedString(string: (Service.sharedInstance.food?.name)!, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Mushin", size: 15)!])
            cell.textLabel?.attributedText = attriburted
        }
        
        if indexPath.row == 1 {
            let attriburted = NSMutableAttributedString(string: (Service.sharedInstance.food?.address)!, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Mushin", size: 15)!])
            cell.textLabel?.attributedText = attriburted
            
        }
        
        if indexPath.row == 2 {
            cell.addSubview(timeLabel)
        }
        
        if indexPath.row == 3 {
            let button = UIButton(frame: CGRect(x: 20, y: 0, width: 75, height: 50))
            button.setTitle("Google評價", for: .normal)
            button.titleLabel?.font = UIFont(name: "Mushin", size: 15)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(connectUrl), for: .touchUpInside)
            button.titleLabel?.textAlignment = .left
            cell.addSubview(button)
        }
        return cell
        
    }
}

