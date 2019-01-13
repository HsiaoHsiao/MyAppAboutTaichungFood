//
//  Service.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2019/1/10.
//  Copyright © 2019年 蕭偉志. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class Service {
    static let sharedInstance = Service()
    
    let webView = WebViewController()
    let categoryViewController = CategoryTableController()
    let foodViewController = FoodViewController()
    
    var foodCategory: Category?
    var foodAndDistance = [storeNameAndDistance]()
    var food: Food?
    
    func getData() {
        let urlString = "https://hsiaohsiao.github.io/TaichungFoodMap/taichungfood.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, respon, err) in
            guard let data = data else { return }
            do {
                self.foodCategory = try JSONDecoder().decode(Category.self, from: data)
            }
            catch let jsonErr {
                print("NO",jsonErr)
            }
            }.resume()
    }
    
    func calculateRoute(myLocation: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, map: MKMapView, timeLabel: UILabel, request: MKDirections.Request) {
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: myLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        let distance = MKDirections(request: request)
        
        if map.overlays.count > 0 {
            map.removeOverlay(map.overlays[0])
        }
        
        distance.calculate { (respon, error) in
            guard let respon = respon else { return }
            
            let route = respon.routes[0]
            let distance = String(format: "%.2f", Float(route.distance / 1000))
            let time = String(format: "%.1f", Float(route.expectedTravelTime/60))
            
            UIView.animate(withDuration: 0) {
                map.addOverlay(route.polyline)
            }
        
            if request.transportType == .walking {
                let attributed =
                    NSMutableAttributedString(string: "步行：\(distance)公里（大約\(time)分鐘）",
                        attributes : [NSAttributedString.Key.font: UIFont.init(name: "Mushin", size: 15)!])
                timeLabel.attributedText = attributed
            }
            else {
                let attributed =
                    NSMutableAttributedString(string: "開車：\(distance)公里（大約\(time)分鐘）",
                        attributes: [NSAttributedString.Key.font:UIFont.init(name: "Mushin", size: 15)!])
                timeLabel.attributedText = attributed
            }
            return
        }
    }
    
}
