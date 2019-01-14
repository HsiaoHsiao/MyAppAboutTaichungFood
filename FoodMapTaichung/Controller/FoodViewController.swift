//
//  FoodCollectionViewController.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/8/3.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import UIKit
import CoreLocation

class FoodViewController: UIViewController, UISearchResultsUpdating {
    
    var shouldShowSearchResults = false
    var searchResult = [StoreNameAndDistance]()
    
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



