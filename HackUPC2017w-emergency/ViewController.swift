//
//  ViewController.swift
//  HackUPC2017w-emergency
//
//  Created by usuari on 26/2/17.
//  Copyright © 2017 XFrostLabs. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController {

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - CLLocationManagerDelegate
extension UIViewController: CLLocationManagerDelegate {
    
    public func locationUpdate (_ latitude: Double, _ longitude: Double) {
        let urlString = "https://emergency-api.scalingo.io/api/devices/set_status"
        
        let params: Parameters = [
            "id": "xavo95",
            "lat": latitude,
            "lng": longitude
        ]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let json = response.result.value {
                    print("JSON: \(json)")
                } else {
                    print("Did not receive json")
                }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        let coordinates = locations.last?.coordinate
        //NSLog("Location: %f %f", (coordinates!.latitude), (coordinates!.longitude))
        locationUpdate(coordinates!.latitude, coordinates!.longitude)
        
        if UIApplication.shared.applicationState == .active {
            // Just for bants
        } else {
            print("App is backgrounded. New location is %@", mostRecentLocation)
        }
    }
    
}























