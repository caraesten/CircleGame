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
    
    static func easeOut(timePercent: Double) -> Double {
        // iOS, unlike Android, doesn't provide a method to use its animation
        // interpolators outside of the animations themselves; this is an
        // estimation of an ease-out function I found on github, here:
        // 
        // https://gist.github.com/gre/1650294
        //
        // There are also several solid libraries that attempt a similar thing
        // but in the interest of minimizing dependencies for this project,
        // I didn't want to include any of them. If this were a real app,
        // I'd probably just use that.

        return timePercent < 0.5 ? 2 * timePercent * timePercent : -1 + (4 - 2 * timePercent) * timePercent
    }
}
