//
//  Side.swift
//  demoo
//
//  Created by User on 08/12/25.
//

import Foundation
//import UIKit

public enum Side {
    case off
    case leg

    public var angle: CGFloat {
        switch self {
        case .off: return 0
        case .leg: return 180
        }
    }

    public func displayName() -> String {
        switch self {
        case .off: return "OFF"
        case .leg: return "LEG"
        }
    }
}
