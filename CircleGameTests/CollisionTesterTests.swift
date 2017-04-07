//
//  CollisionTesterTests.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/6/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import XCTest

class CollisionTesterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTestOverGap() {
        let collisionTester = CollisionTesterImpl()
        let circleView = CircleView()
        let playerView = PlayerView()
        XCTAssertFalse(collisionTester.testOverGap(playerView: playerView, circleView: circleView))
        
        // Position this over the first gap
        while (Utils.limitAngle((circleView.gaps?[0].1)! + circleView.currentAngle) < 1.5 * Double.pi) {
            circleView.incrementAngle()
        }
        XCTAssertTrue(collisionTester.testOverGap(playerView: playerView, circleView: circleView))
        
        // Position this at the first safe position after the first gap
        while (Utils.limitAngle((circleView.gaps?[0].0)! + circleView.currentAngle) < 1.5 * Double.pi) {
            circleView.incrementAngle()
        }
        XCTAssertFalse(collisionTester.testOverGap(playerView: playerView, circleView: circleView))
    }
}
