//
//  UIColor.swift
//  Quiz
//
//  Created by Guillaume Manzano on 27/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

/**
UIColor extension
 */
extension UIColor
{
    /**
     Get specific color for an AnswerStatusEnum.
     
     - Parameter status: the AnswerStatusEnum.
    */
    static func getColorByStatus(status: AnswerStatusEnum) -> UIColor
    {
        switch status {
        case .correct:
            return UIColor(colorLiteralRed: 131/255, green: 192/255, blue: 139/255, alpha: 1)
        case .wrong:
            return UIColor(colorLiteralRed: 148/255, green: 28/255, blue: 26/255, alpha: 1)
        case .unanswered:
            return UIColor(colorLiteralRed: 246/255, green: 204/255, blue: 71/255, alpha: 1)
        default:
            return UIColor(colorLiteralRed: 176/255, green: 176/255, blue: 176/255, alpha: 1)
        }

    }
}
