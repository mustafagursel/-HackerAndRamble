//
//  FeedItem.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import Foundation

struct FeedItem: Codable {
    let id: Int
    let title: String
    let type: String
    let commentsCount: Int
    let time: Int
    let timeAgo: String
    let points: Int?
    let user: String?
    let url: String?
    let domain: String?
}
