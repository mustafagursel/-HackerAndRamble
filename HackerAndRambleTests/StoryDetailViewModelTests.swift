//
//  StoryDetailViewModelTests.swift
//  HackerAndRambleTests
//
//  Created by Mustafa Gursel on 1/25/22.
//

import XCTest
@testable import HackerAndRamble

class StoryDetailViewModelTests: XCTestCase {
    var sut: StoryDetailViewModel!
    var mockDependencyContainer: MockDependencyContainer!
    var mockHackerNewsStore: MockHackerNewsStore!

    override func setUpWithError() throws {
        super.setUp()

        mockDependencyContainer = MockDependencyContainer()
        DependencyContainer.shared = mockDependencyContainer

        mockHackerNewsStore = MockHackerNewsStore()
        mockHackerNewsStore.stubbedItem = StubbedData.storyDetail
        mockDependencyContainer.register(HackerNewsStoreProtocol.self) { self.mockHackerNewsStore }

        sut = StoryDetailViewModel()
    }

    override func tearDownWithError() throws {
        mockHackerNewsStore = nil
        mockDependencyContainer = nil
        sut = nil

        super.tearDown()
    }

    func testGetStoryDetailCalled() throws {
        sut.getStoryDetail(with: 0)
        XCTAssertTrue(mockHackerNewsStore.isGetItemCalled)
    }

    func testReceivedStoryDetail() throws {
        let expectation = XCTestExpectation(
            description: "Story detail data from viewModel should equal to stubbed data")

        var canCheckValue = false
        sut.items.bind { items in
            guard canCheckValue else { return }

            XCTAssertGreaterThanOrEqual(items.count, 1)
            XCTAssertEqual(items[0].id, 30068134)
            XCTAssertEqual(items[0].title, "Papers We Love")
            XCTAssertEqual(items[0].points, 114)
            XCTAssertEqual(items[0].user, "rammy1234")
            XCTAssertEqual(items[0].time, 1643086061)
            XCTAssertEqual(items[0].timeAgo, "2 days ago")
            XCTAssertEqual(items[0].type, "link")
            XCTAssertEqual(items[0].url, "https://github.com/papers-we-love/papers-we-love")
            XCTAssertEqual(items[0].domain, "github.com")
            expectation.fulfill()
        }

        canCheckValue = true
        sut.getStoryDetail(with: 30068134)

        wait(for: [expectation], timeout: 2)
    }
}
