//
//  HackerNewsStore.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import Foundation

enum HackerNewsStoreError: Error {
    case apiError(_ error: HackerNewsApiError)
}

protocol HackerNewsStoreProtocol {
    func getNewsFeed(_ page: Int, _ completion: @escaping (Result<[FeedItem], HackerNewsStoreError>) -> Void)
    func getItem(_ id: Int, _ completion: @escaping (Result<Item, HackerNewsStoreError>) -> Void)
}

class HackerNewsStore: HackerNewsStoreProtocol {
    @Injected var api: HackerNewsApiProtocol
    @Injected var cache: HackerNewsCacheProtocol

    func getNewsFeed(_ page: Int, _ completion: @escaping (Result<[FeedItem], HackerNewsStoreError>) -> Void) {
        api.getNewsFeed(page) { [weak self] result in
            switch result {
            case .success(let feed):
                self?.cache.set(feed: feed, for: page)
                completion(.success(feed))
            case .failure(let error):
                if let feed = self?.cache.feed(for: page) {
                    completion(.success(feed))
                    return
                }
                completion(.failure(.apiError(error)))
            }
        }
    }

    func getItem(_ id: Int, _ completion: @escaping (Result<Item, HackerNewsStoreError>) -> Void) {
        if let item = cache.item(for: id) {
            print("item used from cache")
            completion(.success(item))
            return
        }

        api.getItem(id) { [weak self] result in
            switch result {
            case .success(let item):
                self?.cache.set(item: item, for: id)
                completion(.success(item))
            case .failure(let error):
                completion(.failure(.apiError(error)))
            }
        }
    }
}
