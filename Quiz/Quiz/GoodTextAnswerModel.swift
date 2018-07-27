//
//  GoodTextAnswerModel.swift
//  Quiz
//
//  Created by Guillaume Manzano on 26/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

/**
Model used for the GoodTextAnswer TableView Cell in the FinishedGameViewController
 */
internal class GoodTextAnswerModel: UITableViewCell
{
    // - MARK: properties
    /// question text
    @IBOutlet weak var question: UILabel!
    /// second bonus used during the question
    @IBOutlet weak var otherBonusUsed: UIImageView!
    /// first bonus used during the question
    @IBOutlet weak var bonusUsed: UIImageView!
    /// use response
    @IBOutlet weak var response: UILabel!
    /// time that took the user to respond
    @IBOutlet weak var time: UILabel!
    /// main view cell
    @IBOutlet weak var mainView: UIView!
    // - MARK: Methods
    /**
     Init the cell properties with a question
     
     - Parameter question: the question with the result to display
     */
    internal func initCell(question: Question) {
        self.question.text = question.text
        if let bonus = question.userAnswer?.getBonus() {
            self.otherBonusUsed.isHidden = bonus == .all ? false : true
            self.bonusUsed.isHidden = bonus != .none ? false : true
            switch bonus {
            case .all:
                self.bonusUsed.image = UIImage(named: "watch")
                self.otherBonusUsed.image = UIImage(named: "fifty")
                break
            case .extraTime:
                self.bonusUsed.image = UIImage(named: "watch")
            case .fiftyFifty:
                self.bonusUsed.image = UIImage(named: "fifty")
            default:
                break
            }
        }
        else {
            self.otherBonusUsed.isHidden = true
            self.bonusUsed.isHidden = true
        }
        
        if let userAnswer = question.userAnswer {
            self.contentView.backgroundColor = UIColor.getColorByStatus(status:  userAnswer.getStatus())
        }
        
        self.response.text = question.userAnswer?.getReponseTextForId(id: question.userAnswer?.userReponseId)

        if let time = question.userAnswer?.time {
            self.time.text = "\(time) S"
        }
        else {
            self.time.text = "?? S"
        }
    }
}
