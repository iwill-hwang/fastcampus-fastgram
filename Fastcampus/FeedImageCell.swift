//
//  FeedImageCell.swift
//  Fastcampus
//
//  Created by iwill.h on 2021/07/23.
//

import Foundation
import UIKit

class FeedImageCell: UICollectionViewCell {
    var url: URL! {
        didSet {
            imageView.setImage(url: url)
        }
    }
    @IBOutlet weak private var imageView: UIImageView!
}
