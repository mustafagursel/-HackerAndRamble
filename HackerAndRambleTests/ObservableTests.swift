//
//  ObservableTests.swift
//  HackerAndRambleTests
//
//  Created by Mustafa Gursel on 1/25/22.
//

import XCTest
@testable import HackerAndRamble

class ObservableTests: XCTestCase {
    var sut: Observable<Bool>!

    override func setUpWithError() throws {
        super.setUp()
        sut = Observable<Bool>(false)
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testObservableNotify() throws {
        let expectation = XCTestExpectation(description: "Value should notify observer.")
        let expectedValue = true

        var canCheckValue = false
        sut.bind { value in
            guard canCheckValue else { return }

            XCTAssertEqual(value, expectedValue)
            expectation.fulfill()
        }

        canCheckValue = true
        sut.value = expectedValue

        wait(for: [expectation], timeout: 2)
    }
}
