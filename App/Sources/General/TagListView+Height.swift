//
//  TagListView+Height.swift
//  App
//
//  Created by tyler on 2021/11/18.
//

import TagListView
import CoreGraphics

extension TagListView {
    
    class func height(maxLine: Int = 2) -> CGFloat {
        let appearance = TagListView.appearance()
        let lineHegiht = appearance.marginY
            + snap(appearance.textFont.lineHeight)
        
        return lineHegiht * CGFloat(maxLine)
    }
}

