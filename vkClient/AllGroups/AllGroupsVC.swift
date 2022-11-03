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
    var group: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: AllGroupCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AllGroupCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        setNavigationBar()
        navigationBar.searchBar.delegate = self
        
    }
    
    private func setNavigationBar() {
        navigationBar.showSearchBar()
        navigationBar.hideTitle()
        navigationBar.showLeftButton()
        navigationBar.setLeftButtonAction {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func getGroups(searchRequest: String) {
        NetworkManager.shared.getSearchGroups(for: searchRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let groups):
                var ids = groups.reduce("") { $0 + String($1.groupId) + "," }
                ids.removeLast(1)
                self.getGroupsList(groupsIds: ids)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    

    private func getGroupsList(groupsIds: String) {
        NetworkManager.shared.getGroupsList(for: groupsIds) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let groups):
                self.allgroups = groups
                DispatchQueue.main.async { self.tableView.reloadData() }
                
            case .failure(let error):
                print(error.rawValue)
            }
    }
    }
    
}

// MARK: UITableViewDataSource
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

// MARK: UITableViewDelegate
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

// MARK: UISearchBarDelegate
extension AllGroupsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Ввели запрос - \(searchText)")
        if !searchText.isEmpty{
        getGroups(searchRequest: searchText)
        } else {
            self.allgroups.removeAll()
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.allgroups.removeAll()
        self.tableView.reloadData()
    }
}

}
