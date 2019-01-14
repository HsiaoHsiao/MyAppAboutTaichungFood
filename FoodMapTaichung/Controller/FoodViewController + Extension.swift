//
//  FoodViewController + Extension.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2019/1/14.
//  Copyright © 2019年 蕭偉志. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == foodTableView {
            return (Service.sharedInstance.foodAndDistance.count)
        }
        else {
            return self.searchResult.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! FoodTableViewCell
        
        if tableView == foodTableView {
            cell.textLabel?.text = Service.sharedInstance.foodAndDistance[indexPath.row].title
            cell.rightView.text = Service.sharedInstance.foodAndDistance[indexPath.row].distance + "km"
            return cell
        }
        else {
            searchResult.sort(by: {$0.distance < $1.distance})
            cell.textLabel?.text = searchResult[indexPath.row].title
            cell.rightView.text = searchResult[indexPath.row].distance + "km"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailView = DetailViewController()
        let foodArray = [Service.sharedInstance.foodCategory?.hotpots, Service.sharedInstance.foodCategory?.bBQs, Service.sharedInstance.foodCategory?.sushi, Service.sharedInstance.foodCategory?.ramen, Service.sharedInstance.foodCategory?.brunch, Service.sharedInstance.foodCategory?.coffee, Service.sharedInstance.foodCategory?.dessert, Service.sharedInstance.foodCategory?.lzakaya, Service.sharedInstance.foodCategory?.japaneseFood, Service.sharedInstance.foodCategory?.hongkongFood, Service.sharedInstance.foodCategory?.frenchFood, Service.sharedInstance.foodCategory?.thaiFood, Service.sharedInstance.foodCategory?.steak, Service.sharedInstance.foodCategory?.americanFood, Service.sharedInstance.foodCategory?.pizza]
        
        for (_ , foodcategory) in foodArray.enumerated() {
            for (_ , food) in (foodcategory?.enumerated())! {
                if food.name == (tableView.cellForRow(at: indexPath)?.textLabel?.text)! {
                    Service.sharedInstance.food = food
                }
            }
        }
        barLabel.alpha = 0
        detailView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

extension FoodViewController: UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        if searchString != "" {
            foodTableView.alpha = 0
            selectedView.alpha = 1
            
            searchResult = Service.sharedInstance.foodAndDistance.filter({
                ($0.title?.lowercased().contains(searchString.lowercased()))!
            })
            
            self.selectedView.reloadData()
        }
        else {
            foodTableView.alpha = 1
            self.selectedView.alpha = 0
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        foodTableView.alpha = 1
        self.selectedView.alpha = 0
        self.shouldShowSearchResults = false
    }
    
}
