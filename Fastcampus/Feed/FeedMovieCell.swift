//
//  FeedMovieCell.swift
//  Fastcampus
//
//  Created by iwill.h on 2021/07/23.
//

import Foundation
import UIKit
import AVKit

class MoviePlayerView: UIView {
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    // The associated player object.
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}

class FeedMovieCell: UICollectionViewCell, MediaPlayable {
    let player = AVPlayer()
    
    @IBOutlet weak private var playerView: MoviePlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.playerView.player = player
        self.playerView.playerLayer.videoGravity = .resizeAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.player.replaceCurrentItem(with: nil)
    }
    
    func resume() {
        self.player.play()
    }
    
    func pause() {
        self.player.pause()
    }
    
    func isPlayable(from superview: UIScrollView) -> Bool {
        let intersection = superview.bounds.intersection(self.frame)
        return intersection.width > self.frame.width * 0.5
    }
}
