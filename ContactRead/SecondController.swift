//
//  SecondController.swift
//  ContactRead
//
//  Created by aravind-pt2199 on 20/09/18.
//  Copyright © 2018 aravind-pt2199. All rights reserved.
//

import UIKit
import CoreLocation

class SecondController: UIViewController , CLLocationManagerDelegate{
    var locationManager:CLLocationManager!
    @IBOutlet weak var textlabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
     }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print(" latitude = \(userLocation.coordinate.latitude)")
        print(" longitude = \(userLocation.coordinate.longitude)")
        
      
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                self.textlabel.text = placemark.locality
                print(placemark.administrativeArea!)
                print(placemark.country!)
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

}
