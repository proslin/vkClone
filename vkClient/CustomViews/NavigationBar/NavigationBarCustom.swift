//
//  NavigationBarCustom.swift
//  vkClient
//
//  Created by Lina Prosvetova on 27.10.2022.
//

import UIKit

protocol NavBarButtonProtocol {
    var image: String { get set }
    var action: (() -> ())? { get set }
}

protocol NavigationBarProtocol {
    var title: String { get set }
    var leftButton: NavBarButtonProtocol? { get set }
    var rightButton: NavBarButtonProtocol? { get set }
    var isSearchBar: Bool { get set }
}

struct NavigationBarModel: NavigationBarProtocol {
    var title: String
    var leftButton: NavBarButtonProtocol?
    var rightButton: NavBarButtonProtocol?
    var isSearchBar: Bool = false
}

struct NavBarButton: NavBarButtonProtocol {
    var image: String
    var action: (() -> ())?
}

class NavigationBarCustom: UIView {
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet private weak var pageTitle: UILabel!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        leftButtonAction?()
    }
    @IBAction func rightButtonTapped(_ sender: Any) {
        rightButtonAction?()
    }
    
    //var view: UIView!
    //private var nibName: String = String(describing: NavigationBarCustom.self)
    
    var leftButtonAction: (() -> ())?
    var rightButtonAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Private methods
    private func setupParentViewConstraints(navigationView: NavigationBarCustom, parentView: UIView) {
        parentView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addSubview(navigationView)
        navigationView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        parentView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        navigationView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        parentView.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor).isActive = true
    }
    
    private func setupStyle() {
        pageTitle.textColor = VKColors.labelColor
        pageTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        searchBar.searchTextField.textColor = VKColors.labelColor
    }
    
    // MARK: - Public methods
    public class func instanceFromNib(model: NavigationBarProtocol, parentView: UIView) -> NavigationBarCustom? {
        let nib: NavigationBarCustom = NavigationBarCustom.viewForNibName()
        nib.setupParentViewConstraints(navigationView: nib, parentView: parentView)
        nib.pageTitle.text = model.title
        nib.leftButton.isHidden = true
        nib.searchBar.isHidden = true
        nib.rightButton.isHidden = true
        
        if model.rightButton != nil {
            nib.rightButton.isHidden = false
            nib.rightButton.setImage(UIImage(systemName: model.rightButton?.image ?? ""), for: .normal)
            nib.rightButtonAction = model.rightButton?.action
        }
        
        if model.leftButton != nil {
            nib.leftButton.isHidden = false
            nib.leftButton.setImage(UIImage(systemName: model.leftButton?.image ?? ""), for: .normal)
            nib.leftButtonAction = model.leftButton?.action
        }
        
        if model.isSearchBar {
            nib.searchBar.isHidden = false
            nib.pageTitle.isHidden = true
        }
        
        nib.setupStyle()
        return nib
    }
    
    public func setLeftButtonAction(action: (() -> ())?) {
        leftButtonAction = action
    }
    
    public func setRightButtonAction(action: (() -> ())?) {
        rightButtonAction = action
    }
    
    
    public func showSearchBar() {
        searchBar.isHidden = false
    }
    
    public func hideLeftButton() {
        leftButton.isHidden = true
    }
    
    public func showLeftButton() {
        leftButton.isHidden = false
    }
    
    public func hideRightButton() {
        rightButton.isHidden = true
    }
    
    public func showRightButton() {
        rightButton.isHidden = false
    }
    
    public func setRighButtonImage(imagename: String) {
        rightButton.setImage(UIImage(systemName: imagename), for: .normal)
    }
    public func hideTitle() {
        pageTitle.isHidden = true
    }
    
    public func setTitle(title: String) {
        pageTitle.text = title
    }
    
}
