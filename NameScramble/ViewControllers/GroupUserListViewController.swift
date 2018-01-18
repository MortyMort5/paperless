//
//  GroupUserListViewController.swift
//  NameScramble
//
//  Created by Sterling Mortensen on 1/10/18.
//  Copyright © 2018 Sterling Mortensen. All rights reserved.
//

import UIKit

class GroupUserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

        // MARK: - IBOutlets
    @IBOutlet weak var groupCodeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedFriendView: UIView!
    @IBOutlet weak var selectedFriendLabel: UILabel!
    let backgroundView = UIView()
    let cloudKitManager = CloudKitManager()
    
        // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateView()
        prepView()
    }
    
    @IBAction func scrambleNamesButtonTapped(_ sender: Any) {
        GroupController.shared.scrambleUsersAndSyncWithCloud {
            
        }
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupController.shared.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.groupUsersTableViewCellIdentifier, for: indexPath)
        let user = GroupController.shared.users[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func updateView() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUpdatedUsers), name: GroupController.shared.userUpdateNotificationName, object: nil)
        guard let group = GroupController.shared.group else { return }
        groupCodeLabel.text = group.codeGenerator
        GroupController.shared.fetchUsersWithGroup(group: group) { (users) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func prepView() {
        guard let group = GroupController.shared.group else { return }
        cloudKitManager.subscribeToUserUpdate(group: group)
    }
    
    @objc func fetchUpdatedUsers() {
        guard let user = UserController.shared.loggedInUser, let groupRef = user.groupRef else { return }
        GroupController.shared.fetchUsersWithGroupRef(groupRef: groupRef) { (users) in
            DispatchQueue.main.async {
                self.selectedFriendLabel.text = user.randomFriendSelected
                self.updateSelectedFriendView()
            }
        }
    }
    
    func updateSelectedFriendView() {
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundView)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissSubViews))
        backgroundView.addGestureRecognizer(tap)
        self.view.bringSubview(toFront: selectedFriendView) 
    }
    
    @objc func dismissSubViews() {
        self.view.sendSubview(toBack: selectedFriendView)
        self.backgroundView.removeFromSuperview()
    }
}
