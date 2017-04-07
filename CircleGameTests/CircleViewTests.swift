//
//  CircleViewTests.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/6/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import XCTest
import CircleGame

class CircleViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRotationTransform() {
        let circleView = CircleView()
        XCTAssertEqual(circleView.currentAngle, 0)
        circleView.incrementAngle()
        let expectedRotation = 2.0 * Double.pi / Double(GameSettings.FULL_CIRCLE_ROTATION_FRAMES)
        let inverseAffineTransform = circleView.transform.rotated(by: -CGFloat(expectedRotation))
        XCTAssertEqual(inverseAffineTransform, CGAffineTransform.identity)
    }
    
    func testRotationRadians() {
        let circleView = CircleView()
        XCTAssertEqual(circleView.currentAngle, 0)
        circleView.incrementAngle()
        let expectedRotation = 2.0 * Double.pi / Double(GameSettings.FULL_CIRCLE_ROTATION_FRAMES)
        XCTAssertEqual(expectedRotation, circleView.currentAngle)
    }
    
    func testIncrementGaps() {
        let circleView = CircleView()
        var gaps = circleView.gaps!
        XCTAssert(gaps.count == 2)
        var gap1 = gaps[0]
        var gap2 = gaps[1]

        XCTAssertEqual(gap1.0, (2 * Double.pi) / Double(2))
        XCTAssertEqual(gap1.1, (2 * Double.pi) / Double(2) + Utils.toRadians(degrees: GameSettings.GAP_SIZE))
        XCTAssertEqual(gap2.0, 2 * (2 * Double.pi) / Double(2))
        XCTAssertEqual(gap2.1, 2 * (2 * Double.pi) / Double(2) + Utils.toRadians(degrees: GameSettings.GAP_SIZE))
        
        circleView.incrementGaps()

        // Interesting thing I learned: Arrays are VALUE TYPES in Swift! NEAT!
        gaps = circleView.gaps!
        XCTAssert(gaps.count == 3)
        gap1 = gaps[0]
        gap2 = gaps[1]
        let gap3 = gaps[2]
        
        XCTAssertEqual(gap1.0, (2 * Double.pi) / Double(3))
        XCTAssertEqual(gap1.1, (2 * Double.pi) / Double(3) + Utils.toRadians(degrees: GameSettings.GAP_SIZE))

        XCTAssertEqual(gap2.0, 2 * (2 * Double.pi) / Double(3))
        XCTAssertEqual(gap2.1, 2 * (2 * Double.pi) / Double(3) + Utils.toRadians(degrees: GameSettings.GAP_SIZE))

        XCTAssertEqual(gap3.0, 3 * (2 * Double.pi) / Double(3))
        XCTAssertEqual(gap3.1, 3 * (2 * Double.pi) / Double(3) + Utils.toRadians(degrees: GameSettings.GAP_SIZE))
    }
    
    func testResetGaps() {
        let circleView = CircleView()
        var gaps = circleView.gaps!
        XCTAssertEqual(gaps.count, 2)
        circleView.incrementGaps()
        gaps = circleView.gaps!
        XCTAssertEqual(gaps.count, 3)
        circleView.resetGaps()
        gaps = circleView.gaps!
        XCTAssertEqual(gaps.count, 2)
    }
}
