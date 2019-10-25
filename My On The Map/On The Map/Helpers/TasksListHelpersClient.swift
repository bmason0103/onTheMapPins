//
//  TasksListHelpersClient.swift
//  On The Map
//
//  Created by Brittany Mason on 10/1/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

//MARK: Common vars to piece together later
class taskslisthelpers {
    
    var session = URLSession.shared
    //REPLACE THIS API KEY WITH SOMETHING REAL
    static let apiKey = "9e1ea9fb0278292ca5c96f4daf886916"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
}
    


    
    //MARK: List of helper functions to call for login methods
    
    //* TASK: Get student location, then store it (appDelegate.requestToken) and login with the token */
    // MARK: -- GET Student Location
    /***************************************************************/
    func taskGetStudentLocations (_ completionHandlerForGETStudentLocation: @escaping ( _ result: [LocationResponse]?, _ error: NSError?) -> Void) {
        
        //Set perameters
        let parametersForMethod = [
            parametersAll.GetParameter.limit : 150,
            parametersAll.GetParameter.order : "-updatedAt"
            ] as [String : Any]
        
        //2.3 BUILD THE URL AND CONFIG REQUEST
        let requestURL = parametersAll.Constants.studentLocationURL + parametersAll.escapedParameters (parametersForMethod as [String:AnyObject])
        
        let _ = Client.taskForGETMethod (urlString:requestURL) { (results, error) in
            
            if let error = error {
                
                completionHandlerForGETStudentLocation(nil, error)
            } else {
                if let results = results?[parametersAll.StudentLocation.Response] as? [[String:AnyObject]] {
                    // Creates a student object array from results
                    let studentInfo = LocationResponse.studentsFromResults(results)
                    completionHandlerForGETStudentLocation(studentInfo, nil)
                } else {
                    completionHandlerForGETStudentLocation(nil, NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
                }
            }
        }
        
    }
    
    // MARK: -- POST Student Session
    /***************************************************************/
    
    func taskPostStudentLocation(_ completionHandlerForPostStudentLocation: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        /* 1. Build the URL */
        let requestURL = parametersAll.Constants.studentLocationURL
        /* JSON Body */
        //set peramaters
        let jsonBody = "{\"uniqueKey\": \"\(parametersAll.StudentLocation.uniqueKey)\", \"firstName\": \"\(parametersAll.StudentLocation.firstName)\", \"lastName\": \"\(parametersAll.StudentLocation.lastName)\",\"mapString\": \"\(parametersAll.StudentLocation.uniqueKey)\", \"mediaURL\": \"\(parametersAll.StudentLocation.mediaURL)\",\"latitude\":\(parametersAll.StudentLocation.latitude), \"longitude\": \(parametersAll.StudentLocation.longitude)}"
        print(jsonBody)
        
        let headerFields = ["why": "hmm"]
        /* 2. Make the request */
        let task = Client.taskForPOSTMethod (urlString:requestURL, headerFields: headerFields, jsonBody: jsonBody) { (results, error) in
            
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPostStudentLocation(nil, error)
            } else {
                if let objectId = results?[parametersAll.StudentLocation.objectId] as? String {
                    completionHandlerForPostStudentLocation(objectId, nil)
                } else {
                    completionHandlerForPostStudentLocation(nil, NSError(domain: "postNewStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
                }
            }
        }
        
        task.resume()
    }
    
    
    // MARK: -- POST Authentication
    /***************************************************************/
    
    func taskPostASessionAuth ( username:String, password:String, _completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        //        udacitydict:[String:String]
        
        let urlString = parametersAll.Constants.sessionURL
        let headerFields = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        //        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        let task = Client.taskForPOSTMethod(urlString: urlString, headerFields: headerFields, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                
                _completionHandlerForAuth(false, error.localizedDescription)
            } else {
                if let account = results?[parametersAll.PostParameter.Account] as? NSDictionary {
                    if let accountKey = account[parametersAll.PostParameter.key] as? String{
                        postASessionResponse.SessionResponse.accountKey = accountKey
                        _completionHandlerForAuth(true, nil)
                        print("login successful")
                    }
                    
                } else {
                    print("Could not find \(parametersAll.PostParameter.key) in \(String(describing: results))")
                    _completionHandlerForAuth(false, "Invalid Credentials")
                    
                }
            }
        }
        
        task.resume()
        
        
    }
    
    // MARK: -- DELETE A Session
    /***************************************************************/
    func taskDeleteASession (){
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            //     let range = Range(5..<data!.count)
            //   let newData = data?.subdata(in: range) /* subset response data! */
            //   print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    // MARK: -- GET Public User Data
    /***************************************************************/
    
    func taskgetPublicUserData (_ completionHandlerForUserData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let urlString = parametersAll.Constants.userURL + "/\(postASessionResponse.SessionResponse.accountKey)"
        let headerFields = [String:String]()
        
        let task = Client.taskForGETMethod (urlString: urlString) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error.localizedDescription)
                completionHandlerForUserData(false, "There was an error getting user data.")
            } else {
                if let user = results?[parametersAll.StudentLocation.objectId] as? NSDictionary {
                    if let userFirstName = user[parametersAll.StudentLocation.firstName] as? String,
                        let userLastName = user[parametersAll.StudentLocation.lastName] as? String {
                        parametersAll.StudentLocation.publicfirstName = userFirstName
                        parametersAll.StudentLocation.publiclastName = userLastName
                    }
                } else {
                    print("Could not find \(parametersAll.StudentLocation.user) in \(String(describing: results))")
                    completionHandlerForUserData(false,"Could not get the user data.")
                }
            }
        }
        
        task.resume()
        
    }
    
  
    
    
    // MARK: -- Logout the User
    /***************************************************************/
    func logoutUser (_ request: URLRequest, completionHandlerForDELETEMethod: @escaping (_ _success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
        
        
        /* Build the URL */
        var urlString = parametersAll.Constants.sessionURL
        
        let task = Client.taskForDELETEMethod (request as URLRequest) { (results, error) in
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
                
                
                //        if let xsrfCookie = xsrfCookie {
                //                  urlString.setValue (xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
                
                
                /* 3. Send the desired value(s) to completion handler */
                if let error = error {
                    print(error.localizedDescription)
                    completionHandlerForDELETEMethod(false, "There was an error with logout.")
                } else {
                    if let session = results?[deleteSessionResponse.DeleteResponse.sessionId] as? NSDictionary {
                        if let expiration = session[deleteSessionResponse.DeleteResponse.expiration] as? String{
                            print("logged out: \(expiration)")
                            completionHandlerForDELETEMethod(true, nil)
                        }
                        
                    } else {
                        print("Could not find \(deleteSessionResponse.DeleteResponse.sessionId) in \(String(describing: results))")
                        completionHandlerForDELETEMethod(false, "Could not logout.")
                    }
                }
            }
        }
        return task
        
    }
    



