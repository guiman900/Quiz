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
    /// dark background for the video
    @IBOutlet weak var viewForVideo: UIView!
    /// video player for the intro
    private var player: AVPlayer?
    /// video layer
    private var playerLayer: AVPlayerLayer?
    
    // - MARK: Methods
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreButton.setShadow()
        playButton.setShadow()
        self.loadVideo()
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
        let videoURL: URL = Bundle.main.url(forResource: "glitch", withExtension: "mp4")! as URL
        
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        self.playerLayer = AVPlayerLayer(player: player)
            
            playerLayer?.videoGravity = AVLayerVideoGravityResizeAspect
            playerLayer?.frame = CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        if let playerLayer = self.playerLayer {
            view.layer.addSublayer(playerLayer)
        }
        
            player?.play()
        
        //loop video
            NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.stopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    /**
     replay the video (loop)
    */
    internal func stopVideo() {
        self.player?.pause()
        self.player?.replaceCurrentItem(with: nil)
        self.player = nil
        self.playerLayer?.removeFromSuperlayer()
        self.viewForVideo.removeFromSuperview()
    }
}

