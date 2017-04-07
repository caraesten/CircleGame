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
    
    func testDecrementJumpTime() {
        let playerView = PlayerView()
        playerView.jump()
        playerView.advanceFrame(timeDelta: GameSettings.FRAME_INTERVAL * (PlayerView.JUMP_LENGTH - PlayerView.JUMP_LENGTH * 0.1))
        XCTAssertTrue(playerView.isJumping)
        playerView.advanceFrame(timeDelta: GameSettings.FRAME_INTERVAL * PlayerView.JUMP_LENGTH)
        XCTAssertFalse(playerView.isJumping)
        playerView.decrementJumpTime()
        playerView.jump()
        playerView.advanceFrame(timeDelta: GameSettings.FRAME_INTERVAL * (PlayerView.JUMP_LENGTH - PlayerView.JUMP_LENGTH * 0.1))
        XCTAssertFalse(playerView.isJumping)
    }
    
    func testResetState() {
        let playerView = PlayerView()
        playerView.decrementJumpTime()
        playerView.jump()
        playerView.advanceFrame(timeDelta: GameSettings.FRAME_INTERVAL * (PlayerView.JUMP_LENGTH - PlayerView.JUMP_LENGTH * 0.1))
        XCTAssertFalse(playerView.isJumping)
        playerView.resetState()
        playerView.jump()
        playerView.advanceFrame(timeDelta: GameSettings.FRAME_INTERVAL * (PlayerView.JUMP_LENGTH - PlayerView.JUMP_LENGTH * 0.10))
        XCTAssertTrue(playerView.isJumping)
    }
    
    func testJump() {
        let playerView = PlayerView()
        let delegate = SpyAnimationDelegate()
        delegate.jumpExpectation = expectation(description: "Animation listener for jump called")
        
        playerView.animationDelegate = delegate
        playerView.jump()
        XCTAssert(playerView.isJumping == true)
        playerView.advanceFrame(timeDelta: GameSettings.FRAME_INTERVAL * PlayerView.JUMP_LENGTH)
        XCTAssert(playerView.isJumping == false)
        waitForExpectations(timeout: 1) { errorOpt in
            if errorOpt != nil {
                XCTFail("Wait for expectation timed out")
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testDoubleJump() {
        let playerView = PlayerView()
        playerView.jump()
        playerView.advanceFrame(timeDelta: GameSettings.FRAME_INTERVAL * PlayerView.JUMP_LENGTH / 2.0)
        XCTAssert(playerView.isJumping == true)
        playerView.jump()
        playerView.advanceFrame(timeDelta: GameSettings.FRAME_INTERVAL * PlayerView.JUMP_LENGTH / 2.0)
        XCTAssert(playerView.isJumping == false)
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
