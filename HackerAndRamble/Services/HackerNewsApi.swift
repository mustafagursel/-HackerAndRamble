//
//  HackerNewsApi.swift
//  HackerAndRamble
//
//  Created by Mustafa Gursel on 1/25/22.
//

import Foundation

enum HackerNewsApiError: Error {
    case missingUrl
    case decodeFailed
    case noDataFound
    case badUrl
    case networkError(_ error: Error)
}

protocol HackerNewsApiProtocol {
    func getNewsFeed(_ page: Int, _ completion: @escaping (Result<[FeedItem], HackerNewsApiError>) -> Void)
    func getItem(_ id: Int, _ completion: @escaping (Result<Item, HackerNewsApiError>) -> Void)
}

class HackerNewsApi: HackerNewsApiProtocol {

    var newsFeedCache: [Int: [FeedItem]] = [:]
    var itemCache: [Int: Item] = [:]

    func getNewsFeed(_ page: Int, _ completion: @escaping (Result<[FeedItem], HackerNewsApiError>) -> Void) {
        if let cachedNews = newsFeedCache[page] {
            return completion(.success(cachedNews))
        }

        let urlString = "https://api.hackerwebapp.com/news?page=\(page)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl))
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else { return completion(.failure(.networkError(error!)))}
            guard let data = data else { return completion(.failure(.noDataFound)) }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let result = try? decoder.decode([FeedItem].self, from: data) {
                self.newsFeedCache[page] = result
                completion(.success(result))
            } else {
                completion(.failure(.decodeFailed))
            }
        }.resume()
    }

    func getItem(_ id: Int, _ completion: @escaping (Result<Item, HackerNewsApiError>) -> Void) {
        if let cachedItem = itemCache[id] {
            return completion(.success(cachedItem))
        }

        let urlString = "https://api.hackerwebapp.com/item/\(id)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(.badUrl))
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else { return completion(.failure(.networkError(error!)))}
            guard let data = data else { return completion(.failure(.noDataFound)) }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let result = try? decoder.decode(Item.self, from: data) {
                self.itemCache[id] = result
                completion(.success(result))
            } else {
                completion(.failure(.decodeFailed))
            }
        }.resume()
    }
}
