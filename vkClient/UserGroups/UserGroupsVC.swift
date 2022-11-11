//
//  UserGroupsVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 18.10.2022.
//

import UIKit
import RealmSwift

protocol SelectedGroupDelegate: AnyObject {
    func selectedGroup(selectedGroup: Group)
}

class UserGroupsVC: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBarCustom!
    @IBOutlet weak var tableView: UITableView!
    
//    var groups: [Group] = []
    var groups: Results<Group>?
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroups()
        pairTableAndRealm()
        tableView.register(UINib(nibName: String(describing: UserGroupCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserGroupCell.self))
        self.tableView.dataSource = self
        setNavigationBar()
    }
    
    private func getGroups() {
        showSpinner()
        NetworkService.shared.getGroups { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.removeSpinner()
            }
            switch result {
                
            case .success(let groups):
               // self.groups = groups
                
                //сохранили в базe
                    DispatchQueue.main.async {
                    RealmService.shared.saveGroups(groups)
                    //self.groups = RealmService.shared.loadDataGroups()
                }
                DispatchQueue.main.async { self.tableView.reloadData() }
                
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        groups = realm.objects(Group.self)
        token = groups?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0,   section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error): fatalError("\(error)")
            }
        }
    }
    
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

//    @IBAction func addGroupTapped(_ sender: Any) {
//        let allGroupVC = storyboard?.instantiateViewController(withIdentifier: "allGroupsVCKey") as! AllGroupsVC
//       // allGroupVC.delegate = self
//        self.show(allGroupVC, sender: nil)
//    }
}

// MARK: - Table view data source
extension UserGroupsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserGroupCell.self)) as! UserGroupCell
        guard let groups = groups else { return cell }
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
        guard let groups = groups else { return }
        let group = groups[indexPath.row]
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(group)
                try realm.commitWrite()
            } catch  {
                print(error)
            }
        }
    }
}

// MARK: - SelectedGroupDelegate
extension UserGroupsVC: SelectedGroupDelegate {
    func selectedGroup(selectedGroup: Group) {
//         if !groups.contains(selectedGroup) {
//         groups.append(selectedGroup)
//         tableView.reloadData()
//        }
    }
    
    
}
