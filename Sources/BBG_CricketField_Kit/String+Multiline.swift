//
//  String+Multiline.swift
//  demoo
//
//  Created by User on 08/12/25.
//

import Foundation
//import UIKit

public extension String {
    func breakIntoLines(maxWidth: CGFloat, attributes: [NSAttributedString.Key : Any]) -> [String] {
        var words = self.split(separator: " ")
        var lines: [String] = []
        var currentLine = ""

        for word in words {
            let testLine = currentLine.isEmpty ? "\(word)" : "\(currentLine) \(word)"
            let testSize = (testLine as NSString).size(withAttributes: attributes)

            if testSize.width > maxWidth {
                lines.append(currentLine)
                currentLine = "\(word)"
            } else {
                currentLine = testLine
            }
        }
        if !currentLine.isEmpty { lines.append(currentLine) }
        return lines
    }
}
