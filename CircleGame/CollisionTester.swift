//
//  CollisionTester.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/6/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import Foundation

class CollisionTesterImpl: CollisionTester {
    // Player's always on the top (3/2 * pi, clockwise)
    private static let PLAYER_ANGLE = 1.5 * Double.pi

    func testOverGap(playerView: PlayerView, circleView: CircleView) -> Bool {
        if playerView.isAlive, let gaps = circleView.gaps {
            for gap in gaps {
                let gapStart = Utils.limitAngle(gap.0 + circleView.currentAngle)
                let gapEnd = Utils.limitAngle(gap.1 + circleView.currentAngle)
                let matchedGap = CollisionTesterImpl.PLAYER_ANGLE >= gapStart && CollisionTesterImpl.PLAYER_ANGLE <= gapEnd
                if matchedGap == true { return true }
            }
        }
        return false
    }
}

protocol CollisionTester {
    func testOverGap(playerView: PlayerView, circleView: CircleView) -> Bool
}
