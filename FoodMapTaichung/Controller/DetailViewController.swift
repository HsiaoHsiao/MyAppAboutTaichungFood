//
//  DetailViewController.swift
//  FoodMapTaichung
//
//  Created by 蕭偉志 on 2018/8/4.
//  Copyright © 2018年 蕭偉志. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {
    
    let request = MKDirections.Request()
    let locationManager = CLLocationManager()
    var myLocation = CLLocation()
    var label: UILabel?
    var location: CLLocationCoordinate2D?
    
    let timeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 50))
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let detailView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditing = false
        view.allowsSelection = false
        return view
    }()
    
    lazy var walkingButton: UIButton = {
        var button = UIButton(frame: CGRect(x: self.view.frame.width * 0.02, y: self.view.frame.height * 0.55, width: 25, height: 25))
        button.setImage(#imageLiteral(resourceName: "walking"), for: .normal)
        button.addTarget(self, action: #selector(walkingRequest), for: .touchUpInside)
        return button
    }()
    
    @objc func walkingRequest() {
        request.transportType = .walking
        
        Service.sharedInstance.calculateRoute(myLocation: myLocation.coordinate, destination: location!, map: mapView, timeLabel: timeLabel, request: request)
    }
    
    lazy var drivingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: self.view.frame.width * 0.09, y: self.view.frame.height * 0.55, width: 20, height: 25))
        button.setImage(#imageLiteral(resourceName: "drive"), for: .normal)
        button.addTarget(self, action: #selector(drivingRequest), for: .touchUpInside)
        return button
    }()
    
    @objc func drivingRequest() {
        request.transportType = .automobile
        let location = CLLocationCoordinate2D(latitude: Double((Service.sharedInstance.food?.latitude)!)!, longitude: Double((Service.sharedInstance.food?.longitude)!)!)
        
        Service.sharedInstance.calculateRoute(myLocation: myLocation.coordinate, destination: location, map: mapView, timeLabel: timeLabel, request: request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.70).isActive = true
        
        self.view.addSubview(detailView)
        detailView.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        mapView.addSubview(walkingButton)
        mapView.addSubview(drivingButton)
        
        view.backgroundColor = .white
        detailView.register(DetailViewCell.self, forCellReuseIdentifier: "cellId")
        
        detailView.dataSource = self
        detailView.delegate = self
        locationManager.delegate = self
        mapView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "打開導航", style: .plain, target: self, action: #selector(openGPS))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.init(name: "Mushin", size: 18)!, NSAttributedString.Key.foregroundColor : UIColor.blue], for: .normal)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.init(name: "Mushin", size: 18)!], for: .normal)
        
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // load web before use
        Service.sharedInstance.webView.webPageLoad(url: "https://www.google.com/search?source=hp&ei=3TN0W7TQLIyi8QXNgbCACw&q=\((Service.sharedInstance.food?.name)!)")
        
        // add annotation user want to go
        location = CLLocationCoordinate2D(latitude: Double((Service.sharedInstance.food?.latitude)!)!, longitude: Double((Service.sharedInstance.food?.longitude)!)!)
        
        let foodAnnotation = (CustomAnnotation((Service.sharedInstance.food?.name)!, (Service.sharedInstance.food?.address)!, (Service.sharedInstance.food?.phone)!, location!, (Service.sharedInstance.food?.category)!, (Service.sharedInstance.food?.category)!))
        
        self.mapView.addAnnotation(foodAnnotation)
    }
    
    @objc func openGPS() {
        
        var location: MKMapItem? = MKMapItem(placemark: MKPlacemark(coordinate: self.location! ))
        location!.name = mapView.annotations[0].title!
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location!.openInMaps(launchOptions: launchOptions)
        
        location = nil
    }
    
    @objc func connectUrl() {
        self.navigationController?.pushViewController(Service.sharedInstance.webView, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        request.transportType = .automobile
        Service.sharedInstance.calculateRoute(myLocation: myLocation.coordinate, destination: location!, map: mapView, timeLabel: timeLabel, request: request)
    }
    
} // end ViewController

