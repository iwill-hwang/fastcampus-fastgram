//
//  User.swift
//  Fastcampus
//
//  Created by iwill.h on 2021/07/21.
//

import Foundation

struct User {
    let name: String
    let profileImageURL: String
    let feeds: [Feed]
}


extension User {
    static func createRandom() -> User {
        let names = [
            "김개똥", "김철수", "이나영", "원빈", "공유"]
        
        let profileImages = [
            "https://img.lovepik.com/photo/50146/2489.jpg_wh860.jpg",
            "https://live.staticflickr.com/8133/30003917960_f58619f2ae_b.jpg"
        ]
        
        return User(name: names.randomElement()!, profileImageURL: profileImages.randomElement()!, feeds: [])
    }
}
