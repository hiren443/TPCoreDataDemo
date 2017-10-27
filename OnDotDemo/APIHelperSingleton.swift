//
//  APIHelperSingleton.swift
//  OnDotDemo
//
//  Created by Hiren Bhadreshwara on 25/10/17.
//  Copyright © 2017 Hiren Bhadreshwara. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class APIHelperSingleton: NSObject {
    
    //In Objetive C
   /* + (instancetype)sharedInstance {
        static Kraken *sharedInstance = nil;
        static dispatch_once_t onceToken;
    
        dispatch_once(&onceToken, ^{
            sharedInstance = [[Kraken alloc] init];
        });
        return sharedInstance;
    }*/
    // Below line is enough to creare single ton in Swift
    
    
    static let sharedInstance = APIHelperSingleton()
    
     let baseURL = "http://api.randomuser.me/"
    
    func getRandomUser(onCompletion: @escaping (JSON) -> Void) {
        let route = baseURL
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    // MARK: Perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error as NSError?)
            } else {
                onCompletion(JSON.null, error as NSError?)
            }
        })
        task.resume()
    }
    
    // MARK: Perform a POST Request
    private func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        // Set the method to POST
        request.httpMethod = "POST"
        
        do {
            // Set the POST body for the request
            let jsonBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody = jsonBody
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil)
                } else {
                    onCompletion(JSON.null, error as NSError?)
                }
            })
            task.resume()
        } catch {
            // Create your personal error
            onCompletion(JSON.null, nil)
        }
    }
}
