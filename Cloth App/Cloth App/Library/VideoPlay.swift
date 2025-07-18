//
//  VideoPlay.swift
//  RaniCircle
//
//  Created by Apple on 30/10/20.
//  Copyright © 2020 YellowPanther. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlay: UIView {
    
    public var player : AVPlayer!
    
    init() {
        super.init(frame: CGRect.zero)
        self.initializePlayerLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializePlayerLayer()
        self.autoresizesSubviews = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializePlayerLayer()
    }
    
    private func initializePlayerLayer() {
        let playerLayer = self.layer as! AVPlayerLayer
        playerLayer.backgroundColor = UIColor.black.cgColor
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
    }
    
    override public class var layerClass: Swift.AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    func playVideoWithURL(url: URL) {
        player = AVPlayer(url: url)
        player.isMuted = false
        (self.layer as! AVPlayerLayer).player = player
    }
    
    func toggleMute() {
        player.isMuted = !player.isMuted
    }
    
    func isMuted() -> Bool {
        return player.isMuted
    }
    
    func togglePlay() {
        if player.rate > 0 {
            player.pause()
        }
        else {
            player.play()
        }
    }
    
    func isPlaying() -> Bool {
        return player.rate > 0
    }
}
