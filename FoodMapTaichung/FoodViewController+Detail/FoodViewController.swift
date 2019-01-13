//
//  FoodCollectionViewController.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/8/3.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class FoodViewController: UIViewController, UISearchResultsUpdating {
    
    var shouldShowSearchResults = false
    var searchResult = [storeNameAndDistance]()
    
    let foodTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditing = false
        return view
    }()
    
    let selectedView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    lazy var barLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)!, height: (self.navigationController?.navigationBar.frame.height)!))
        
        label.attributedText = NSMutableAttributedString(string: "Lists   of   Foods",
                                                         attributes: [NSAttributedString.Key.font:UIFont.init(name: "Merci Heart Brush", size: 20)!])
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(foodTableView)
        foodTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        foodTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        foodTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        foodTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.view.addSubview(self.selectedView)
        self.selectedView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.selectedView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.selectedView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.selectedView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.searchController?.searchBar.placeholder = "輸入地點"
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchBar.barStyle = .default
        
        navigationController?.navigationBar.addSubview(barLabel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "lists"), style: .plain, target: self, action: #selector(GoToCategoryView))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.init(name: "Mushin", size: 18)!], for: .normal)
        
        view.backgroundColor = .white
        
        selectedView.delegate = self
        selectedView.dataSource = self
        foodTableView.delegate = self
        foodTableView.dataSource = self
        
        selectedView.register(FoodTableViewCell.self, forCellReuseIdentifier: "cellId")
        foodTableView.register(FoodTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        definesPresentationContext = true
    }
    
    // leftBarButton Action
    @objc func GoToCategoryView() {
        barLabel.alpha = 0
        self.navigationController?.pushViewController(Service.sharedInstance.categoryViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        barLabel.alpha = 1
        foodTableView.reloadData()
    }
    
}

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


