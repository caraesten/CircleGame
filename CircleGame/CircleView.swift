//
//  CircleView.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/5/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class CircleView: UIView {
    public private(set) var gaps:[(Double, Double)]?
    public private(set) var currentAngle = 0.0

    private static let START_COLOR = UIColor.blue
    private static let END_COLOR = UIColor(red:248.0 / 255.0, green: 187.0 / 255.0, blue: 179.0 / 255.0, alpha: 1)
    private static let PADDING = CGFloat(4.0)
    private static let WIDTH = CGFloat(4.0)

    private var mNumberOfSegments = 2
    private var mRotationModifier = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gaps = getClipAngles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gaps = getClipAngles()
    }
    
    func getColorAtTop() -> UIColor {
        // This is an approximation (would be nice to sample the color on the screen under it, but that's overkill)
        var red1: CGFloat = 0;
        var green1: CGFloat = 0;
        var blue1: CGFloat = 0;
        var alpha1: CGFloat = 0;
        
        var red2: CGFloat = 0;
        var green2: CGFloat = 0;
        var blue2: CGFloat = 0;
        var alpha2: CGFloat = 0;
        
        CircleView.START_COLOR.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        
        CircleView.END_COLOR.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        let percent = abs(0.5 - (currentAngle / (2 * Double.pi))) / 0.5

        let r = red1 * CGFloat(percent) + red2 * CGFloat(1 - percent)
        let g = green1 * CGFloat(percent) + green2 * CGFloat(1 - percent)
        let b = blue1 * CGFloat(percent) + blue2 * CGFloat(1 - percent)

        let components = [r, g, b, CGFloat(1.0)]
        let cgColor = CGColor(colorSpace: CircleView.START_COLOR.cgColor.colorSpace!, components: components)
        let uiColor = UIColor(cgColor: cgColor!)
        return uiColor
    }
    
    func advanceFrame(timeDelta: Double) {
        let newAngle = currentAngle + 2.0 * Double.pi / (Double(GameSettings.FULL_CIRCLE_ROTATION_FRAMES) - mRotationModifier) * (timeDelta / GameSettings.FRAME_INTERVAL)
        transform = CGAffineTransform(rotationAngle: CGFloat(newAngle))
        currentAngle = Utils.limitAngle(newAngle)
    }
    
    func resetAngle() {
        currentAngle = 0.0
    }
    
    func incrementGaps() {
        mNumberOfSegments += 1
        gaps = getClipAngles()
        setNeedsDisplay()
    }
    
    func resetState() {
        resetRotation()
        resetGaps()
        resetAngle()
    }
    
    // 10 percent faster...
    func incrementRotation() {
        mRotationModifier += Double(GameSettings.FULL_CIRCLE_ROTATION_FRAMES) * 0.1
    }
    
    func resetRotation() {
        mRotationModifier = 0
    }
    
    func resetGaps() {
        mNumberOfSegments = 2
        gaps = getClipAngles()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let ctxOpt = UIGraphicsGetCurrentContext()
        if let ctx = ctxOpt {
            ctx.saveGState()
            ctx.setLineWidth(CircleView.WIDTH)
            let width = rect.width - CircleView.PADDING * 2
            ctx.addEllipse(in: CGRect(x: 0 + CircleView.PADDING, y:0 + CircleView.PADDING, width: width, height: rect.height - CircleView.PADDING * 2))
            ctx.replacePathWithStrokedPath()
            ctx.clip()
            
            let angles = getClipAngles()
            let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
            for (start, end) in angles {
                ctx.move(to: center)
                ctx.addArc(center: center, radius: width / 2, startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: true)
                ctx.replacePathWithStrokedPath()
                ctx.clip(using: .winding)
            }
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: ([CircleView.START_COLOR.cgColor, CircleView.END_COLOR.cgColor] as CFArray), locations: [0.0, 1.0])
            
            ctx.drawLinearGradient(gradient!, start: CGPoint(x: center.x, y: 0), end: CGPoint(x: center.x, y: rect.height), options: CGGradientDrawingOptions())
            ctx.restoreGState()
        }
    }
    
    private func getClipAngles() -> [(Double, Double)] {
        return (1...mNumberOfSegments).map { (x:Int) -> (Double, Double) in
            let segmentSize = ((2 * Double.pi) / Double(mNumberOfSegments))
            return (Utils.limitAngle(Double(x) * segmentSize), Utils.limitAngle(Double(x) * segmentSize + Utils.toRadians(degrees: GameSettings.GAP_SIZE)))
        }
    }
}
