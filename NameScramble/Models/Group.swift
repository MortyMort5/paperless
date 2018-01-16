//
//  Group.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/9/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import CloudKit

class Group {
    let codeGenerator: String
    var recordID: CKRecordID?
    var users: [User]
    
    init(codeGenerator: String, users: [User] = []) {
        self.codeGenerator = codeGenerator
        self.users = users
    }
    
    init?(record: CKRecord) {
        guard let codeGenerator = record[Constants.codeGeneratorKey] as? String else { return nil }
        self.codeGenerator = codeGenerator
        self.recordID = record.recordID
        self.users = []
    }
}

extension CKRecord {
    convenience init(group: Group) {
        let recordID = group.recordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: Constants.group, recordID: recordID)
        self.setValue(group.codeGenerator, forKey: Constants.codeGeneratorKey)
    }
}
