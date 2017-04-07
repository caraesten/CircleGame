//
//  PlayerView.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/5/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import Foundation
import UIKit

class PlayerView:UIView {
    // public for tests
    static let JUMP_LENGTH = 25.0

    var color = UIColor.blue
    var animationDelegate:PlayerAnimationDelegate? = nil
    
    private(set) var isJumping = false
    private(set) var isAlive = true

    private static let JUMP_DISTANCE = 55
    
    private var mJumpTimer = 0.0
    private var mJumpLength = PlayerView.JUMP_LENGTH

    func jump() {
        if (isAlive && !isJumping) {
            isJumping = true
        }
    }
    
    func advanceFrame(timeDelta: Double) {
        if isJumping {
            let elapsedFrames = timeDelta / Double(GameSettings.FRAME_INTERVAL)
            mJumpTimer += elapsedFrames
            if (mJumpTimer >= mJumpLength) {
                isJumping = false
                transform = CGAffineTransform.identity
                mJumpTimer = 0
                animationDelegate?.onJumpAnimationComplete()
            } else {
                let progressPercent = mJumpTimer / mJumpLength
                let distanceFromMidpoint = 1 - abs(0.5 - progressPercent) / 0.5
                let interpolatedPercent = Utils.easeOut(timePercent: distanceFromMidpoint)
                transform = CGAffineTransform(translationX: 0, y: -CGFloat(Double(PlayerView.JUMP_DISTANCE) * interpolatedPercent))
            }
        }
    }
    
    func resetState() {
        mJumpLength = PlayerView.JUMP_LENGTH
        revive()
    }
    
    // 10% less jump
    func decrementJumpTime() {
        mJumpLength -= PlayerView.JUMP_LENGTH * 0.1
    }
    
    func kill() {
        isAlive = false
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.alpha = 0
            self.layer.removeAnimation(forKey: "fade")
            self.animationDelegate?.onDeathAnimationComplete()
        })
        let fallAnimation = CABasicAnimation(keyPath: "position")
        let jumpAnimation = layer.animation(forKey: "jump")
        if jumpAnimation != nil {
            fallAnimation.fromValue = NSValue(cgPoint: CGPoint(x:center.x, y:(layer.presentation()?.position.y)!))
        }
        fallAnimation.toValue = NSValue(cgPoint: CGPoint(x:center.x, y:center.y + 65))
        fallAnimation.duration = 0.2
        fallAnimation.isRemovedOnCompletion = true
        layer.add(fallAnimation, forKey: "fall")
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.toValue = 0
        fadeAnimation.duration = 0.2
        fadeAnimation.isRemovedOnCompletion = false
        fadeAnimation.fillMode = kCAFillModeForwards
        layer.add(fadeAnimation, forKey: "fade")
        CATransaction.commit()
    }
    
    func revive() {
        isAlive = true
        alpha = 1
    }
    
    override func draw(_ rect: CGRect) {
        let ctxOpt = UIGraphicsGetCurrentContext()
        if let ctx = ctxOpt {
            ctx.setFillColor(color.cgColor)
            ctx.fillEllipse(in: rect)
        }
    }
}

protocol PlayerAnimationDelegate {
    func onDeathAnimationComplete()
    func onJumpAnimationComplete()
}
