//
//  HackerNewsCache.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import Foundation

protocol HackerNewsCacheProtocol {
    func item(for id: Int) -> Item?
    func set(item: Item, for id: Int)
    func feed(for page: Int) -> [FeedItem]?
    func set(feed: [FeedItem], for page: Int)
}

class HackerNewsCache: HackerNewsCacheProtocol {
    @Injected var userDefaults: UserDefaults
    let itemKeyPrefix = "HackerNewsItem_"
    let feedKeyPrefix = "HackerNewsFeed_"

    func item(for id: Int) -> Item? {
        guard let data = userDefaults.data(forKey: "\(itemKeyPrefix)\(id)") else {
            return nil
        }

        return try? JSONDecoder().decode(Item.self, from: data)
    }

    func set(item: Item, for id: Int) {
        let data = try? JSONEncoder().encode(item)
        userDefaults.set(data, forKey: "\(itemKeyPrefix)\(id)")
    }

    func feed(for page: Int) -> [FeedItem]? {
        guard let data = userDefaults.data(forKey: "\(feedKeyPrefix)\(page)") else {
            return nil
        }

        return try? JSONDecoder().decode([FeedItem].self, from: data)
    }

    func set(feed: [FeedItem], for page: Int) {
        let data = try? JSONEncoder().encode(feed)
        userDefaults.set(data, forKey: "\(feedKeyPrefix)\(page)")
    }
}
