//
//  HotPot.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/8/13.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import Foundation
import MapKit


struct Category: Decodable {
    var hotpots:[Food]
    var bBQs:[Food]
    var sushi:[Food]
    var ramen:[Food]
    var brunch:[Food]
    var coffee:[Food]
    var dessert:[Food]
    var lzakaya:[Food]
    var japaneseFood:[Food]
    var hongkongFood:[Food]
    var frenchFood:[Food]
    var thaiFood:[Food]
    var steak:[Food]
    var americanFood:[Food]
    var pizza:[Food]
}

struct Food: Decodable {
    let name:String
    let address:String
    let phone:String
    let latitude:String
    let longitude:String
    let time:String
    let category:String
}


