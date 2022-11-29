//
//  FriendsVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 11.10.2022.
//

import UIKit
import RealmSwift

final class FriendsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navBarContainer: UIView!
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var friends: Results<FriendModel>?
    private var token: NotificationToken?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupNavBar()
        switch UserSettings.entryCount {
        case 1:
            getFriends()
            UserSettings.entryCount += 1
        case 2..<5:
            pairTableAndRealm()
            UserSettings.entryCount += 1
        case 5:
            getFriends()
            UserSettings.entryCount = 1
        default:
            getFriends()
        }
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        getFriends()
    }
    
    // MARK: - Private methods
    private func configureTableView() {
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: String(describing: FriendCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FriendCell.self))
        tableView.dataSource = self
        tableView.delegate = self
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
                    if let error = RealmService.shared.saveFriends(friends) {
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
    
    private func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        friends = realm.objects(FriendModel.self)
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
                self?.presentAlertVC(title: "Ошибка", message: "\(error)")
            }
        }
    }
}

// MARK: - Table view data source
extension FriendsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendCell.self)) as? FriendCell,
           let friend = friends?[indexPath.row] {
            cell.set(friend: friend)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - Table view delegate
extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let friends = friends else { return }
        let selectedFriend = friends[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FriendsPhotoVCKey") as? FriendsPhotoViewController {
            vc.selectedModel = selectedFriend
            self.show(vc, sender: nil)
        }
    }
}
