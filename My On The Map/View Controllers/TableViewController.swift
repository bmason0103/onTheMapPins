//
//  TableViewController.swift
//  On The Map
//
//  Created by Brittany Mason on 10/2/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class mapTableViewController: UITableViewController {
    
    override func viewDidLoad() {
           super.viewDidLoad()

       }
       
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           tableView.reloadData()
       }
    
    // Mark: -- Table View Data Source
       /***************************************************************/
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of student locations: \(parametersAll.StudentLocation.studentsLocDict.count)")
           return parametersAll.StudentLocation.studentsLocDict.count
       }
       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cellID = "studentCell"
           let cell =  tableView.dequeueReusableCell(withIdentifier: cellID) as! mapTableviewCell
           let student = parametersAll.StudentLocation.studentsLocDict[(indexPath as NSIndexPath).row]
           cell.topTextNameLabelTableView.text = "\(student.firstName) \(student.lastName)"
           cell.URLLabelTableView.text = "\( parametersAll.StudentLocation.mediaURL)"
           
           return cell
       }
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedCell = parametersAll.StudentLocation.studentsLocDict[indexPath.row]
        if let url = URL(string: selectedCell.mediaURLs) {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
               }else{
                   performUIUpdatesOnMain {
//                       self.displayAlert(title: "Invalid URL", message: "Selected URL unable be opened.")
                   }
               }
           }else{
               performUIUpdatesOnMain {
//                   self.displayAlert(title: "Invalid URL", message: "Not a valid URL.")
               }
           }
           tableView.deselectRow(at: indexPath, animated: true)
       }
    /* Delete Feature */
        override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                // delete item at indexPath
                parametersAll.StudentLocation.studentsLocDict.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                print(parametersAll.StudentLocation.studentsLocDict)
            }
        
            return [delete]
            
        }

    }


    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }

    

