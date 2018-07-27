//
//  TimerProtocol.swift
//  Quiz
//
//  Created by Guillaume Manzano on 26/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 Protocol used by the TimerManager
 */
protocol TimerProtocol {
    // - MARK: Methods
    /**
     timer has been updated with a new time
     
     - Parameter timeLeft: time remaining before the end of the timer
     */
    func updateTimer(timeLeft: Int)
}
