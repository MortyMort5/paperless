//
//  User.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/9/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import CloudKit

class User {
    let firstName: String
    let lastName: String
    let uuid: String
    var recordID: CKRecordID?
    let appleUserRef: CKReference
    var groupRef: CKReference?
    var friends: [CKReference]?
    
    init(firstName: String, lastName: String, appleUserRef: CKReference, uuid: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.appleUserRef = appleUserRef
        self.uuid = uuid
    }
    
    init?(record: CKRecord) {
        guard let firstName = record[Constants.firstNameKey] as? String,
            let lastName = record[Constants.lastNameKey] as? String,
            let appleUserRef = record[Constants.appleUserRefKey] as? CKReference,
            let uuid = record[Constants.uuidKey] as? String else { return nil }
        self.firstName = firstName
        self.lastName = lastName
        self.groupRef = record[Constants.groupRefKey] as? CKReference
        self.friends = record[Constants.friendsKey] as? [CKReference]
        self.recordID = record.recordID
        self.appleUserRef = appleUserRef
        self.uuid = uuid
    }
}

extension CKRecord {
    convenience init(user: User) {
        let recordID = user.recordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: Constants.user, recordID: recordID)
        self.setValue(user.firstName, forKey: Constants.firstNameKey)
        self.setValue(user.lastName, forKey: Constants.lastNameKey)
        self.setValue(user.groupRef, forKey: Constants.groupRefKey)
        self.setValue(user.appleUserRef, forKey: Constants.appleUserRefKey)
        self.setValue(user.uuid, forKey: Constants.uuidKey)
        self.setValue(user.friends, forKey: Constants.friendsKey)
    }
}
