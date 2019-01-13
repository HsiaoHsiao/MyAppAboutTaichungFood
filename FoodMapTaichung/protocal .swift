//
//  protocal .swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2019/1/10.
//  Copyright © 2019年 蕭偉志. All rights reserved.
//

import Foundation
import MapKit

protocol setAnnotationDelegate {
    func addAnnotation(_ food: Food)
    func removeAnnotation(_ food: Food)
    func setFoodInformation() -> [storeNameAndDistance]
}



