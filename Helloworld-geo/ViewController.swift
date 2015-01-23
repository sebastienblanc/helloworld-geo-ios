/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit
import CoreLocation
import AeroGearGeo

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
        
        let registration = DeviceRegistration(serverURL: NSURL(string: "<URL of geo server>")!)
        
        // attemp to register
        registration.registerWithClientInfo({ (var clientInfo: ClientDeviceInformation!) in
            // setup configuration
            clientInfo.alias = "<unique identifier>"
            clientInfo.apiKey = "<apiKey>"
            clientInfo.apiSecret = "<apiSecret>"

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

