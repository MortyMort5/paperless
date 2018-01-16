//
//  UserController.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/9/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    static let shared = UserController()
    var appleUserRecordID: CKRecordID?
    var cloudKitManager = CloudKitManager()
    var loggedInUser: User?
    var users: [User] = []
    
    func saveUser(firstName: String, lastName: String, completion: @escaping(User?) -> Void) {
        guard let recordID = appleUserRecordID else { completion(nil); return }
        let userRef = CKReference(recordID: recordID, action: .none)
        let uuid = GroupController.shared.randomCodeGenerator()
        let user = User(firstName: firstName, lastName: lastName, appleUserRef: userRef, uuid: uuid)
        let record = CKRecord(user: user)
        cloudKitManager.saveRecord(record) { (savedRecord, error) in
            if let error = error {
                print("Error saving USER to cloudkit. Error \(error.localizedDescription)")
                completion(nil)
                return
            }
            print("User Record Save SUCCESSFULLY")
            guard let savedRecord = savedRecord else { completion(nil); return }
            let user = User(record: savedRecord)
            self.loggedInUser = user
            completion(user)
        }
    }
    
    func modifyUser(user: User, completion: @escaping() -> Void) {
        let record = CKRecord(user: user)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.completionBlock = {
            completion()
        }
        operation.savePolicy = .changedKeys
        self.cloudKitManager.publicDatabase.add(operation)
    }
    
    func fetchUsersWithGroupRef(group: Group, completion: @escaping([User]) -> Void) {
        guard let groupRecordID = group.recordID else { completion([]); return }
        let groupRef = CKReference(recordID: groupRecordID, action: .none)
        let predicate = NSPredicate(format: "\(Constants.groupRefKey) == %@", groupRef)
        let query = CKQuery(recordType: Constants.user, predicate: predicate)
        cloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error with fetching users for this group: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let records = records else { completion([]);  return }
            let users = records.flatMap({ User(record: $0) })
            print("Successfully fetched users")
            self.users = users
            completion(users)
        }
    }
}
