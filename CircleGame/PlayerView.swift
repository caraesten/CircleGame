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
    var color = UIColor.blue
    var animationDelegate:PlayerAnimationDelegate? = nil

    private(set) var isAlive = true

    private static let JUMP_LENGTH = 25
    
    public var isJumping: Bool {
        get {
            let animation = layer.animation(forKey: "jump")
            if animation != nil {
                return true
            }
            return false
        }
    }
    private var mJumpTimer = 0

    func jump() {
        if (isAlive) {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.animationDelegate?.onJumpAnimationComplete()
            })
            let animation = CABasicAnimation(keyPath: "position")
            animation.autoreverses = true
            animation.repeatCount = 1
            animation.toValue = NSValue(cgPoint: CGPoint(x:center.x, y:center.y - 55))
            animation.duration = Double(PlayerView.JUMP_LENGTH) / Double(GameSettings.FPS) / 2
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            layer.add(animation, forKey: "jump")
            CATransaction.commit()
        }
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
