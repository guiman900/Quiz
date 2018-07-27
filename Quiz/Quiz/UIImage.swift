//
//  UIImage.swift
//  Quiz
//
//  Created by Guillaume Manzano on 26/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

/**
 UIImage extensions
 */
extension UIImage
{
    // - MARK: properties
    /// document folder path
    static var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    // - MARK: Methods
    /**
     Generate an UIImage from a file saved inside the iPad
     
     - Parameter fileName: file name used to create the UIImage
     */
    static func load(fileName: String?) -> UIImage? {
        
        if let fileName = fileName {
            let fileURL = documentsUrl.appendingPathComponent(fileName)
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                print("Error loading image : \(error)")
            }
        }
        return nil
    }
}

extension UIImageView {
    // - MARK: Methods
    /**
     Set the corder radius of a UIImageView
     */
    internal func setRound() {
        self.layer.cornerRadius = 0.025 * self.bounds.size.width
        self.clipsToBounds = true
    }

}
