//
//  FieldingPosition.swift
//  demoo
//
//  Created by User on 08/12/25.
//

import Foundation
//import UIKit

public struct FieldingPosition {
    public let type: FieldingPositionType
    let startAngle: CGFloat
    let endAngle: CGFloat
    let distance: Distance
    let showOnScreen: Bool

    init(_ type: FieldingPositionType,
         startAngle: CGFloat,
         endAngle: CGFloat,
         distance: Distance = .boundary,
         showOnScreen: Bool = true) {

        self.type = type
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.distance = distance
        self.showOnScreen = showOnScreen
    }

    var midAngle: CGFloat {
        (startAngle + endAngle) / 2
    }
}

public enum FieldingPositionType: Int {
    case deepMidWicket = 1, longOn, longOff, deepCover, deepPoint, thirdMan, deepFineLeg, deepSquareLeg

    public func displayName() -> String {
        switch self {
        case .deepMidWicket: return "Deep mid wicket"
        case .longOn: return "Long on"
        case .longOff: return "Long off"
        case .deepCover: return "Deep cover"
        case .deepPoint: return "Deep point"
        case .thirdMan: return "Third man"
        case .deepFineLeg: return "Deep fine leg"
        case .deepSquareLeg: return "Deep square leg"
        }
    }
}
