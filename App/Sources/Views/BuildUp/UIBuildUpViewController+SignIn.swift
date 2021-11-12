//
//  UIBuildUpViewController+SignIn.swift
//  App
//
//  Created by tyler on 2021/11/11.
//

import GoogleSignIn
import Firebase
import UIKit

extension UIBuildUpViewController {
    
    public func showSignProviderDropDown(
        anchorView: UIView,
        dataSources: [AuthProvider],
        didSelected: @escaping (AuthProvider?) -> Void
    ) {
        self.setUpSignInDropDownApprearance()

        self.dropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        self.dropDown.customCellConfiguration = { index, item, cell -> Void in
            guard let cell = cell as? MyCell else { return }
            cell.logoImageView.image = AuthProvider.create(title: item)?.icon
        }
        
        self.dropDown.dataSource = dataSources.map { $0.title }
        self.dropDown.anchorView = anchorView
        self.dropDown.bottomOffset = .init(x: 0, y: anchorView.height)
        self.dropDown.show()
        self.dropDown.selectionAction = { index, item in
            let selected = AuthProvider.create(title: item)
            didSelected(selected)
            logger.debug("did selected: \(String(describing: selected))")
        }
    }
    
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
    
    public func performGoogleAccountLink() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

            guard error == nil else { return self.displaySignInError(error) }

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
            self.reactor?.action.onNext(.signIn(credential))
      }
    }
}
