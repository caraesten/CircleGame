//
//  CircleGameTests.swift
//  CircleGameTests
//
//  Created by Esten Hurtle on 4/6/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import XCTest

class ViewControllerTests: XCTestCase {
    var vc:ViewController? = nil
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle:Bundle(for: self.classForCoder))
        vc = (storyboard.instantiateInitialViewController() as! ViewController)
        
        // Load the view
        _ = vc?.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGameStep() {
        let fakeTimer = Timer()
        vc?.mCollisionTester = NeverCollisionTester()
        // Ideally, I could create mock views and check incrementAngle has been called.
        XCTAssertEqual(vc?.mCircleView.currentAngle, 0.0)
        vc?.gameStep(t: fakeTimer)
        let expectedRotation = 2.0 * Double.pi / Double(GameSettings.FULL_CIRCLE_ROTATION_FRAMES)
        XCTAssertEqual(vc?.mCircleView.currentAngle, expectedRotation)
        XCTAssertTrue((vc?.mPlayerView.isAlive)!)
        
        vc?.mCollisionTester = AlwaysCollisionTester()
        vc?.gameStep(t: fakeTimer)
        XCTAssertFalse((vc?.mPlayerView.isAlive)!)
    }
}

class AlwaysCollisionTester:CollisionTester {
    func testOverGap(playerView: PlayerView, circleView: CircleView) -> Bool {
        return true
    }
}

class NeverCollisionTester:CollisionTester {
    func testOverGap(playerView: PlayerView, circleView: CircleView) -> Bool {
        return false
    }
}
