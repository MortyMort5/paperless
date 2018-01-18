//
//  StartUpViewController.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/17/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import UIKit

class StartUpViewController: UIViewController {

    var cloudKitManager = CloudKitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
    }

    func fetchCurrentUser() {
        // MARK: - Fetch current user and if there is USER segue to next View
        cloudKitManager.fetchCurrentUser { (user) in
            DispatchQueue.main.async {
                UserController.shared.loggedInUser = user
                if let newUser = user {
                    if let groupRef = newUser.groupRef {
                        GroupController.shared.fetchGroupWithGroupRef(groupRef: groupRef, completion: {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: Constants.startUpViewToGroupUserListViewSegue, sender: nil)
                            }
                        })
                    } else {
                        self.performSegue(withIdentifier: Constants.startUpViewToMainViewSegue, sender: nil)
                    }
                } else {
                    self.performSegue(withIdentifier: Constants.startUpViewToLoginViewSegue, sender: nil)
                }
            }
        }
    }
}
