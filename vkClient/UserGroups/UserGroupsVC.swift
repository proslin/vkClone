//
//  UserGroupsVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 18.10.2022.
//

import UIKit

protocol SelectedGroupDelegate: AnyObject {
    func selectedGroup(selectedGroup: Group)
}

class UserGroupsVC: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBarCustom!
    @IBOutlet weak var tableView: UITableView!
    
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  generateGroups()
        getGroups()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UINib(nibName: String(describing: UserGroupCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserGroupCell.self))
        self.tableView.dataSource = self
        setNavigationBar()
    }
    
    private func getGroups() {
        NetworkManager.shared.getGroups { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let groups):
                self.groups = groups
                DispatchQueue.main.async { self.tableView.reloadData() }
                
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
//    private func generateGroups() {
//        let group1 = Group(groupName: "Group1", groupAvatarURL: "group1", memberCount: 3)
//        let group2 = Group(groupName: "Group2", groupAvatarURL: "sky", memberCount: 5)
//
//        groups.append(group1)
//        groups.append(group2)
//
//        tableView.reloadData()
//    }
    
    private func setNavigationBar() {
        navigationBar.setTitle(title: "Группы пользователя")
        navigationBar.showRightButton()
        navigationBar.setRighButtonImage(imagename: "plus")
        navigationBar.setRightButtonAction {
            let allGroupVC = self.storyboard?.instantiateViewController(withIdentifier: "allGroupsVCKey") as! AllGroupsVC
           allGroupVC.delegate = self
            self.show(allGroupVC, sender: nil)
        }
    }

    @IBAction func addGroupTapped(_ sender: Any) {
        let allGroupVC = storyboard?.instantiateViewController(withIdentifier: "allGroupsVCKey") as! AllGroupsVC
       // allGroupVC.delegate = self
        self.show(allGroupVC, sender: nil)
    }
}

// MARK: - Table view data source
extension UserGroupsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserGroupCell.self)) as! UserGroupCell
                let group = groups[indexPath.row]
        cell.set(group: group)
                return cell
    }
}

// MARK: - Table view delegate
extension UserGroupsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension UserGroupsVC: SelectedGroupDelegate {
    func selectedGroup(selectedGroup: Group) {
         if !groups.contains(selectedGroup) {
         groups.append(selectedGroup)
         tableView.reloadData()
        }
    }
    
    
}
