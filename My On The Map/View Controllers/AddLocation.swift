//
//  AddLocation.swift
//  On The Map
//
//  Created by Brittany Mason on 10/2/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class addLocation: UIViewController, UITextFieldDelegate  {
    
    // Mark: - Outlets
/***************************************************************/
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterLinkTextField: UITextField!
    
 /***************************************************************/
    
    var address = ""
    var mediaURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterLocationTextField.delegate = self
        enterLinkTextField.delegate = self
    }
    
    func cancelButton(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
//    func findLocation (){
//        var location = enterLocationTextField.text
//        var link = enterLinkTextField.text
//    }
    
    func findLocationPressed(_ sender: Any) {
            /* Check if Text Fields are Empty */
            if enterLocationTextField.text!.isEmpty{
//                displayAlert(title: "Location Text Field Empty", message: "You must enter your Location")
            }else if enterLinkTextField.text!.isEmpty{
//                displayAlert(title: "URL Text Field Empty", message: "You must enter a Website")
            }else{
                address = enterLocationTextField.text!
                parametersAll.StudentLocation.mapString = enterLocationTextField.text!
                parametersAll.StudentLocation.mediaURL = enterLinkTextField.text!
                forwardGeocoding(address)
            }
        }
        
     
//        dismiss(animated: true, completion: nil)
        // MARK: -- Geolocation Helper Methods
        /***************************************************************/
        func forwardGeocoding(_ address: String) {
            CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
        
        private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
            
            guard (error == nil) else {
                print("Unable to Forward Geocode Address (\(String(describing: error)))")
//                displayAlert(title: "Geocode Error", message: "Unable to Forward Geocode Address")
                return
            }
            
            if let placemarks = placemarks, placemarks.count > 0 {
                let placemark = placemarks[0]
                if let location = placemark.location {
                    let coordinate = location.coordinate
                    print("*** coordinate ***")
                    print(placemark)
                    
                      parametersAll.StudentLocation.latitude = coordinate.latitude
                    parametersAll.StudentLocation .longitude = coordinate.longitude
                    
                    if (placemark.locality != nil && placemark.administrativeArea != nil){
                        parametersAll.StudentLocation .mapString = ("\(placemark.locality!),\(placemark.administrativeArea!)")
                    }
//                    presentSubmitLocationView()
                } else {
                    print("error")
//                    displayAlert(title: "User Data", message: "No Matching Location Found")
                }
            }
        }
        
//        func getUserName()  firstName:String, mediaURL:String, {
//           taskslisthelpers.taskPostStudentLocation()
//         task { (result, error) in
//                guard (errorString == nil) else{
//                    performUIUpdatesOnMain {
////                        self.displayAlert(title: "User Data", message: errorString)
//                    }
//                    return
//                }
            }
//        }
        
//        private func presentSubmitLocationView(){
////            self.hideActivityIndicator(self.activityIndicator)
//            performSegue(withIdentifier: "submitNewLocation", sender: self)
//        }
//
//        // MARK: -- TextField Helper
//        /***************************************************************/
//        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            view.endEditing(true)
//            return false
//        }
    
    //End of class
    


    
    


