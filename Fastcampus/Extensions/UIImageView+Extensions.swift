//
//  UIImageView+Extensions.swift
//  Fastcampus
//
//  Created by iwill.h on 2021/07/23.
//

import Foundation
import AlamofireImage

extension UIImageView {
    func setImage(url: URL) {
        self.af.setImage(withURL: url, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: { response in
            if let error = response.error {
                print(error)
            }
        })
    }
}
