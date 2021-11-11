//
//  RemoteConfigStore.swift
//  App
//
//  Created by tyler on 2021/11/11.
//

import Foundation
import FirebaseRemoteConfig

final class RemoteConfigStore {
    private enum Keys: String {
        case contactEmail
    }

    static let shared = RemoteConfigStore()
    
    private init() { }

    private let remoteConfig: RemoteConfig = {
        let config = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        // Create a Remote Config Setting to enable developer mode, which you can use to increase
        // the number of fetches available per hour during development. See Best Practices in the
        // README for more information.
        // [START enable_dev_mode]
        config.configSettings = settings
        config.setDefaults(fromPlist: "RemoteConfigDefaults")
        return config
    }()

    var contactEmail: String {
        return self.remoteConfig[Keys.contactEmail.rawValue].stringValue ?? ""
    }
}

extension RemoteConfigStore {
    func fetch() {
        let expirationDuration = 3600
        // [START fetch_config_with_callback]
        // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
        // data fetched from the Remote Config service, rather than cached parameter values, if cached
        // parameter values are more than expirationDuration seconds old. See Best Practices in the
        // README for more information.
        self.remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { [weak self] status, error in
            guard let self = self else { return }
            if status == .success {
                logger.debug("Config fetched!")
                self.remoteConfig.activate { isSucces, error in
                    if let error = error {
                        logger.error("Activate Error: \(error.localizedDescription)")
                    }
                }
            } else {
                logger.error("Config not fetched")
                logger.error("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}
