//
//  MainViewController.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/9/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
        // MARK: - Properties
    var groupTypes: [GroupType] = []
    let backgroundView = UIView()
    var selectedGroupType: GroupType?
    var selectedIndexPath: IndexPath?
    
        // MARK: - IBOutlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var groupInfoLabel: UILabel!
    @IBOutlet weak var groupTitleLabel: UILabel!
    
    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setUpGroupTypes()
    }
    
    
    
    func setUpGroupTypes() {
        let nameScrabler = GroupType(name: "Name Scrambler", description: "Everyone's names will be scrambled and one name will appear on each users device.")
        let selectSingleName = GroupType(name: "Single Name Selection", description: "Will select one user in the group.")
        let groupNames = GroupType(name: "Divide into Teams", description: "Select the number of teams you want and this card will group all the users into random teams.")
        let other = GroupType(name: "Still Thinking Of More", description: "Shit I don't know what to put.")
        self.groupTypes.append(nameScrabler)
        self.groupTypes.append(selectSingleName)
        self.groupTypes.append(groupNames)
        self.groupTypes.append(other)
    }
    
        // MARK: - IBActions
    @IBAction func joinGroupButtonTapped(_ sender: Any) {
        /*
         Segues to a view where the user can enter group code.
         */
    }
    
    @IBAction func scrambleButtonTapped(_ sender: Any) {
        GroupController.shared.scrambleUsersAndSyncWithCloud {
            print("Scrambled and saved")
        }
    }
    
    @IBAction func userSelectedGroupButtonTapped(_ sender: Any) {
        /*
         Creating a group
         Segue to a new view with your name in a tableView along with the group code to join
         */
        
        GroupController.shared.createGroup(name: "New Group") {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.mainViewToGroupUserViewSegue, sender: nil)
            }
        }
    }
    
        // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.mainViewToGroupUserViewSegue {
            guard let vc = segue.destination as? GroupUserListViewController else { return }
            
        }
    }

        // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.groupTypeCollectionViewCellIdentifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.groupType = groupTypes[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedGroupType = groupTypes[indexPath.row]
        updateCardView()
    }
    
        // MARK: - Helper Functions
    func updateCardView() {
        /*
         - Adds backgroundView to subView and adds a tap gesture to that view so when the backgroundView
         is tapped the action is triggered.
         - Brings cardView to the front of superView.
         */
        groupTitleLabel.text = selectedGroupType?.name
        groupInfoLabel.text = selectedGroupType?.description
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundView)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissSubViews))
        backgroundView.addGestureRecognizer(tap)
        self.view.bringSubview(toFront: cardView)
        
    }
    
    @objc func dismissSubViews() {
        self.view.sendSubview(toBack: cardView)
        self.backgroundView.removeFromSuperview()
    }
}



