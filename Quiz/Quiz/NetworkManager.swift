//
//  NetworkManager.swift
//  Quiz
//
//  Created by Guillaume Manzano on 27/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 Simulate a network library / framework
 */
class NetworkManager {
    
    static let networkManager = NetworkManager()
    
    internal func getQuestions(url: String, completion: (_ result: [[String: Any]]) -> Void)
    {
        if let path = Bundle.main.path(forResource: "questions", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let quiz = jsonResult["quiz"] as? [[String: Any]] {
                    
                completion(quiz)
                }
            } catch {
                print("Unexpected error: \(error).")
            }
        }
    }
    
    
    /**
     static method to get an image from the network and store it inside the document directory
     
     - Parameter url: online url of the image
     - Parameter filename: filename of the image
     */
    internal func downloadImageFrom(url: String, fileName: String, completion: @escaping (_ result: Data?) -> Void){
        if let catPictureURL = URL(string: "\(url)\(fileName)") {
            let session = URLSession(configuration: .default)
            
            let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
                
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded cat picture with response code \(res.statusCode)")
                        if let imageData = data {
                            completion(imageData)
                            return
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
                completion(nil)
            }
            
            downloadPicTask.resume()
        }
    }
}
