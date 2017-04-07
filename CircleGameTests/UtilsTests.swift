//
//  UtilsTests.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/6/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import XCTest

class UtilsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDegreesToRadians() {
        let degreesRadiansConversions = [(0, 0.0), (180, Double.pi), (360, 2 * Double.pi)]
        for tuple in degreesRadiansConversions {
            XCTAssertEqualWithAccuracy(Utils.toRadians(degrees: Double(tuple.0)), tuple.1, accuracy: 0.0001)
        }
    }
    
    func testLimitAngle() {
        let lowAngle = Double.pi
        let highAngle = 3 * Double.pi
        XCTAssertEqual(Utils.limitAngle(lowAngle), lowAngle)
        XCTAssertEqual(Utils.limitAngle(highAngle), Double.pi)
    }
    
}
