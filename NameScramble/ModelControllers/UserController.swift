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
    var friends: [User] = []
    
    func saveUser(firstName: String, lastName: String, completion: @escaping(User?) -> Void) {
        guard let recordID = appleUserRecordID else { completion(nil); return }
        let userRef = CKReference(recordID: recordID, action: .none)
        let uuid = GroupController.shared.randomCodeGenerator()
        let user = User(firstName: firstName, lastName: lastName, appleUserRef: userRef, uuid: uuid, randomFriendSelected: "")
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
            print("Successfully Modified User")
            completion()
        }
        operation.savePolicy = .changedKeys
        self.cloudKitManager.publicDatabase.add(operation)
    }
    
    func leaveGroup(completion: @escaping() -> Void) {
        guard let user = self.loggedInUser else { return }
        user.groupRef = nil
        let record = CKRecord(user: user)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.completionBlock = {
            print("Successfully left Group")
            completion()
        }
        operation.savePolicy = .changedKeys
        self.cloudKitManager.publicDatabase.add(operation)
    }
    
    func fetchFriendsForUser(completion: @escaping([User]) -> Void) {
        guard let user = self.loggedInUser, let friendsRefs = user.friends else { completion([]); return }
        let predicate = NSPredicate(format: "recordID IN %@", friendsRefs)
        guard friendsRefs.count != 0 else { completion([]); return }
        cloudKitManager.fetchRecordsWithType(Constants.user, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            if let error = error { print(error.localizedDescription); completion([])}
            guard let records = records else { completion([]); return }
            let users = records.flatMap { User(record: $0) }
            let sortedUsers = users.sorted(by: {$0.firstName.lowercased() < $1.firstName.lowercased()})
            self.friends = sortedUsers
            print("Successfully fetched Friends for user")
            completion(sortedUsers)
        }
    }
    
    func addFriendsToUser(users: [User], completion: @escaping() -> Void) {
        let usersRefs = users.flatMap({ CKReference(recordID: $0.recordID!, action: .none) })
        guard let user = self.loggedInUser else { return }
        for ref in usersRefs {
            user.friends?.append(ref)
        }
        let record = CKRecord(user: user)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.completionBlock = {
            print("Succssefully added friends to User")
            completion()
        }
        operation.savePolicy = .changedKeys
        self.cloudKitManager.publicDatabase.add(operation)
    }
}
