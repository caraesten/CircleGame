//
//  Utils.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/6/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import Foundation

class Utils {
    static func limitAngle(_ angle: Double) -> Double {
        return angle >= Double(2) * Double.pi ? angle - Double(2) * Double.pi : angle
    }
    
    static func toRadians(degrees:Double) -> Double {
        return Measurement(value: degrees, unit: UnitAngle.degrees).converted(to: .radians).value
    }
}
