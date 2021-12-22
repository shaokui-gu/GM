//
//  File.swift
//  
//
//  Created by gavin on 2021/12/22.
//

import XCTest
@testable import GM

final class GMTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let deviceId = GM.deviceID
        XCTAssertNotNil(deviceId)
    }
}

