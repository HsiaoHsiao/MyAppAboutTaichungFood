//
//  ArtWork.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/7/30.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import MapKit
import Contacts

class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let phone: String
    let coordinate: CLLocationCoordinate2D
    let category: String
    var imageName = ""
    
    init(_ title:String, _ locationName: String, _ phone: String, _ coordinate: CLLocationCoordinate2D, _ imageName: String, _ category: String) {
        self.title = title
        self.locationName = locationName
        self.phone = phone
        self.coordinate = coordinate
        self.imageName = imageName
        self.category = category
        
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: locationName]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

struct StoreNameAndDistance {
    
    let title: String?
    let distance: String
    
    
    init(_ title:String?, _ distance:String) {
        self.title = title
        self.distance = distance 
    }
}
