//
//  ScoreViewController.swift
//  Quiz
//
//  Created by Guillaume Manzano on 26/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import UIKit
/**
 Score View Controller is used to display the resume of the games saved on core data
 */
class ScoreViewController: UIViewController {
     // - MARK: Properties
    /// the table view containing the game results
    @IBOutlet weak var tableView: UITableView!
    /// games played and saved into core data
    fileprivate var gameResults: [GameResult] = []
    
    // - MARK: Methods
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
         self.gameResults = GameManager.gameManager.getGameResultOrdered()
        self.tableView.reloadData()
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
     Method called when the user clicked on the menu button
     
     - Parameter sender: the menu button
    */
    @IBAction func MenuButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


/**
 UITableView Data Source
 */
extension ScoreViewController: UITableViewDataSource, UITableViewDelegate {
    
    /**
     Asks the data source to return the number of sections in the table view.
     
     - Parameter tableView: An object representing the table view requesting this information.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.gameResults.count
    }
    
    /**
     Tells the data source to return the number of rows in a given section of a table view.
     
     - Parameter tableView: The table-view object requesting this information.
     - Parameter section: An index number identifying a section in tableView.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameResults.count == 0 ? 0 : 1
    }
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     
     - Parameter tableView: A table-view object requesting the cell.
     - Parameter indexPath: An index path locating a row in tableView.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreModel", for: indexPath) as? ScoreModel else {
            return UITableViewCell()
        }
        
        cell.initCell(gameResult: self.gameResults[indexPath.section] , index: indexPath.section)
        return cell
    }
    
}
