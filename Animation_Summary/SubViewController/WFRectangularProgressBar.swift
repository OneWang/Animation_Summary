//
//  WFRectangularProgressBar.swift
//  Animation_Summary
//
//  Created by wangqingfei on 2024/3/22.
//  Copyright © 2024 Jack. All rights reserved.
//

import Foundation
import UIKit

class WFRectangularProgressBar: UIView {
    @objc public var progress: CGFloat {
        get { (layer as! CAShapeLayer).strokeEnd }
        set { (layer as! CAShapeLayer).strokeEnd = newValue }
    }
    var cornerRadius: CGFloat { 20 }
    var lineWidth: CGFloat { 6 }
    override class var layerClass: AnyClass { CAShapeLayer.self }
    override func layoutSubviews() {
        super.layoutSubviews()
        let layer = layer as! CAShapeLayer
        layer.lineCap = .round
        layer.lineWidth = lineWidth
        layer.fillColor = nil
        layer.strokeColor = UIColor.gray.cgColor
        let rect = layer.bounds.insetBy(dx: 0.5 * lineWidth, dy: 0.5 * lineWidth)
        let (x0, y0, x1, y1) = (rect.minX, rect.minY, rect.maxX, rect.maxY)
        let r = cornerRadius
        let path = CGMutablePath()
        // No prior move, so path automatically moves to the start of this arc.
        path.addRelativeArc(
            center: CGPoint(x: x0 + r, y: y0 + r),
            radius: r,
            startAngle: 0.625 * 2 * .pi, // 45° above -x axis
            delta: 0.125 * 2 * .pi // 45°
        )
        var current = CGPoint(x: x1, y: y0)
        for next in [
            CGPoint(x: x1, y: y1),
            CGPoint(x: x0, y: y1),
            CGPoint(x: x0, y: y0)
        ] {
            path.addArc(tangent1End: current, tangent2End: next, radius: r)
            current = next
        }
        path.addRelativeArc(
            center: CGPoint(x: x0 + r, y: y0 + r),
            radius: r,
            startAngle: 0.5 * 2 * .pi, // -x axis
            delta: 0.125 * 2 * .pi // 45°
        )
        path.closeSubpath()
        layer.path = path
    }
}
