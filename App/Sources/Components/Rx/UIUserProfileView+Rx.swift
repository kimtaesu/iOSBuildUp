//
//  UIUserProfileView+Rx.swift
//  App
//
//  Created by tyler on 2021/11/13.
//

import RxSwift

extension Reactive where Base: UIUserProfileView {
    var providerImage: Binder<UIImage?> {
        return Binder(self.base) { view, image in
            view.providerImage = image
        }
    }
}
