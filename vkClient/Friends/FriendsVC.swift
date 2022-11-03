//
//  FriendsVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 11.10.2022.
//

import UIKit

class FriendsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: NavigationBarCustom!
    var friends: [Friend] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriends()
       // generateFriends()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UINib(nibName: String(describing: FriendCellXib.self), bundle: nil), forCellReuseIdentifier: String(describing: FriendCellXib.self))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationBar.setTitle(title: "Друзья")
    }

    
//    private func generateFriends() {
//        let friend1 = Friend(friendName: "Bob", friendAvatarURL: "cat", friendPhotoAlbum: ["man", "man2", "boss", "group2"])
//        let friend2 = Friend(friendName: "Paul", friendAvatarURL: "man", friendPhotoAlbum: ["man", "man", "man"])
//        let friend3 = Friend(friendName: "Lora", friendAvatarURL: "man2", friendPhotoAlbum: ["woman", "woman", "woman", "group1"])
//        let friend4 = Friend(friendName: "Jane", friendAvatarURL: "woman", friendPhotoAlbum: ["woman", "woman", "woman"])
//        
//        friends.append(friend1)
//        friends.append(friend2)
//        friends.append(friend3)
//        friends.append(friend4)
//        tableView.reloadData()
//    }

    
    private func getFriends() {
        NetworkManager.shared.getFriends() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let friends):
                self.friends = friends
                DispatchQueue.main.async { self.tableView.reloadData() }
                
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
}

// MARK: - Table view data source

extension FriendsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FriendCellXib.self)) as! FriendCellXib
            let friend = friends[indexPath.row]
    //cell.selectionStyle = .none
            cell.set(friend: friend)
    
    return cell
}
}

extension FriendsVC: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend = friends[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendsPhotoVCKey") as! FriendsPhotoVC
        vc.selectedModel = selectedFriend
        self.show(vc, sender: nil)
    }
//
}