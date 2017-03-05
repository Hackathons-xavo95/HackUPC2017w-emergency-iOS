//
//  GPSViewController.swift
//  HackUPC2017w-emergency
//
//  Created by usuari on 5/3/17.
//  Copyright © 2017 XFrostLabs. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class GPSViewController: UIViewController {

    @IBOutlet weak var LatitudeText: UITextField!
    @IBOutlet weak var LongitudeText: UITextField!
    @IBOutlet weak var ConflictText: UILabel!
    
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startUpdatingLocation()
        self.title = "GPS"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - CLLocationManagerDelegate
extension GPSViewController: CLLocationManagerDelegate {
    
    public func set_Id(_ pId: String) {
        id = pId
    }
    
    public func locationUpdate (_ latitude: Double, _ longitude: Double) {
        let urlString = "https://emergency-api.scalingo.io/api/devices/set_status"
        
        let params: Parameters = [
            "id": id,
            "lat": latitude,
            "lng": longitude
        ]
        
        let urlString2 = "https://emergency-api.scalingo.io/api/conflicts/get_individual_conflict"
        
        let params2: Parameters = ["id": id]
        
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            if response.result.value != nil {
                self.LatitudeText.text = String(format: "%f", latitude)
                self.LongitudeText.text = String(format: "%f", longitude)
            } else {
                print("Did not receive json")
            }
            Alamofire.request(urlString2, method: HTTPMethod.post, parameters: params2, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                if response.result.value != nil {
                    let swiftyJsonVar = JSON(response.result.value!)
                    let conflict = swiftyJsonVar["features"][0]["properties"]["conflict"]
                    if (conflict == 0) {
                        self.ConflictText.text = "There is no conflict"
                    }
                    else {
                        self.ConflictText.text = "Near conflict"
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
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        let coordinates = locations.last?.coordinate
        locationUpdate(coordinates!.latitude, coordinates!.longitude)
        
        if UIApplication.shared.applicationState == .active {
            // Just for bants
        } else {
            print("App is backgrounded. New location is %@", mostRecentLocation)
        }
    }
    
}















