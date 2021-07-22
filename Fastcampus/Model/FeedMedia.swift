//
//  FeedMedia.swift
//  Fastcampus
//
//  Created by iwill.h on 2021/07/21.
//

import Foundation

enum FeedMediaType {
    case photo
    case movie
}

struct FeedMedia {
    let type: FeedMediaType
    let url: String
}

extension FeedMedia {
    static func createRandom() -> FeedMedia {
        let urls = [
            "https://images.unsplash.com/photo-1593642533144-3d62aa4783ec?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
            "https://images.unsplash.com/photo-1623435119185-3886f034006a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80",
            "https://images.unsplash.com/photo-1626639900754-78b8dddbcc37?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80",
            "https://images.unsplash.com/photo-1553272725-086100aecf5e?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=701&q=80",
            "https://images.unsplash.com/photo-1626541672773-ed6234412f07?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80"
        ]
        return FeedMedia(type: .photo, url: urls.randomElement()!)
    }
}
