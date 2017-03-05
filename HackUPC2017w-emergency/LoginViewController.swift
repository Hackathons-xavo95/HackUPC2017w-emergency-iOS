//
//  LoginViewController.swift
//  HackUPC2017w-emergency
//
//  Created by usuari on 5/3/17.
//  Copyright © 2017 XFrostLabs. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var UsernameText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    
    @IBAction func loginPressed(_ sender: Any) {
        if(UsernameText.text != "" && PasswordText.text != "") {
        
            let urlString = "https://emergency-api.scalingo.io/api/users/login"
        
            let params: Parameters = [
                "username": UsernameText.text!,
                "password": PasswordText.text!
            ]
        
            Alamofire.request(urlString, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default).responseJSON{ response in
                if response.result.value != nil {
                    let destination = GPSViewController()
                    destination.set_Id(self.UsernameText.text!)
                    self.navigationController?.pushViewController(destination, animated: true)
                } else {
                    let alertController = UIAlertController(title: "Login Error", message: "User or Password not exist", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close", style: .destructive, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        else {
            
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if(UsernameText.text != "" && PasswordText.text != "") {
            
            let urlString = "https://emergency-api.scalingo.io/api/users/register"
            
            let params: Parameters = [
                "email": "test@test.com",
                "username": UsernameText.text!,
                "password": PasswordText.text!
            ]
            
            Alamofire.request(urlString, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                if response.result.value != nil {
                    let destination = GPSViewController()
                    destination.set_Id(self.UsernameText.text!)
                    self.navigationController?.pushViewController(destination, animated: true)
                } else {
                    let alertController = UIAlertController(title: "Register Error", message: "User already exist", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close", style: .destructive, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        else {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
