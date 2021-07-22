//
//  Feed.swift
//  Fastcampus
//
//  Created by iwill.h on 2021/07/21.
//

import Foundation

struct Feed {
    let id: TimeInterval
    let content: String
    let user: User
    let medias: [FeedMedia]
    
    var liked: Bool
    var likeCount: Int
}

extension Feed {
    static func createRandom() -> Feed {
        let user = User.createRandom()
        let id = Date().timeIntervalSince1970
        let likeCount = (1...100).randomElement()!
        let liked = (0...1).randomElement() == 0 ? true : false
        let content = ""
        
        let count = (1...10).randomElement()!
        let medias = (1...count).map{_ in FeedMedia.createRandom()}
        
        return Feed(id: id, content: content, user: user, medias: medias, liked: liked, likeCount: likeCount)
    }
}

extension Feed: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
