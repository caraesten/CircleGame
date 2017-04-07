//
//  PlayerViewTests.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/6/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import XCTest

class PlayerViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testKill() {
        let playerView = PlayerView()
        let delegate = SpyAnimationDelegate()
        delegate.deathExpectation = expectation(description: "Animation listener for death called")

        playerView.animationDelegate = delegate
        playerView.kill()
        XCTAssert(playerView.isAlive == false)
        XCTAssert(playerView.layer.animation(forKey: "fall") != nil)
        XCTAssert(playerView.layer.animation(forKey: "fade") != nil)
        waitForExpectations(timeout: 1) { errorOpt in
            if errorOpt != nil {
                XCTFail("Wait for expectation timed out")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testJump() {
        let playerView = PlayerView()
        let delegate = SpyAnimationDelegate()
        delegate.jumpExpectation = expectation(description: "Animation listener for jump called")
        
        playerView.animationDelegate = delegate
        playerView.jump()
        XCTAssert(playerView.isJumping == true)
        XCTAssert(playerView.layer.animation(forKey: "jump") != nil)
        waitForExpectations(timeout: 1) { errorOpt in
            if errorOpt != nil {
                XCTFail("Wait for expectation timed out")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testRevive() {
        let playerView = PlayerView()
        playerView.kill()
        XCTAssert(playerView.isAlive == false)
        playerView.revive()
        XCTAssert(playerView.isAlive == true)
    }
}

class SpyAnimationDelegate: PlayerAnimationDelegate {
    var jumpExpectation: XCTestExpectation?
    var deathExpectation: XCTestExpectation?

    func onJumpAnimationComplete() {
        guard let expectation = jumpExpectation else {
            XCTFail("Delegate missing reference to XCTExpectation")
            return
        }
        expectation.fulfill()
    }
    
    func onDeathAnimationComplete() {
        guard let expectation = deathExpectation else {
            XCTFail("Delegate missing reference to XCTExpectation")
            return
        }
        expectation.fulfill()
    }
}
