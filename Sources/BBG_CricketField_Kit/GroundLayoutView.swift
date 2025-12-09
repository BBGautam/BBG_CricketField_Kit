//
//  GroundLayoutView.swift
//  BBG_CricketField_Kit
//
//  Created by You on YYYY/MM/DD
//

import UIKit

public final class GroundLayoutView: UIView {

    // MARK: - Public configuration
    public var groundRadius: CGFloat = 184
    public var pitchWidth: CGFloat = 25

    /// Callback when a position is selected (tap)
    public var onPositionSelect: ((FieldingPosition) -> Void)?

    // MARK: - Internal state
    private var positions: [FieldingPosition] = []
    private var endPoint: CGPoint?
    private let lineLayer = CAShapeLayer()

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        setupPositions()
        setupGesture()
        layer.addSublayer(lineLayer)
    }

    private func setupPositions() {
        // keep same order as original
        positions = [
            FieldingPosition(.deepMidWicket, startAngle: 0, endAngle: 45),
            FieldingPosition(.longOn, startAngle: 45, endAngle: 90),
            FieldingPosition(.longOff, startAngle: 90, endAngle: 135),
            FieldingPosition(.deepCover, startAngle: 135, endAngle: 180),
            FieldingPosition(.deepPoint, startAngle: 180, endAngle: 225),
            FieldingPosition(.thirdMan, startAngle: 225, endAngle: 270),
            FieldingPosition(.deepFineLeg, startAngle: 270, endAngle: 315),
            FieldingPosition(.deepSquareLeg, startAngle: 315, endAngle: 360)
        ]
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }

    // MARK: - Touch handling
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        // boundary radius (same as boundary circle drawn)
        let maxRadius = groundRadius - 10

        let dx = location.x - center.x
        let dy = location.y - center.y
        let distance = sqrt(dx*dx + dy*dy)

        // clamp the location to inside the boundary
        var clampedLocation = location
        if distance > maxRadius {
            let scale = maxRadius / distance
            clampedLocation = CGPoint(x: center.x + dx * scale,
                                      y: center.y + dy * scale)
        }

        // update endpoint and animate line
        endPoint = clampedLocation
        animateLine(to: clampedLocation)

        // calculate angle for selection (use original dx,dy to preserve angle)
        let angle = (atan2(dy, dx) * 180 / .pi + 360).truncatingRemainder(dividingBy: 360)

        if let selected = getSelectedPosition(angle: angle, distance: min(distance, maxRadius)) {
            onPositionSelect?(selected)
        }
    }

    // finds position by angle (keeps original logic)
    private func getSelectedPosition(angle: CGFloat, distance: CGFloat) -> FieldingPosition? {
        for position in positions {
            if angle >= position.startAngle && angle < position.endAngle {
                return position
            }
        }
        return nil
    }

    // MARK: - Line animation (straight)
    private func animateLine(to point: CGPoint) {
        let path = UIBezierPath()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        path.move(to: center)
        path.addLine(to: point)

        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.green.cgColor
        lineLayer.lineWidth = 3
        lineLayer.lineCap = .round
        lineLayer.fillColor = UIColor.clear.cgColor

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.3
        animation.fromValue = 0
        animation.toValue = 1
        lineLayer.removeAllAnimations()
        lineLayer.add(animation, forKey: "line")
    }

    // MARK: - Drawing
    public override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        drawGround(in: ctx, rect: rect)
    }

    private func drawGround(in ctx: CGContext, rect: CGRect) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        // Ground base
        let baseColor = UIColor(red: 82/255, green: 181/255, blue: 85/255, alpha: 1)
        ctx.setFillColor(baseColor.cgColor)
        ctx.fillEllipse(in: CGRect(x: center.x - groundRadius,
                                    y: center.y - groundRadius,
                                    width: groundRadius*2,
                                    height: groundRadius*2))

        // Boundary circle (white)
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(2)
        ctx.strokeEllipse(in: CGRect(x: center.x - groundRadius + 10,
                                     y: center.y - groundRadius + 10,
                                     width: (groundRadius - 10) * 2,
                                     height: (groundRadius - 10) * 2))

        // Inner pitch circle (greenish-yellow)
        let innerColor = UIColor(red: 150/255, green: 204/255, blue: 84/255, alpha: 1)
        ctx.setFillColor(innerColor.cgColor)
        ctx.addArc(center: center, radius: groundRadius/2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        ctx.fillPath()

        // 8 slice divider lines (inside boundary)
        let sliceRadius = groundRadius - 10
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(1)
        for i in 0..<8 {
            let angle = CGFloat(i) * (2 * .pi / 8)
            let end = CGPoint(x: center.x + sliceRadius * cos(angle),
                              y: center.y + sliceRadius * sin(angle))
            ctx.move(to: center)
            ctx.addLine(to: end)
            ctx.strokePath()
        }

        // OFF/LEG labels
        drawSideLabels(in: ctx, center: center)

        // Pitch rectangle + batter image
        drawPitch(in: ctx, center: center)

        // Fielding labels + dots
        drawFieldingPositions(in: ctx, center: center)
    }

    // MARK: - Sub drawing helpers
    private func drawSideLabels(in ctx: CGContext, center: CGPoint) {
        let sideFont = UIFont.systemFont(ofSize: 14)
        for side in [Side.off, Side.leg] {
            let angleRad = side.angle * .pi / 180

            var xx = (side == .off) ? 10.0 : -10.0
            let x = center.x + (groundRadius / 2) * cos(angleRad) + xx
            let y = center.y + (groundRadius / 2) * sin(angleRad) + 10

            let text = side.displayName()
            let attrText = NSAttributedString(string: text, attributes: [
                .font: sideFont,
                .foregroundColor: UIColor.white
            ])
            attrText.draw(at: CGPoint(x: x - attrText.size().width/2, y: y - attrText.size().height/2))
        }
    }

    private func drawPitch(in ctx: CGContext, center: CGPoint) {
        let pitchRect = CGRect(
            x: center.x - pitchWidth/2,
            y: center.y - groundRadius/6 + 20,
            width: pitchWidth,
            height: groundRadius/3
        )

        let pitchColor = UIColor(red: 255/255, green: 226/255, blue: 186/255, alpha: 1.0)
        ctx.setFillColor(pitchColor.cgColor)
        ctx.fill(pitchRect)
        ctx.setStrokeColor(pitchColor.cgColor)
        ctx.stroke(pitchRect)

        // Batter image (optional; uses asset name "batter")
        if let batterImage = UIImage(named: "batter") {
            let imageSize: CGFloat = 30
            let imageX = center.x - (imageSize / 2 - 2)
            let imageY = pitchRect.minY - (imageSize - 10)
            let imageRect = CGRect(x: imageX, y: imageY, width: imageSize, height: imageSize)
            batterImage.draw(in: imageRect)
        }
    }

    private func drawFieldingPositions(in ctx: CGContext, center: CGPoint) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white,
            .paragraphStyle: {
                let p = NSMutableParagraphStyle()
                p.alignment = .center
                p.lineBreakMode = .byWordWrapping
                return p
            }()
        ]

        for position in positions where position.showOnScreen {
            let angleRad = position.midAngle * .pi / 180
            let distance = groundRadius - 50

            let x = center.x + distance * cos(angleRad)
            let y = center.y + distance * sin(angleRad)

            // Dot
            ctx.setFillColor(UIColor.green.cgColor)
            ctx.fillEllipse(in: CGRect(x: x - 4, y: y - 4, width: 8, height: 8))

            // Text (wrapped)
            let text = position.type.displayName() as NSString
            let maxWidth: CGFloat = 60
            let size = text.boundingRect(with: CGSize(width: maxWidth, height: .infinity),
                                         options: [.usesLineFragmentOrigin, .usesFontLeading],
                                         attributes: attributes,
                                         context: nil).size

            text.draw(with: CGRect(x: x - size.width/2, y: y - size.height - 6, width: size.width, height: size.height),
                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                      attributes: attributes,
                      context: nil)
        }
    }
}
