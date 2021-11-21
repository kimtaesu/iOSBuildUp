//
//  Bundle+AppInfo.swift
//  App
//
//  Created by tyler on 2021/11/19.
//

import Foundation

import Foundation
 
public extension Bundle {
    class var appName: String {
        if let value = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return value
        }
        return ""
    }
    class var appVersion: String {
        if let value = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return value
        }
        return ""
    }
    class var appBuildVersion: String {
        if let value = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return value
        }
        return ""
    }

    class var bundleIdentifier: String {
        if let value = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            return value
        }
        return ""
    }
}
