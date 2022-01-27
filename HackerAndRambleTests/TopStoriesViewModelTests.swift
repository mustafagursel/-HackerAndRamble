//
//  TopStoriesViewModelTests.swift
//  HackerAndRambleTests
//
//  Created by Mustafa Gursel on 1/25/22.
//

import XCTest
@testable import HackerAndRamble

class TopStoriesViewModelTests: XCTestCase {
    var sut: TopStoriesViewModel!
    var mockDependencyContainer: MockDependencyContainer!
    var mockHackerNewsStore: MockHackerNewsStore!

    override func setUpWithError() throws {
        super.setUp()

        mockDependencyContainer = MockDependencyContainer()
        DependencyContainer.shared = mockDependencyContainer

        mockHackerNewsStore = MockHackerNewsStore()
        mockHackerNewsStore.stubbedNewsFeed = StubbedData.topStories
        mockDependencyContainer.register(HackerNewsStoreProtocol.self) { self.mockHackerNewsStore }

        sut = TopStoriesViewModel()
    }

    override func tearDownWithError() throws {
        mockHackerNewsStore = nil
        mockDependencyContainer = nil
        sut = nil

        super.tearDown()
    }

    func testGetStoriesCalled() throws {
        sut.getStories()
        XCTAssertTrue(mockHackerNewsStore.isGetNewsFeedCalled)
    }

    func testReceivedStoriesCount() throws {
        let expectation = XCTestExpectation(
            description: "News count from viewModel should equal to stubbed data count")
        let expectedValue = StubbedData.topStories.count

        var canCheckValue = false
        sut.stories.bind { stories in
            guard canCheckValue else { return }

            XCTAssertEqual(stories.count, expectedValue)
            expectation.fulfill()
        }

        canCheckValue = true
        sut.getStories()

        wait(for: [expectation], timeout: 2)
    }

    func testReceivedStory() throws {
        let expectation = XCTestExpectation(
            description: "News data from viewModel should equal to stubbed data")

        var canCheckValue = false
        sut.stories.bind { stories in
            guard canCheckValue else { return }

            XCTAssertGreaterThanOrEqual(stories.count, 1)
            XCTAssertEqual(stories[0].id, 30070227)
            XCTAssertEqual(stories[0].title, "Snek: A Python-Inspired Language for Embedded Devices")
            XCTAssertEqual(stories[0].points, 27)
            XCTAssertEqual(stories[0].user, "pantalaimon")
            XCTAssertEqual(stories[0].time, 1643105972)
            XCTAssertEqual(stories[0].timeAgo, "2 days ago")
            XCTAssertEqual(stories[0].commentsCount, 0)
            XCTAssertEqual(stories[0].type, "link")
            XCTAssertEqual(stories[0].url, "https://sneklang.org/")
            XCTAssertEqual(stories[0].domain, "sneklang.org")
            expectation.fulfill()
        }

        canCheckValue = true
        sut.getStories()

        wait(for: [expectation], timeout: 2)
    }
}
