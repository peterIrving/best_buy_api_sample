//
//  FindStoresViewController.swift
//  best_buy_lighting
//
//  Created by Peter Irving on 8/27/19.
//  Copyright © 2019 Peter Irving. All rights reserved.
//

import UIKit
import CoreLocation


class FindStoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
  
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    var imageUrl: String?
    var nameString: String?
    var descriptionString: String?
    var sku: Int?
    var stores: [Store] = []
    
    let locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        initiateSwitchState()
        loadStores()
    }
    
    
    func initiateSwitchState() {
        
        /// fetch bool from user defualts
        let useLocation = UserDefaults.standard.bool(forKey: "useLocation") ?? false
       
        locationSwitch.setOn(useLocation, animated: false)
        manageSwitchState()
    }
    
    func manageSwitchState() {
        if locationSwitch.isOn {
    
            getLocation()
            
        } else if !locationSwitch.isOn {
            UserDefaults.standard.set(false, forKey: "useLocation")
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func locationSwitchChanged(_ sender: UISwitch) {
        manageSwitchState()
    }
    
    
    func getLocation() {
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        print("location enabled? \(CLLocationManager.locationServicesEnabled())")
        if CLLocationManager.locationServicesEnabled() {
            
            UserDefaults.standard.set(true, forKey: "useLocation")
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
            let location = locationManager.location
            print("coordinates: \(location?.coordinate)")
            if let coordinates = location?.coordinate {
                latitude = coordinates.latitude
                longitude = coordinates.longitude
            }
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        latitude = locValue.latitude
//        longitude = locValue.longitude
//    }
    
    
    func loadStores() {
        self.showSpinner(onView: self.view)
        StoresForSkuApi().fetch(sku: sku!) { (stores, error) in
            print("stores for sku api called")
            if let error = error {
                print(error.localizedDescription)
                self.showNetworkErrorAlert(title: "There was an error",message: error.localizedDescription)
                self.removeSpinner()
                return
            }
            self.stores = stores!
            DispatchQueue.main.async {
                print("reloading data")
                self.tableView.reloadData()
                self.removeSpinner()
                if self.stores.isEmpty {
                    self.showNetworkErrorAlert(title: "No results",message: "There were no stores found")
                }
            }
        }
    }
    
    private func setupUI() {
        productNameLabel.text = nameString
        productDescriptionLabel!.text = descriptionString
        if let urlString = imageUrl{
            let imgUrl = URL(string: urlString)
            productImageView.kf.setImage(with: imgUrl)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
        cell.setupCell(store: stores[indexPath.row])
        return cell
    }
    
}
