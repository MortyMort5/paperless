//
//  GroupController.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/9/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import Foundation
import CloudKit
import GameplayKit

class GroupController {
    
    static let shared = GroupController()
    var cloudKitManager = CloudKitManager()
    var group: Group?
    var users: [User] = []
    
    func createGroup(name: String, completion: @escaping() -> Void) {
        let codeGenerated = self.randomCodeGenerator()
        let group = Group(codeGenerator: codeGenerated)
        let record = CKRecord(group: group)
        cloudKitManager.saveRecord(record) { (savedRecord, error) in
            if let error = error {
                print("Error with saving GROUP to cloudkit. Error \(error.localizedDescription)")
                completion()
                return
            }
            print("Group Record Save SUCCESSFULLY")
            guard let savedRecord = savedRecord else { completion(); return }
            let groupRecordID = savedRecord.recordID
            let groupRef = CKReference(recordID: groupRecordID, action: .none)
            UserController.shared.loggedInUser?.groupRef = groupRef
            let newGroup = Group(record: savedRecord)
            guard let group = newGroup else { completion(); return }
            self.group = group
            
            guard let user = UserController.shared.loggedInUser else { completion(); return }
            let userRecord = CKRecord(user: user)
            let operation = CKModifyRecordsOperation(recordsToSave: [userRecord], recordIDsToDelete: nil)
            operation.completionBlock = {
                completion()
            }
            operation.savePolicy = .changedKeys
            self.cloudKitManager.publicDatabase.add(operation)
            completion()
        }
    }
    
    func addUserToGroup(withCode codeGenerated: String, completion: @escaping() -> Void) {
        let predicate = NSPredicate(format: "\(Constants.codeGeneratorKey) == %@", codeGenerated)
        cloudKitManager.fetchRecordsWithType(Constants.group, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            if let error = error {
                print("Error with adding user to group with codeGenerated: \(error.localizedDescription)")
                completion()
                return
            }
            guard let recordID = records?.first?.recordID, let records = records else { completion(); return }
            let group = records.flatMap({ Group(record: $0) })
            self.group = group.first
            let groupRef = CKReference(recordID: recordID, action: .none)
            UserController.shared.loggedInUser?.groupRef = groupRef
            guard let user = UserController.shared.loggedInUser else { completion(); return }
            let userRecord = CKRecord(user: user)
            let operation = CKModifyRecordsOperation(recordsToSave: [userRecord], recordIDsToDelete: nil)
            operation.completionBlock = {
                completion()
            }
            operation.savePolicy = .changedKeys
            self.cloudKitManager.publicDatabase.add(operation)
            completion()
        }
    }
    
    func fetchUsersWithGroup(group: Group, completion: @escaping([User]) -> Void) {
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
            self.group?.users = users
            completion(users)
        }
    }
    
    func fetchUsersWithGroupRef(groupRef: CKReference, completion: @escaping([User]) -> Void) {
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
            self.group?.users = users
            self.users = users
            completion(users)
        }
    }
    
    func randomCodeGenerator() -> String {
        let length = 8
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    func scrambleUsers() -> [User] {
        guard let scrambledUsers: [User] = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self.users) as? [User] else { return [] }
        var newArr: [User] = []
        for user in self.users {
            for scrambledUser in scrambledUsers {
                user.randomFriendSelected = "\(scrambledUser.firstName)\(scrambledUser.lastName)"
                newArr.append(user)
            }
        }
        return newArr
    }
}
