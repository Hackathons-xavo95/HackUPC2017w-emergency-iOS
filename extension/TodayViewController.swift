//
//  TodayViewController.swift
//  extension
//
//  Created by usuari on 5/3/17.
//  Copyright © 2017 XFrostLabs. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import Alamofire
import SwiftyJSON

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
        
    @IBOutlet weak var LatLabel: UILabel!
    @IBOutlet weak var LonLabel: UILabel!
    @IBOutlet weak var ConflictLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestLocation()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        let coordinates = locations.last?.coordinate
        locationUpdate(coordinates!.latitude, coordinates!.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationUpdate(_ latitude: Double, _ longitude: Double)
    {
        let urlString = "https://emergency-api.scalingo.io/api/devices/set_status"
        
        let params: Parameters = [
            "id": "xavo95",
            "lat": latitude,
            "lng": longitude
        ]
        
        let urlString2 = "https://emergency-api.scalingo.io/api/conflicts/get_individual_conflict"
        
        let params2: Parameters = ["id": "xavo95"]
        
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            if response.result.value != nil {
                self.LatLabel.text = String(format: "%f", latitude)
                self.LonLabel.text = String(format: "%f", longitude)
            } else {
                print("Did not receive json")
            }
            Alamofire.request(urlString2, method: HTTPMethod.post, parameters: params2, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                if response.result.value != nil {
                    let swiftyJsonVar = JSON(response.result.value!)
                    let conflict = swiftyJsonVar["features"][0]["properties"]["conflict"]
                    if (conflict == 0) {
                        self.ConflictLabel.text = "There is no conflict"
                    }
                    else {
                        self.ConflictLabel.text = "Near conflict"
                        let alertController = UIAlertController(title: "Disaster", message: "You have a nearby disaster, please contact emergency services", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Close", style: .destructive, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    print("Did not receive json")
                }
            })
        })
    }
}
