//
//  CustomTabBarController.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/8/2.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewController = ViewController()
        let navi = UINavigationController(rootViewController: viewController)
        navi.navigationBar.tintColor = UIColor.black
        navi.tabBarItem.title = "Maps"
        navi.tabBarItem.largeContentSizeImage = UIImage(named: "maps")
        navi.tabBarItem.image = UIImage(named: "maps")
        navi.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "wood2"), for: .default)

        let foodController = FoodViewController()
        let naviFood = UINavigationController(rootViewController: foodController)
        naviFood.topViewController?.addChild(DetailViewController())
        naviFood.tabBarItem.title = "Food"
        naviFood.tabBarItem.image = UIImage(named: "food")
        naviFood.navigationBar.tintColor = UIColor.black
        naviFood.navigationBar.barTintColor = UIColor(patternImage: #imageLiteral(resourceName: "wood3"))
        viewControllers = [navi, naviFood]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBar.invalidateIntrinsicContentSize()
        tabBar.superview?.setNeedsLayout()
        tabBar.superview?.layoutSubviews()
        
    }
}
