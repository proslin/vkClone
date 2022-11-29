//
//  AllGroupsVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 26.10.2022.
//

import UIKit

final class AllGroupsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var navBarContainer: UIView!
    
    private var allgroups: [GroupModel] = []
    private var timer: Timer?
    var delegate: SelectedGroupDelegate?
    
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
        let navBarModel = NavigationBarModel(title: "", leftButton: navBarButtonModel, isSearchBar: true, searchBarPlaceholder: "введите сообщество")
        let navBar = NavigationBarCustom.instanceFromNib(model: navBarModel, parentView: navBarContainer)
        navBar?.setSearchBarDelegate(vc: self)
    }
    
    private func getGroups(searchRequest: String) {
        NetworkService.shared.getSearchGroups(for: searchRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let groups):
                var ids = groups.reduce("") { $0 + String($1.groupId) + "," }
                if !ids.isEmpty {
                    ids.removeLast(1)
                    self.getGroupsList(groupsIds: ids)
                }
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
                DispatchQueue.main.async {
                    self.presentAlertVC(title: "Ошибка", message: error.rawValue)
                }
            }
        }
    }
    
    private func createTimer(searchText: String) {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { timer in
                timer.invalidate()
                self.getGroups(searchRequest: searchText)
            }
        }
    }
    
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: UITableViewDataSource
extension AllGroupsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allgroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AllGroupCell.self)) as? AllGroupCell {
            let group = allgroups[indexPath.row]
            cell.set(group: group)
            return cell
        }  else {
            return UITableViewCell()
        }
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
    }
}

// MARK: UISearchBarDelegate
extension AllGroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty && searchText.count > 1 {
            cancelTimer()
            createTimer(searchText: searchText)
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

