//
//  HourlyWeatherCell.swift
//  Weather
//
//  Created by nguyen huy on 1/7/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import UIKit

class HourlyWeatherCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var data = [HourlyWeather]()
    let itemSpace: Double = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: K.HourlyItemCell, bundle: nil), forCellWithReuseIdentifier: K.HourlyItemCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.HourlyItemCell, for: indexPath) as! HourlyItemCell
        if(data.count > indexPath.row){
            cell.setData(data: data[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numOfItem: Double = 5
        let screenWidth = Double(UIScreen.main.bounds.width)
        let width = (screenWidth - (10.0 * 2) - self.itemSpace * (numOfItem - 1)) / numOfItem
        return CGSize(width: width, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(itemSpace)
    }
    
    func setData(data: [HourlyWeather]) {
        self.data = data
        collectionView.reloadData()
    }
}
