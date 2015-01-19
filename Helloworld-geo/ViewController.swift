//
//  ViewController.swift
//  Helloworld-geo
//
//  Created by sebi-mbp on 18/01/15.
//  Copyright (c) 2015 sebi-mbp. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
         println("view loaded")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func registerWithGeoServer(sender: AnyObject) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.stopUpdatingLocation()
        var localValue:CLLocationCoordinate2D = manager.location.coordinate
        
        let registration = AGDeviceRegistration(serverURL: NSURL(string: "http://192.168.1.19:8080/unified-geo-server")!)
        
        // attemp to register
        registration.registerWithClientInfo({ (clientInfo: AGClientDeviceInformation!) in
            // setup configuration
            clientInfo.alias = "seboule"
            clientInfo.apiKey = "fa7612b4-329c-417a-80e5-2a48eb44dde4"
            clientInfo.apiSecret = "8e82aaca-f733-4fbf-9834-16291d9eb726"
            
            
            clientInfo.longitude = localValue.longitude
            clientInfo.latitude = localValue.latitude
            },
            
            success: {
                println("UnifiedGeo Server registration succeeded")
                self.locationManager.stopUpdatingLocation()
            },
            failure: {(error: NSError!) in
                println("failed to register, error: \(error.description)")
        })

    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
         println("failed to retrieve location, error: \(error.localizedDescription)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}

