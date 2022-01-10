//
//  ViewController.swift
//  Weather
//
//  Created by nguyen huy on 1/6/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

//8c90b4ac293e4f11683921441e152339

class ViewController: UIViewController {
    @IBOutlet weak var pageCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var searchLayout: UIStackView!
    @IBOutlet weak var labelAddress: UILabel!
    
    var currentPage = 0
    var locationDataSource = LocationDataSource.shared
    var locations: Results<LocationModel> {
        get {
            return locationDataSource.locations
        }
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        pageCollectionView.register(UINib(nibName: "WeatherInfoCell", bundle: nil), forCellWithReuseIdentifier: "WeatherInfoCell")
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        
        searchLayout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSearchTapped)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        loadLocations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func onSearchTapped(){
        self.performSegue(withIdentifier: K.ToSearchAddressView, sender: self)
    }
    
    func loadLocations() {
        locationDataSource.loadLocations()
        pageCollectionView.reloadData()
    }
    
    func setLocationLabel(){
        if (locations != nil && self.currentPage < locations.count) {
            labelAddress.text = locations[currentPage].fullLocation
        }
    }
}

//MARK: Location
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.locationDataSource.updateUserLocation(location) {
                self.loadLocations()
                self.setLocationLabel()
            }
        }
        locationManager.stopUpdatingLocation()
    }
}
//MARK: Pager
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherInfoCell", for: indexPath) as! WeatherInfoCell
        cell.loadWeatherData(location: locations[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //For detecting current displayed page
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        self.currentPage = Int(ceil(x/w))
        setLocationLabel()
    }
}


