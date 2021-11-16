//
//  UIBuildUpViewController+SignIn.swift
//  App
//
//  Created by tyler on 2021/11/11.
//

import GoogleSignIn
import Firebase
import UIKit


extension MainViewContoller {
    public func displaySignInError(_ error: Error?, from function: StaticString = #function) {
        guard let error = error else { return }
        print("ⓧ Error in \(function): \(error.localizedDescription)")
        let message = "\(error.localizedDescription)\n\n Ocurred in \(function)"
        let errorAlertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        errorAlertController.addAction(UIAlertAction(title: "확인", style: .default))
        present(errorAlertController, animated: true, completion: nil)
    }
    
    public func performGoogleAccountLink(authSignin: @escaping (AuthCredential) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            if let error = error {
                let errorCode = (error as NSError).code
                if errorCode == GIDSignInErrorCode.cancel.rawValue {
                    return
                }
                return self.displaySignInError(error)
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
                else {
                    let error = NSError(
                        domain: "GIDSignInError",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Unexpected sign in result: required authentication data is missing.",
                        ]
                    )
                    return self.displaySignInError(error)
                }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: authentication.accessToken)
            authSignin(credential)
      }
    }
}
