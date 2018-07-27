//
//  ScoreModel.swift
//  Quiz
//
//  Created by Guillaume Manzano on 26/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import UIKit

/**
 Model used for the Score TableView Cell in the ScoreViewController
 */
internal class ScoreModel: UITableViewCell
{
    // - MARK: properties
    /// good answers during the game
    @IBOutlet weak var goodAnswers: UILabel!
    /// wrong answers during the game
    @IBOutlet weak var wrongAnswers: UILabel!
    /// unanswered questions during the game
    @IBOutlet weak var unanswered: UILabel!
    /// total time of the game
    @IBOutlet weak var totalTime: UILabel!
    /// medal image if the score is in the podium
    @IBOutlet weak var podiumImage: UIImageView!
    /// view used for graphic purpose
    @IBOutlet weak var itemView: UIView!

    // - MARK: Methods
    /**
     Init the cell properties with a gameResult and the position of the cell
     
     - Parameter gameResult: the game result
     - Parameter index: the position of the question
     */
    internal func initCell(gameResult: GameResult, index: Int) {
        self.goodAnswers.text = "\(gameResult.rightAnswers)"
        self.wrongAnswers.text = "\(gameResult.wrongAnswers)"
        self.unanswered.text = "\(gameResult.unanswered)"
        self.totalTime.text = "\(gameResult.totalTime) s"
        
        switch index {
        case 0:
            podiumImage.image = UIImage(named: "first")
            itemView.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 179/255, blue: 12/255, alpha: 1)
            self.podiumImage.setShadow()
        case 1:
            podiumImage.image = UIImage(named: "second")
            itemView.backgroundColor = UIColor(colorLiteralRed: 125/255, green: 151/255, blue: 158/255, alpha: 1)
            self.podiumImage.setShadow()
        case 2:
            podiumImage.image = UIImage(named: "third")
            itemView.backgroundColor = UIColor(colorLiteralRed: 216/255, green: 139/255, blue: 86/255, alpha: 1)
            self.podiumImage.setShadow()
        default:
            podiumImage.isHidden = true
            itemView.backgroundColor = UIColor(colorLiteralRed: 125/255, green: 151/255, blue: 158/255, alpha: 1)
        }
        
        self.itemView.setShadow()
    }
}
