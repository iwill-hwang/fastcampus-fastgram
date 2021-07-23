//
//  FeedMovieCell.swift
//  Fastcampus
//
//  Created by iwill.h on 2021/07/23.
//

import Foundation
import UIKit
import AVKit

class FeedMovieCell: UICollectionViewCell, MediaPlayable {
    let player = AVPlayer()
    let playerLayer = AVPlayerLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.addSublayer(playerLayer)
        
        self.playerLayer.player = player
        self.playerLayer.videoGravity = .resizeAspectFill
        
        self.playerLayer.backgroundColor = UIColor.black.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.player.replaceCurrentItem(with: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = self.contentView.bounds
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
