//
//  SearchLocationController.swift
//  Weather
//
//  Created by nguyen huy on 1/10/22.
//  Copyright © 2022 nguyen huy. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import SwipeCellKit

class SearchLocationController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    
    var locations: Results<LocationModel>?
    var locationDataSource = LocationDataSource.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField ,
            let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton {
            clearButton.addTarget(self, action: #selector(self.clearButtonClicked), for: .touchUpInside)
        }
        locationTableView.rowHeight = 80
        locationTableView.dataSource = self
        locationTableView.delegate = self
        loadLocations()
    }
    
    func loadLocations(){
        locations = locationDataSource.loadLocations()
        locationTableView.reloadData()
    }
    
    func addLocation(location: LocationModel){
        if(locationDataSource.addLocation(location)) {
            locationTableView.reloadData()
        }
    }
    
    func deleteLocation(location: LocationModel){
        if(locationDataSource.deleteLocation(location)) {
            locationTableView.reloadData()
        }
    }
}

extension SearchLocationController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let address = searchBar.text!
        //find location
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if(error != nil || placemarks == nil || placemarks!.isEmpty){
                self.displayErrorAlert()
                return
            }
            
            if let placemark = placemarks!.first {
                DispatchQueue.main.async {
                    if(placemark.location == nil) { return }
                    
                    let locationModel = LocationModel()
                    locationModel.name = placemark.name ?? ""
                    locationModel.nation = placemark.country ?? ""
                    locationModel.lat = placemark.location!.coordinate.latitude
                    locationModel.long = placemark.location!.coordinate.longitude
                    locationModel.uuid = UUID().uuidString
                    
                    self.displayAddLocationAlert(location: locationModel)
                }
            }
            else {
                self.displayErrorAlert()
            }
        }
    }
    
    func displayErrorAlert(){
        let message = "No location found!"
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayAddLocationAlert(location: LocationModel) {
        let message = "Location found: \(location.fullLocation). Would you like to add this locations?"
        let alert = UIAlertController(title: "Location found!", message: message, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) {action in
            self.addLocation(location: location)
            self.searchBar.text = ""
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func clearButtonClicked(){
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension SearchLocationController: UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.LocationCell, for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        if let locations = self.locations {
            cell.textLabel?.text = "\(locations[indexPath.row].name), \(locations[indexPath.row].nation)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteLocation(location: self.locations![indexPath.row])
        }

        deleteAction.image = UIImage(systemName: "trash")
        return [deleteAction]
    }
}
