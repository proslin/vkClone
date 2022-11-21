//
//  AllGroupsVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 26.10.2022.
//

import UIKit

final class AllGroupsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarContainer: UIView!
    var allgroups: [Group] = []
    var delegate: SelectedGroupDelegate?
    var group: String!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupNavBar()
    }
    
    // MARK: - Private methods
    private func configureTableView() {
        tableView.register(UINib(nibName: String(describing: AllGroupCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AllGroupCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavBar() {
        let navBarButtonModel = NavBarButton(image: SFSymbols.shevron, action: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        let navBarModel = NavigationBarModel(title: "", leftButton: navBarButtonModel, isSearchBar: true)
        let navBar = NavigationBarCustom.instanceFromNib(model: navBarModel, parentView: navBarContainer)
        navBar?.searchBar.delegate = self
    }
    
    private func getGroups(searchRequest: String) {
        NetworkService.shared.getSearchGroups(for: searchRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let groups):
                var ids = groups.reduce("") { $0 + String($1.groupId) + "," }
                ids.removeLast(1)
                self.getGroupsList(groupsIds: ids)
            case .failure(let error):
                DispatchQueue.main.async {
                self.presentAlertVC(title: "Ошибка", message: error.rawValue)
                }
            }
        }
    }
    
    private func getGroupsList(groupsIds: String) {
        NetworkService.shared.getGroupsList(for: groupsIds) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let groups):
                self.allgroups = groups
                DispatchQueue.main.async { self.tableView.reloadData() }
                
            case .failure(let error):
                print(error.rawValue)
                DispatchQueue.main.async {
                self.presentAlertVC(title: "Ошибка", message: error.rawValue)
                }
            }
        }
    }

}

// MARK: UITableViewDataSource
extension AllGroupsViewController: UITableViewDataSource {
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
extension AllGroupsViewController: UITableViewDelegate {
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
extension AllGroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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

