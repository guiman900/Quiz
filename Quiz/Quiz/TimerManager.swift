//
//  TimerManager.swift
//  Quiz
//
//  Created by Guillaume Manzano on 25/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 Timer manager
 */
class TimerManager {
    // - MARK: Properties
    /// shared instance of the timeManager
    static var timerManager = TimerManager()
    /// delegate to communicate with the GameSubViewControllers
    internal var delegate: TimerProtocol? = nil
    /// number of seconds remaining before the end of the timer
    private var seconds = 0
    /// timer object
    private var timer: Timer? = nil
    
    // - MARK: Methods
    /**
     Start the timer
     */
    internal func runTimer() {
        self.seconds = 15
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    /**
     Method trigered everytime the time remaining change.
     call the delegate method: updateTimer
    */
    @objc func updateTimer() {
        self.seconds -= 1
        delegate?.updateTimer(timeLeft: seconds)
        if self.seconds <= 0 {
            self.stopTimer()
        }
    }
    
    /**
     stop the timer
    */
    internal func stopTimer(){
        self.timer?.invalidate()
    }
    
    /**
     add additionnal time because the player used the time bonus
    */
    internal func useTimeBonus()
    {
        self.seconds += 10
    }
    
    /**
     Get the number of seconds remaining
     */
    internal func getSeconds() -> Int
    {
        return self.seconds
    }
}
