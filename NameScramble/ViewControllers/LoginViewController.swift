//
//  LoginViewController.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/9/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import UIKit
import CloudKit

class LoginViewController: UIViewController {

    var cloudKitManager = CloudKitManager()
    var user: User?
    
        // MARK: - IBOutlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
 
        // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // MARK: - Fetch current user and if there is USER segue to next View
        cloudKitManager.fetchCurrentUser { (user) in
            DispatchQueue.main.async {
                self.user = user
                UserController.shared.loggedInUser = user
                if let _ = user {
                    self.performSegue(withIdentifier: Constants.loginViewToMainViewSegue, sender: nil)
                }
            }
        }
    }

        // MARK: - IBActions
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, !firstName.isEmpty, !lastName.isEmpty else { return }
        UserController.shared.saveUser(firstName: firstName, lastName: lastName) { (user) in
            if let _ = user {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: Constants.loginViewToMainViewSegue, sender: nil)
                }
            } else {
                print("Error Saving User to cloudkit. No User = nil")
            }
        }
    }
}
