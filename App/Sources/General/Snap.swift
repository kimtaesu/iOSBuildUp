//
//  Snap.swift
//  App
//
//  Created by tyler on 2021/11/09.
//
import UIKit

public func snap(_ x: CGFloat) -> CGFloat {
    let scale = UIScreen.main.scale
    return ceil(x * scale) / scale
}

public func snap(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: snap(point.x), y: snap(point.y))
}

public func snap(_ size: CGSize) -> CGSize {
    return CGSize(width: snap(size.width), height: snap(size.height))
}

public func snap(_ rect: CGRect) -> CGRect {
    return CGRect(origin: snap(rect.origin), size: snap(rect.size))
}
