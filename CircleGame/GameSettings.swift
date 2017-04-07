//
//  GameSettings.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/6/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import Foundation

class GameSettings {
    static let FPS = 60
    static let FRAME_INTERVAL = (Double(1) / Double(FPS))
    static let FULL_CIRCLE_ROTATION_FRAMES = 5 * FPS
    static let GAP_SIZE = 20.0 // degrees
}
