//
//  NumberFormatterUtils.swift
//  App
//
//  Created by tyler on 2021/11/12.
//

import Foundation

extension NumberFormatter {
    private static let _formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
    
    public static func toDecimal(_ value: Int) -> String? {
        Self._formatter.string(from: value as NSNumber)
    }
}
