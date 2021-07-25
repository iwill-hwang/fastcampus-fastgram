//
//  MoviePlayable.swift
//  Fastcampus
//
//  Created by donghyun on 2021/07/25.
//

import Foundation
import UIKit

protocol MoviePlayable: UIView {
    func isPlayable(from superview: UIScrollView) -> Bool
    func resume()
    func pause()
}
