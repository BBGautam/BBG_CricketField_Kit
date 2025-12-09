//
//  CricketFieldView.swift
//  demoo
//
//  Created by User on 08/12/25.
//

import Foundation
import UIKit

public final class CricketFieldView: UIView {

    private let lineLayer = CAShapeLayer()
    private var selectedPoint: CGPoint?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(lineLayer)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.addSublayer(lineLayer)
        backgroundColor = .clear
    }

    public override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let groundRadius = min(rect.width, rect.height) * 0.45

        // ---- BASE CIRCLE ----
        ctx.setFillColor(UIColor.systemGreen.withAlphaComponent(0.9).cgColor)
        ctx.addArc(center: center, radius: groundRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        ctx.fillPath()

        // ---- INNER CIRCLE WITH GREEN-YELLOW TONE ----
        ctx.setFillColor(UIColor(red: 0.65, green: 0.85, blue: 0.30, alpha: 1).cgColor)
        ctx.addArc(center: center, radius: groundRadius/2, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        ctx.fillPath()

        // ---- RADIAL LINES ----
        for i in 0..<8 {
            let angle = CGFloat(i) * (.pi / 4)
            let endX = center.x + (groundRadius/2) * cos(angle)
            let endY = center.y + (groundRadius/2) * sin(angle)

            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.setLineWidth(2)
            ctx.move(to: center)
            ctx.addLine(to: CGPoint(x: endX, y: endY))
            ctx.strokePath()
        }

        drawLabels(center: center, radius: groundRadius)
    }

    private func drawLabels(center: CGPoint, radius: CGFloat) {
        for side in [Side.off, Side.leg] {
            let angleRad = side.angle * .pi / 180

            let offsetX: CGFloat = side == .off ? 10 : -10
            let offsetY: CGFloat = side == .off ? -10 : -10

            let x = center.x + (radius/2) * cos(angleRad) + offsetX
            let y = center.y + (radius/2) * sin(angleRad) + offsetY

            let text = side.displayName()
            let attrs: [NSAttributedString.Key : Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.white
            ]

            let size = (text as NSString).size(withAttributes: attrs)
            (text as NSString).draw(at: CGPoint(x: x - size.width/2, y: y - size.height/2), withAttributes: attrs)
        }
    }
}
