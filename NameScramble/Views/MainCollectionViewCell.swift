//
//  MainCollectionViewCell.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/9/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var groupTypeLabel: UILabel!
    
    var groupType: GroupType? {
        didSet {
            self.updateView()
        }
    }
    
    func updateView() {
        guard let groupType = self.groupType else { return }
        groupTypeLabel.text = groupType.name
    }
    
}
