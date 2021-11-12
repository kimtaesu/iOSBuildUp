//
//  UIGesture+Rx.swift
//  App
//
//  Created by tyler on 2021/11/12.
//

import RxGesture
import RxCocoa
import RxSwift

public extension Reactive where Base: UIView {
    func tapGestureEnded() -> Observable<UITapGestureRecognizer> {
        self
            .tapGesture(configuration: { gesture, delegate in
                delegate.simultaneousRecognitionPolicy = .never
            })
            .when(.recognized)
    }
}
