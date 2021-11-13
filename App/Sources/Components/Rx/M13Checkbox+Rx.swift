//
//  CheckBox+Rx.swift
//  App
//
//  Created by tyler on 2021/11/12.
//

import RxSwift
import M13Checkbox

extension Reactive where Base: M13Checkbox {
    public func isChecked(animation: Bool = false) -> Binder<Bool> {
        return Binder(self.base) { checkbox, isChecked in
            let checkState: M13Checkbox.CheckState = isChecked ? .checked : .unchecked
            checkbox.setCheckState(checkState, animated: animation)
        }
    }
}
