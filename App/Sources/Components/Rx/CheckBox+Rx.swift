//
//  CheckBox+Rx.swift
//  App
//
//  Created by tyler on 2021/11/12.
//

import SimpleCheckbox
import RxSwift

extension Reactive where Base: Checkbox {
    public var isChecked: Binder<Bool> {
        return Binder(self.base) { checkbox, isChecked in
            checkbox.isChecked = isChecked
        }
    }
}
