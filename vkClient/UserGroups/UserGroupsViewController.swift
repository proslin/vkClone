//
//  UserGroupsVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 18.10.2022.
//

import UIKit
import RealmSwift

final class UserGroupsViewController: UIViewController {
    
    @IBOutlet private weak var navigationBarContainer: UIView!
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var groups: Results<GroupModel>?
    private var token: NotificationToken?
    private var allGroupVC: AllGroupsViewController?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupNavBar()
        switch UserSettings.entryCount - 1 {
        case 1:
            getGroups()
        case 2..<5:
            pairTableAndRealm()
        case 5:
            getGroups()
        default:
            getGroups()
        }
    }
    
    // MARK: - Private methods
    private func configureTableView() {
        tableView.register(UINib(nibName: String(describing: UserGroupCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserGroupCell.self))
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
    }
    
    private func setupNavBar() {
        let navBarButtonModel = NavBarButton(image: SFSymbols.plus, action: { [weak self] in
            guard let allGroupVC =  self?.storyboard?.instantiateViewController(withIdentifier: "allGroupsVCKey") as? AllGroupsViewController else { return }
            self?.allGroupVC = allGroupVC
            self?.allGroupVC?.delegate = self
            self?.show(allGroupVC, sender: nil)
        })
        let navBarModel = NavigationBarModel(title: "Группы", rightButton: navBarButtonModel)
        let _ = NavigationBarCustom.instanceFromNib(model: navBarModel, parentView: navigationBarContainer)
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
                DispatchQueue.main.async {
                    if let error = RealmService.shared.saveGroups(groups) {
                        self.presentAlertVC(title: "Ошибка записи в БД", message: error.localizedDescription)
                    } else {
                        self.refreshControl.endRefreshing()
                        self.pairTableAndRealm()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlertVC(title: "Ошибка", message: error.rawValue)
                }
            }
        }
    }
    
    private func deleteGroup(groupId: Int) {
        NetworkService.shared.deleteGroup(for: groupId) { result in
            switch result {
                
            case .success(let result):
                if result.response == 1 {
                    DispatchQueue.main.async {
                        if let error = RealmService.shared.deleteGroup(groupId: groupId) {
                            self.presentAlertVC(title: "Ошибка записи в БД", message: error.localizedDescription)
                        } else {
                            self.refreshControl.endRefreshing()
                            self.pairTableAndRealm()
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlertVC(title: "Ошибка", message: error.rawValue)
                }
            }
        }
    }
    
    private func addGroup(group: GroupModel) {
        NetworkService.shared.addGroup(for: group.groupId) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let result):
                if result.response == 1 {
                    DispatchQueue.main.async {
                        if let error = RealmService.shared.addGroup(group: group) {
                            self.presentAlertVC(title: "Ошибка записи в БД", message: error.localizedDescription)
                        } else {
                            self.refreshControl.endRefreshing()
                            self.pairTableAndRealm()
                            self.allGroupVC?.presentAlertVC(title: "Готово", message: "Вы вступили в группу")
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.allGroupVC?.presentAlertVC(title: "Вы не смогли вступить в группу", message: error.rawValue)
                }
            }
        }
    }
    
    private func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        groups = realm.objects(GroupModel.self)
        token = groups?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0,   section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                self?.presentAlertVC(title: "Ошибка", message: "\(error)")
            }
        }
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        getGroups()
    }
}

// MARK: - Table view data source
extension UserGroupsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserGroupCell.self)) as? UserGroupCell,
           let group = groups?[indexPath.row] {
            cell.set(group: group)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - Table view delegate
extension UserGroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let groups = groups else { return }
        let group = groups[indexPath.row]
        if editingStyle == .delete {
            deleteGroup(groupId: group.groupId)
            pairTableAndRealm()
        }
    }
}

// MARK: - SelectedGroupDelegate
extension UserGroupsViewController: SelectedGroupDelegate {
    func selectedGroup(selectedGroup: GroupModel) {
        addGroup(group: selectedGroup)
    }
}
