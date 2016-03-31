//
//  SecondViewController.swift
//  Chipotle Finder
//
//  Created by Joseph Garcia on 3/25/16.
//  Copyright © 2016 joebeard. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius: CLLocationDistance = 2000
    
    let locationManager = CLLocationManager()
    
    let nearbyRequest = MKLocalSearchRequest()
    
    var addresses: [String] = []
    var neighborhoods: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        map.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ChipotleCell
        
        if addresses.count > 0 {
            cell.neighborhoodText.text = neighborhoods[indexPath.row]
            cell.chipotleAddressText.text = addresses[indexPath.row]
        } else {
            cell.chipotleAddressText.text = "No Locations Nearby"
        }
       
        
        return cell
    }

    
    func getNearbyPlaces(location: CLLocation) {
        nearbyRequest.naturalLanguageQuery = "chipotle"
        nearbyRequest.region = map.region
        let search = MKLocalSearch(request: nearbyRequest)
        
        search.startWithCompletionHandler { (response, error) -> Void in
            if let chipotles = response?.mapItems {
                for chipotleLocation in chipotles {
                    if let chipotleInfo = chipotleLocation.placemark.addressDictionary{
                        self.grabDictionaryForChipotles(chipotleInfo)
                    }
                    
                    if let mark = chipotleLocation.placemark as MKAnnotation! {
                        self.map.addAnnotation(mark)
                    }
                }
            }
        }
    }
    
    func grabDictionaryForChipotles(dictionary: Dictionary<NSObject,AnyObject>) {
        var street = dictionary["Street"]!
        var city = dictionary["City"]!
        var state = dictionary["State"]!
        var zip = dictionary["ZIP"]!
        var subLocality = String(dictionary["SubLocality"])
        var addressString = "\(street), \(city), \(state) \(zip)"
        
        if subLocality == "nil" {
            subLocality = String(city)
        } else {
            subLocality = String(dictionary["SubLocality"]!)
        }
        
        var neighborhoodString = subLocality

        neighborhoods.append(neighborhoodString)
        addresses.append(addressString)
        tableView.reloadData()
    }
    
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordianteRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        map.setRegion(coordianteRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            centerMapOnLocation(loc)
            getNearbyPlaces(loc)
        }
    }
}

