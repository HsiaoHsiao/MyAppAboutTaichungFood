//
//  ViewController.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/7/30.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    var myLocation: CLLocation?
    let request = MKDirections.Request()
    let locationManager = CLLocationManager()

    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let detailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.5
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.blue.cgColor
        view.alpha = 0
        return view
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        let attributed = NSMutableAttributedString(string: "Google評價", attributes : [NSAttributedString.Key.font : UIFont.init(name: "Mushin", size: 18)!, NSAttributedString.Key.foregroundColor : UIColor.blue])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributed, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(connectWeb), for: .touchUpInside)
        return button
    }()
    
    lazy var barLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)!, height: (self.navigationController?.navigationBar.frame.height)!))
        
        label.attributedText = NSMutableAttributedString(string: "Food  Map  in  Taichung", attributes: [NSAttributedString.Key.font:UIFont.init(name: "Merci Heart Brush", size: 20)!])
        label.textAlignment = .center
        
        return label
    }()
    
    @objc func connectWeb() {
        self.navigationController?.pushViewController(Service.sharedInstance.webView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.showsCompass = true
        
        mapView.addSubview(detailView)
        detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        detailView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        detailView.addSubview(detailLabel)
        detailLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 0).isActive = true
        detailLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 5).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: 0).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        detailView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 0).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 5).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: 0).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        detailView.addSubview(searchButton)
        searchButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 5).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -210).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gps"), style: .plain, target: self, action: #selector(trackMyLocation))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "lists"), style: .plain, target: self, action: #selector(GoToCategoryView))
        
        navigationController?.navigationBar.addSubview(barLabel)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.init(name: "Mushin", size: 18)!], for: .normal)
        
        navigationController?.navigationBar.isTranslucent = false
        
        // Get Data
        Service.sharedInstance.getData()
        
        mapView.delegate = self
        locationManager.delegate = self
        Service.sharedInstance.categoryViewController.delegate = self
        
        // requsest Authorization
        locationManager.requestWhenInUseAuthorization()
    }
    
    @objc func GoToCategoryView() {
        Service.sharedInstance.categoryViewController.hidesBottomBarWhenPushed = true
        barLabel.alpha = 0
        self.navigationController?.pushViewController(Service.sharedInstance.categoryViewController, animated: true)
    }
    
    @objc func trackMyLocation() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        barLabel.alpha = 1
    }
    
} //end ViewController

