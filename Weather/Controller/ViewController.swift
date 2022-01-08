//
//  ViewController.swift
//  Weather
//
//  Created by nguyen huy on 1/6/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import UIKit
import CoreLocation

//8c90b4ac293e4f11683921441e152339

class ViewController: UIViewController {
    @IBOutlet weak var pageCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var searchLayout: UIStackView!
    @IBOutlet weak var labelAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCollectionView.register(UINib(nibName: "WeatherInfoCell", bundle: nil), forCellWithReuseIdentifier: "WeatherInfoCell")
        
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        searchLayout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSearchTapped)))
        
        let address = "thanh hoa"
        
                getCoordinateFrom(address: address) { coordinate, error in
                    guard let coordinate = coordinate, error == nil else { return }
                    // don't forget to update the UI from the main thread
                    DispatchQueue.main.async {
                        print(address, "Location:", coordinate) // Rio de Janeiro, Brazil Location: CLLocationCoordinate2D(latitude: -22.9108638, longitude: -43.2045436)
                    }
        
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) {
            completion($0?.first?.location?.coordinate, $1)
            //print($0?.first?. ?? "")
            if($0 == nil) {return}
            for place in $0! {
                print("\(place.name), \(place.country), \(place.locality)")
            }
        }
    }
    
    @objc func onSearchTapped(){
        print("aaa")
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherInfoCell", for: indexPath) as! WeatherInfoCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


