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
