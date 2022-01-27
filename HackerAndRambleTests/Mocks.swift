//
//  Mocks.swift
//  HackerAndRambleTests
//
//  Created by Mustafa Gursel on 1/25/22.
//

import Foundation
import XCTest
@testable import HackerAndRamble

class MockHackerNewsStore: NSObject, HackerNewsStoreProtocol {
    var isGetNewsFeedCalled = false
    var isGetItemCalled = false
    var stubbedNewsFeed: [FeedItem]?
    var stubbedItem: Item?

    func getNewsFeed(_ page: Int, _ completion: @escaping (Result<[FeedItem], HackerNewsStoreError>) -> Void) {
        isGetNewsFeedCalled = true

        guard let newsFeed = stubbedNewsFeed else {
            return completion(.failure(.apiError(.noDataFound)))
        }

        completion(.success(newsFeed))
    }

    func getItem(_ id: Int, _ completion: @escaping (Result<Item, HackerNewsStoreError>) -> Void) {
        isGetItemCalled = true

        guard let item = stubbedItem else {
            return completion(.failure(.apiError(.noDataFound)))
        }

        completion(.success(item))
    }
}

class MockHackerNewsApi: NSObject, HackerNewsApiProtocol {
    var isGetNewsFeedCalled = false
    var isGetItemCalled = false
    var stubbedNewsFeed: [FeedItem]?
    var stubbedItem: Item?

    func getNewsFeed(_ page: Int, _ completion: @escaping (Result<[FeedItem], HackerNewsApiError>) -> Void) {
        isGetNewsFeedCalled = true

        guard let newsFeed = stubbedNewsFeed else {
            return completion(.failure(.noDataFound))
        }

        completion(.success(newsFeed))
    }

    func getItem(_ id: Int, _ completion: @escaping (Result<Item, HackerNewsApiError>) -> Void) {
        isGetItemCalled = true

        guard let item = stubbedItem else {
            return completion(.failure(.noDataFound))
        }

        completion(.success(item))
    }
}

class MockDependencyContainer: DependencyContainerProtocol {
    var services = [String: FactoryClosure]()

    @discardableResult
    func register<Dependency>(_ type: Dependency.Type,
                              factory: @escaping FactoryClosure) -> DependencyContainerProtocol {
        services["\(type)"] = factory
        return self
    }

    func resolve<Dependency>(_ type: Dependency.Type) -> Dependency? {
        return services["\(type)"]?() as? Dependency
    }
}
