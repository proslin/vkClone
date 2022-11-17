//
//  FriendsVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 11.10.2022.
//

import UIKit
import RealmSwift

class FriendsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarContainer: UIView!
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    var navBar: UIView!
    var friends: Results<Friend>?
    var token: NotificationToken?
    var entryCount: Int = 1
    let userSettings = UserSettings()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupNavBar()
        switch userSettings.entryCount {
        case 1:
            getFriends()
            userSettings.entryCount += 1
            userSettings.saveSettings()
        case 2..<5:
            pairTableAndRealm()
            userSettings.entryCount += 1
            userSettings.saveSettings()
        case 5:
            getFriends()
            userSettings.entryCount = 1
            userSettings.saveSettings()
        default:
            getFriends()
        }
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        getFriends()
    }
    
    // MARK: - Private methods
    private func configureTableView() {
        self.tableView.refreshControl = refreshControl
        self.tableView.register(UINib(nibName: String(describing: FriendCellXib.self), bundle: nil), forCellReuseIdentifier: String(describing: FriendCellXib.self))
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setupNavBar() {
        let navBarModel = NavigationBarModel(title: "Друзья")
        let _ = NavigationBarCustom.instanceFromNib(model: navBarModel, parentView: navBarContainer)
    }
    
    private func getFriends() {
        showSpinner()
        
        NetworkService.shared.getFriends() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.removeSpinner()
            }
            switch result {
            case .success(let friends):
                DispatchQueue.main.async {
                    RealmService.shared.saveFriends(friends)
                    self.refreshControl.endRefreshing()
                    self.pairTableAndRealm()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
                DispatchQueue.main.async {
                self.presentAlertVC(title: "Ошибка", message: error.rawValue)
                }
            }
        }
    }
    
    private func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        friends = realm.objects(Friend.self)
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
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
            case .error(let error):
                DispatchQueue.main.async {
                    self?.presentAlertVC(title: "Ошибка", message: "\(error)")
                }
            }
        }
    }
}

// MARK: - Table view data source
extension FriendsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendCellXib.self)) as! FriendCellXib
        guard let friends = friends else { return cell }
        let friend = friends[indexPath.row]
        cell.set(friend: friend)
        return cell
    }
}

// MARK: - Table view delegate
extension FriendsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let friends = friends else { return }
        let selectedFriend = friends[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendsPhotoVCKey") as! FriendsPhotoVC
        vc.selectedModel = selectedFriend
        self.show(vc, sender: nil)
    }
}
