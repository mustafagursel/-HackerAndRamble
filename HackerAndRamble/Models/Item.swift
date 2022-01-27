//
//  Item.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import Foundation

struct Item: Codable {
    let id: Int
    let title: String?
    let points: Int?
    let user: String?
    let time: Int
    let timeAgo: String
    let content: String?
    let deleted: Bool?
    let dead: Bool?
    let type: String?
    let url: String?
    let domain: String?
    let comments: [Item]
    let level: Int?
    let commentsCount: Int?
}
