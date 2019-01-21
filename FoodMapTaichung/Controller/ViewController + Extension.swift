//
//  ViewController + MapViewDelegate.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/8/1.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotation = view.annotation as! CustomAnnotation
        
        Service.sharedInstance.calculateRoute(myLocation: mapView.userLocation.coordinate, destination: annotation.coordinate, map: self.mapView, timeLabel: timeLabel, request: request)
        
        // Set detailLabel Text
        let attributedText = NSMutableAttributedString(string: annotation.title!, attributes: [NSAttributedString.Key.font:UIFont.init(name: "Mushin", size: 18)!])
        
        attributedText.append(NSMutableAttributedString(string: annotation.phone, attributes: [NSAttributedString.Key.font:UIFont.init(name: "Mushin", size: 13)!]))
        
        detailLabel.attributedText = attributedText
        
        // load webVeiw Information
        DispatchQueue.global().async {
            Service.sharedInstance.webView.webPageLoad(url: "https://www.google.com/search?source=hp&ei=3TN0W7TQLIyi8QXNgbCACw&q=\(annotation.title!)")
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: { self.detailView.alpha = 0.8
        }, completion: nil)
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard mapView.overlays.count > 0 else { return }
        
        UIView.animate(withDuration: 0.5) {
            self.detailView.alpha = 0
            mapView.removeOverlay(mapView.overlays[0])
        }
    }
    
    // Set Annotations View
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "maker")
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "maker")
        annotationView?.image = UIImage(named: annotation.category)
        annotationView?.canShowCallout = true
        annotationView?.calloutOffset = CGPoint(x: 0, y: 5)
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return annotationView
    }
    
    // Set AnnotationView Activite
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let location = view.annotation as! CustomAnnotation
        let alerk = UIAlertController(title: "選擇導航方式", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "步行距離", style: .default) { (_) in
            self.request.transportType = .walking
            Service.sharedInstance.calculateRoute(myLocation: (self.myLocation?.coordinate)!, destination: location.coordinate, map: mapView, timeLabel: self.timeLabel, request: self.request)
        }
        
        let action2 = UIAlertAction(title: "行車距離", style: .default) { (_) in
            self.request.transportType = .automobile
            Service.sharedInstance.calculateRoute(myLocation: (self.myLocation?.coordinate)!, destination: location.coordinate, map: mapView, timeLabel: self.timeLabel, request: self.request)
        }
        
        let action3 = UIAlertAction(title: "打開導航", style: .default) { (_) in
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
        
        alerk.addAction(action1)
        alerk.addAction(action2)
        alerk.addAction(action3)
        self.present(alerk, animated: true, completion: nil)
    }
    
    // set Render
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2.0
        return renderer
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            print("NO accept")
        }
        else {
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            mapView.showsUserLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations.first!
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake((myLocation?.coordinate.latitude)!,  myLocation!.coordinate.longitude)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        
    }
    
}

extension ViewController: setAnnotationDelegate {
    
    func addAnnotation(_ food: Food) {
        let latitude = Double(food.latitude)
        let longitude = Double(food.longitude)
        let coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        let foodArtwork = CustomAnnotation(food.name, food.address, food.phone, coordinate, food.category, food.category)
        
        mapView.addAnnotation(foodArtwork)
        mapView.layoutIfNeeded()
    }
    
    func removeAnnotation(_ food: Food) {
        for annotation in mapView.annotations {
            if annotation.title == food.name {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    func setFoodInformation() -> [StoreNameAndDistance] {
        var stores = [StoreNameAndDistance]()
        
        for (index, _) in self.mapView.annotations.enumerated() {
            let location = CLLocation(latitude: mapView.annotations[index].coordinate.latitude,
                                      longitude: mapView.annotations[index].coordinate.longitude)
            
            let mylocation = CLLocation(latitude: self.myLocation!.coordinate.latitude, longitude: self.myLocation!.coordinate.longitude)
            let distance = mylocation.distance(from: location)
            let distanceStr = String(format: "%.2f", Double(distance / 1000))
            stores.append(StoreNameAndDistance(mapView.annotations[index].title!, distanceStr))
        }
        stores.sort(by: { $0.distance < $1.distance})
        
        if stores.count > 0 {
            stores.remove(at: 0)
        }
        return stores
    }
    
}




