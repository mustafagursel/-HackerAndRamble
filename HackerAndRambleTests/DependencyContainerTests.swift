//
//  DependencyContainerTests.swift
//  HackerAndRambleTests
//
//  Created by Mustafa Gursel on 1/25/22.
//

import XCTest
@testable import HackerAndRamble

class DependencyContainerTests: XCTestCase {
    var sut: DependencyContainerProtocol!

    override func setUpWithError() throws {
        super.setUp()
        sut = DependencyContainer.shared
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testContainerShouldContainService() throws {
        let expectedService = MockHackerNewsApi()

        sut.register(HackerNewsApiProtocol.self) {
            expectedService
        }

        guard let service = sut.resolve(HackerNewsApiProtocol.self) as? MockHackerNewsApi else {
            XCTFail("Can not resolve expected service")
            return
        }

        XCTAssertEqual(service, expectedService)
    }
}
