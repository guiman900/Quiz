//
//  UIVIew.swift
//  Quiz
//
//  Created by Guillaume Manzano on 27/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

/**
 UIVIew Extension
 */
extension UIView
{
    /**
     Add shadow to the UI View
     */
    func setShadow()
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1.0
    }
}
