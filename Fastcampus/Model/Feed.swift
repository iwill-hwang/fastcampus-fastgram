//
//  Feed.swift
//  Fastcampus
//
//  Created by iwill.h on 2021/07/21.
//

import Foundation

struct Feed {
    let liked: Bool
    let likeCount: Int
    let content: String
    let user: User
}

extension Feed {
    static func createRandom() -> Feed {
        let user = User.createRandom()
        let likeCount = (1...10000).randomElement()!
        let liked = (0...1).randomElement() == 0 ? true : false
        let content = ""
        return Feed(liked: liked, likeCount: likeCount, content: content, user: user)
    }
}
