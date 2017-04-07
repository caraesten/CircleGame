//
//  ViewController.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/5/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MainViewTouchDelegate, PlayerAnimationDelegate {
    // Expose views for test purposes only, otherwise VCs are REALLY hard to test
    @IBOutlet var mCircleView: CircleView!
    @IBOutlet var mPlayerView: PlayerView!
    @IBOutlet var mScoreLabel: UILabel!
    @IBOutlet var mResetButton: UIButton!
    @IBOutlet var mHighScoreLabel: UILabel!

    var mCollisionTester:CollisionTester = CollisionTesterImpl()
    
    private var mTimer:Timer? = nil
    
    private var mScore = 0
    private var mHighScore = 0
    private var mHasScoredJump = false
    private var mLastFrameTimestamp = NSDate.timeIntervalSinceReferenceDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mTimer = Timer.scheduledTimer(withTimeInterval: GameSettings.FRAME_INTERVAL, repeats: true, block: timerInvoke)
        (self.view as! MainView).delegate = self
        mPlayerView.animationDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetGame() {
        mScore = 0
        mLastFrameTimestamp = NSDate.timeIntervalSinceReferenceDate
        mScoreLabel.text = String(mScore)
        mPlayerView.resetState()
        mCircleView.resetState()
    }
    
    func timerInvoke(timer: Timer) {
        let now = NSDate.timeIntervalSinceReferenceDate
        let timeDelta = now - mLastFrameTimestamp
        mLastFrameTimestamp = now
        gameStep(timeDelta: timeDelta)
    }
    
    func gameStep(timeDelta: Double) {
        if mPlayerView.isAlive {
            mCircleView.advanceFrame(timeDelta: timeDelta)
            mPlayerView.advanceFrame(timeDelta: timeDelta)
            let topColor = mCircleView.getColorAtTop()
            if topColor.cgColor.alpha != 0 {
                mPlayerView.color = topColor
            }
            mPlayerView.setNeedsDisplay()
            let playerOverGap = mCollisionTester.testOverGap(playerView: mPlayerView, circleView: mCircleView)
            
            if (playerOverGap && !mPlayerView.isJumping) {
                mPlayerView.kill()
            } else if (playerOverGap && !mHasScoredJump) {
                mScore += 1
                mScoreLabel.text = String(mScore)
                mHasScoredJump = true
            }
        }
    }
    
    @IBAction func onResetPressed(_ sender: UIButton) {
        mResetButton.isHidden = true
        self.resetGame()
    }

    func onTouch() {
        mPlayerView.jump()
    }
    
    func onDeathAnimationComplete() {
        mResetButton.isHidden = false
        if (mScore > mHighScore) {
            mHighScore = mScore
            mHighScoreLabel.text = "High Score: \(mHighScore)"
        }
    }
    
    func onJumpAnimationComplete() {
        mHasScoredJump = false
        if (mScore != 0 && mScore % 4 == 0) {
            if (mCircleView.gaps?.count)! < 4 {
                mCircleView.incrementGaps()
            } else {
                mCircleView.incrementRotation()
                mPlayerView.decrementJumpTime()
            }
        }
    }
}
