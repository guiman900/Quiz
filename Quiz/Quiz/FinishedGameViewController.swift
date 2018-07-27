//
//  FinishedGameViewController.swift
//  Quiz
//
//  Created by Guillaume Manzano on 26/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import UIKit

/**
 Finished Game Vie wController is used to display the result of the game played by the user
 */
class FinishedGameViewController: UIViewController {
    // - MARK: Properties
    /// table view containing the results cells
    @IBOutlet weak var tableView: UITableView!
    /// number of good answsers
    @IBOutlet weak var goodAnswers: UILabel!
    /// number of wrong answsers
    @IBOutlet weak var wrongAnswers: UILabel!
    /// number of unanswered questions
    @IBOutlet weak var unanswered: UILabel!
    /// quickest time for a question
    @IBOutlet weak var bestTime: UILabel!
    /// longest time for a question
    @IBOutlet weak var worstTime: UILabel!
    
    /// question that the user answsered during the game
    fileprivate let questions = GameManager.gameManager.getQuestions()
    
    // - MARK: Methods
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gameResult = GameResult.createGameResultWithGameManagerData()
        {
            GameResult.saveGameResult()
            print(GameManager.gameManager.getGameResultOrdered())
            
            self.goodAnswers.text = "\(gameResult.rightAnswers)"
            self.wrongAnswers.text = "\(gameResult.wrongAnswers)"
            self.unanswered.text = "\(gameResult.unanswered)"
            self.bestTime.text = "\(GameManager.gameManager.getQuestionTimeDetails(bestTime: true))"
            self.worstTime.text = "\(GameManager.gameManager.getQuestionTimeDetails(bestTime: false))"
        
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /**
     Called after the view controller's view received a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Method called when the user clicked on the Menu button.
     
     - Parameter sender: the menu button
    */
    @IBAction func FinishButtonPressed(_ sender: Any) {
        GameManager.gameManager.delegate?.returnToRootViewController()
    }
    
}


/**
 UITableView Data Source
 */
extension FinishedGameViewController: UITableViewDataSource, UITableViewDelegate {
    
    /**
     Asks the data source to return the number of sections in the table view.
     
     - Parameter tableView: An object representing the table view requesting this information.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.questions.count
    }
    
    /**
     Tells the data source to return the number of rows in a given section of a table view.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section in tableView.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count == 0 ? 0 : 1
    }
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     
     - Parameter tableView: A table-view object requesting the cell.
     - Parameter indexPath: An index path locating a row in tableView.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.generateCell(question: self.questions[indexPath.section], indexPath: indexPath)
    }
    
    /**
     Generate a cell based on the question type and the question status
     
     - Parameter question: the question to display
     - Parameter indexPath: the index path of the cell
    */
    private func generateCell(question: Question, indexPath: IndexPath) -> UITableViewCell {
        if let status = question.userAnswer?.getStatus()  {
            switch status {
                case .correct:
                    return generateCorrectCellByType(question: question, indexPath: indexPath)
                case .wrong:
                    return generateWrongAndUnanswerCellByType(question: question, indexPath: indexPath)
                case .unanswered:
                    return generateWrongAndUnanswerCellByType(question: question, indexPath: indexPath)
                case .undefined:
                    return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    /**
     Generate a cell for a correct answser
     
     - Parameter question: the question to display
     - Parameter indexPath: the index path of the cell
     */
    private func generateCorrectCellByType(question: Question, indexPath: IndexPath) -> UITableViewCell
    {
        switch question.getQuestionType() {
            case .text:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoodTextAnswer", for: indexPath) as? GoodTextAnswerModel else {
                    return UITableViewCell()
                }
                cell.initCell(question: question)
                return cell
            case .images:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageAnswer", for: indexPath) as? ImageAnswerModel else {
                    return UITableViewCell()
                }
                cell.initCell(question: question)
                return cell
        }
    }
    
    /**
     Generate a cell for a wrong answser
     
     - Parameter question: the question to display
     - Parameter indexPath: the index path of the cell
     */
    private func generateWrongAndUnanswerCellByType(question: Question, indexPath: IndexPath) -> UITableViewCell
    {
        switch question.getQuestionType() {
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WrongTextAnswer", for: indexPath) as? WrongTextAnswerModel else {
                return UITableViewCell()
            }
            cell.initCell(question: question)
            return cell
        case .images:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageAnswer", for: indexPath) as? ImageAnswerModel else {
                return UITableViewCell()
            }
            cell.initCell(question: question)
            return cell
        }
    }
    
    /**
     Asks the delegate for the height to use for the header of a particular section.
     This method allows the delegate to specify section headers with varying heights.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section of tableView .
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            tableViewHeaderFooterView.contentView.backgroundColor = UIColor.clear
            tableViewHeaderFooterView.backgroundColor = UIColor.clear
        }
    }

}
