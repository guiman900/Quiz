//
//  Answer+CoreDataClass.swift
//  Quiz
//
//  Created by Guillaume Manzano on 24/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/**
 Answer Core Data Model implementation
 */
public class Answer: NSManagedObject {
    // - MARK: Methods
    /**
     static method to create an Answer using the json data
     
     - Parameter data: json data get from the local file / network
     - Parameter context: core data context
     */
    internal class func createAnswer(data: [String: Any], context: NSManagedObjectContext, type: QuestionTypeEnum?) -> Answer? {
        let answer = NSEntityDescription.insertNewObject(forEntityName: "Answer", into: context) as? Answer

        answer?.id = data["id"] as? String
        if let isRight = data["isRight"] as? String {
            answer?.isRight = isRight.lowercased() == "true" ? true : false
        }
        else {
            answer?.isRight = false
        }
        
        if let type = type {
            if type == .images, let url = data["url"] as? String, let fileName = data["content"] as? String{
                answer?.content = fileName
                Answer.downloadImageFrom(url: url, fileName: fileName)
            }
            else {
                answer?.content = data["content"] as? String
            }
        }
        
        return answer
    }
    
    /**
     static method to get an image from the network and store it inside the document directory
     
     - Parameter url: online url of the image
     - Parameter filename: filename of the image
     */
    private class func downloadImageFrom(url: String, fileName: String){
        NetworkManager.networkManager.downloadImageFrom(url: url, fileName: fileName)
        {
            (data: Data?) in
            if let unWrappedData = data, let image = UIImage(data: unWrappedData) {
                Answer.saveImage(fileName: fileName, image: image)
            }
        }
    }
    
    /**
     static method to store the image inside the local folder
     
     - Parameter filename: filename of the image
     - Parameter image: image to save
     */
    private class func saveImage(fileName: String, image: UIImage)
    {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("\(fileName)")
            if let pngImageData = UIImagePNGRepresentation(image) {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        }
        catch { }
    }
}
