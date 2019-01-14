//
//  CategoryTableController.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/8/17.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol setAnnotationDelegate: class {
    func addAnnotation(_ food: Food)
    func removeAnnotation(_ food: Food)
    func setFoodInformation() -> [StoreNameAndDistance]
}

class CategoryTableController: UITableViewController {
    
    weak var delegate: setAnnotationDelegate?
    let category = ["火鍋", "燒肉", "壽司", "拉麵", "早午餐", "café", "甜點店", "居酒屋", "日式料理", "港式飲茶", "法式餐廳", "泰式料理", "牛排.西餐廳", "漢堡.美式餐廳", "披薩.義式餐廳"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CategoryTableCellTableViewCell.self, forCellReuseIdentifier: "CellId")
        self.tableView.isEditing = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = category[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CategoryTableCellTableViewCell
        let foodArray = [Service.sharedInstance.foodCategory?.hotpots, Service.sharedInstance.foodCategory?.bBQs, Service.sharedInstance.foodCategory?.sushi, Service.sharedInstance.foodCategory?.ramen, Service.sharedInstance.foodCategory?.brunch, Service.sharedInstance.foodCategory?.coffee, Service.sharedInstance.foodCategory?.dessert, Service.sharedInstance.foodCategory?.lzakaya, Service.sharedInstance.foodCategory?.japaneseFood, Service.sharedInstance.foodCategory?.hongkongFood, Service.sharedInstance.foodCategory?.frenchFood, Service.sharedInstance.foodCategory?.thaiFood, Service.sharedInstance.foodCategory?.steak, Service.sharedInstance.foodCategory?.americanFood, Service.sharedInstance.foodCategory?.pizza]
        
        cell.showBool = !cell.showBool
    
        for (_, food) in (foodArray[indexPath.row]?.enumerated())! {
                    cell.showBool ? delegate?.addAnnotation(food) : delegate?.removeAnnotation(food)
                }
                cell.accessoryView?.tintColor = cell.showBool ? .red : .gray
        
        Service.sharedInstance.foodAndDistance = (delegate?.setFoodInformation())!
    }
}
