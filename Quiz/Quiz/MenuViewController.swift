//
//  MenuViewController.swift
//  Quiz
//
//  Created by Guillaume Manzano on 24/07/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

/**
 Menu View Controller
 */
class MenuViewController: UIViewController {
    // - MARK: Properties
    /// score button
    @IBOutlet weak var scoreButton: UIButton!
    /// player button
    @IBOutlet weak var playButton: UIButton!
    /// video player for the quiz video
    private var player: AVPlayer?

    // - MARK: Methods
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreButton.setShadow()
        playButton.setShadow()
    }
    
    /**
     Called after the view controller's view received a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Load the quiz video
    */
    private func loadVideo(){
        // Load the video from the app bundle.
        let videoURL: URL = Bundle.main.url(forResource: "quiz", withExtension: "mov")! as URL
        
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = 9
        playerLayer.frame = CGRect(x: 0, y: 50, width: 300, height: 150)
        
        self.scoreButton.layer.zPosition = 1
        self.playButton.layer.zPosition = 1
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.loopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    /**
     replay the video (loop)
    */
    internal func loopVideo() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
}

