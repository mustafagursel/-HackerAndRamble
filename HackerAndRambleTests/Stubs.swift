//
//  Stubs.swift
//  HackerAndRambleTests
//
//  Created by Mustafa Gursel on 1/25/22.
//

import XCTest
@testable import HackerAndRamble

class StubbedData {
    static var topStories: [FeedItem] {
        guard let pathString = Bundle(for: StubbedData.self).path(forResource: "TopStoriesData", ofType: "json") else {
            fatalError("TopStoriesData.json not found")
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert TopStoriesData.json to String")
        }

        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert TopStoriesData.json to Data")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let result = try? decoder.decode([FeedItem].self, from: jsonData) else {
            fatalError("Unable to convert TopStoriesData.json to [FeedItem]")
        }

        return result
    }

    static var storyDetail: Item {
        guard let pathString = Bundle(for: StubbedData.self).path(forResource: "StoryDetailData", ofType: "json") else {
            fatalError("StoryDetailData.json not found")
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert StoryDetailData.json to String")
        }

        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert StoryDetailData.json to Data")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let result = try? decoder.decode(Item.self, from: jsonData) else {
            fatalError("Unable to convert StoryDetailData.json to Item")
        }

        return result
    }
}
