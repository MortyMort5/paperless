//
//  Constants.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/10/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import Foundation

struct Constants {
    // Cells
    static let groupTypeCollectionViewCellIdentifier = "groupTypeCell"
    static let groupUsersTableViewCellIdentifier = "userCell"
    
    // Segue
    static let loginViewToMainViewSegue = "toMainViewSegue"
    static let mainViewToGroupUserViewSegue = "toGroupUserSegue"
    static let enterCodeViewToGroupUserViewSegue = "codeToUserListSegue"
    
    // User
    static let user = "User"
    static let firstNameKey = "firstName"
    static let lastNameKey = "lastName"
    static let appleUserRefKey = "appleUserRef"
    static let uuidKey = "uuid"
    static let groupRefKey = "groupRef"
    static let friendsKey = "friends"
    
    // Group
    static let group = "Group"
    static let codeGeneratorKey = "codeGenerator"

    
}

