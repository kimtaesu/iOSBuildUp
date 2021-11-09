//
//  UICollectionView+SectionSize.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import UIKit

public extension UICollectionView {
    func sectionWidth(at section: Int) -> CGFloat {
        var width = self.safeAreaLayoutGuide.layoutFrame.width
        width -= self.contentInset.left
        width -= self.contentInset.right

        if let delegate = self.delegate as? UICollectionViewDelegateFlowLayout,
            let inset = delegate.collectionView?(self, layout: self.collectionViewLayout, insetForSectionAt: section) {
            width -= inset.left
            width -= inset.right
        } else if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            width -= layout.sectionInset.left
            width -= layout.sectionInset.right
        }
        return width
    }

    func sectionHeight(at section: Int) -> CGFloat {
        var height = self.safeAreaLayoutGuide.layoutFrame.height
        height -= self.contentInset.top
        height -= self.contentInset.bottom

        if let delegate = self.delegate as? UICollectionViewDelegateFlowLayout,
            let inset = delegate.collectionView?(self, layout: self.collectionViewLayout, insetForSectionAt: section) {
            height -= inset.top
            height -= inset.bottom
        } else if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            height -= layout.sectionInset.top
            height -= layout.sectionInset.bottom
        }
        return height
    }

}
