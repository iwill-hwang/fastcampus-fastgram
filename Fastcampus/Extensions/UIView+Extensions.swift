//
//  UIView+Extensions.swift
//  Fastcampus
//
//  Created by iwill.h on 2021/07/23.
//

import Foundation
import UIKit
extension UIView {
    func makeCircle() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}
