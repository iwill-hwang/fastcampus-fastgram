//
//  MoviePlayerView.swift
//  Fastcampus
//
//  Created by donghyun on 2021/07/25.
//

import Foundation
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

