//
//  UIApplication+Open.swift
//  App
//
//  Created by tyler on 2021/11/11.
//

import Foundation
import UIKit

extension UIApplication {
    
    var keyWindow: UIWindow? {
        self.windows.filter { $0.isKeyWindow }.first
    }

    public func showCantOpenUrl(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style = .alert
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alertController.addAction(.init(title: "확인", style: .default))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
    }
}
