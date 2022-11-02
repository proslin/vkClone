//
//  AllGroupsVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 26.10.2022.
//

import UIKit

class AllGroupsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: NavigationBarCustom!
    
    var allgroups: [Group] = []
    var delegate: SelectedGroupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateAllGroups()
        tableView.register(UINib(nibName: String(describing: AllGroupCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AllGroupCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        setNavigationBar()
        
    }
    
    private func generateAllGroups() {
//        let group1 = Group(groupName: "Group1", groupAvatarURL: "allgroup", memberCount: 5)
//        let group2 = Group(groupName: "Group2", groupAvatarURL: "group1", memberCount: 1)
//        let group3 = Group(groupName: "Group3", groupAvatarURL: "group2", memberCount: 7)
//        let group4 = Group(groupName: "Group4", groupAvatarURL: "allgroup", memberCount: 8)
//        let group5 = Group(groupName: "Group5", groupAvatarURL: "sky", memberCount: 40)
//        
//        allgroups.append(group1)
//        allgroups.append(group2)
//        allgroups.append(group3)
//        allgroups.append(group4)
//        allgroups.append(group5)
//        tableView.reloadData()
    }
    
    private func setNavigationBar() {
        navigationBar.setTitle(title: "Группы")
        navigationBar.showLeftButton()
        navigationBar.setLeftButtonAction {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension AllGroupsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allgroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AllGroupCell.self)) as! AllGroupCell
        let group = allgroups[indexPath.row]
        cell.set(group: group)
        return cell
    }
    
}

extension AllGroupsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGroup = allgroups[indexPath.row]
        delegate?.selectedGroup(selectedGroup: selectedGroup)
        self.navigationController?.popViewController(animated: true)
    }
}

