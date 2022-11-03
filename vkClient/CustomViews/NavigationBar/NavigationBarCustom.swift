//
//  NavigationBarCustom.swift
//  vkClient
//
//  Created by Lina Prosvetova on 27.10.2022.
//

import UIKit

class NavigationBarCustom: UIView {


    @IBOutlet private weak var pageTitle: UILabel!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var LeftButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var view: UIView!
    var nibName: String = "NavigationBarCustom"
    
    var leftButtonAction: (() -> ())?
    var rightButtonAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func loadFromNib() -> UIView {
        let bundle = Bundle(for: NavigationBarCustom.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func setup() {
        view = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        LeftButton.isHidden = true
        rightButton.isHidden = true
        searchBar.isHidden = true
        pageTitle.textColor = VKColors.labelColor
        pageTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        searchBar.searchTextField.textColor = VKColors.labelColor
        //pageTitle.text = "TestTitle"
    }
    
    public func setLeftButtonAction(action: (() -> ())?) {
        leftButtonAction = action
    }
    
    public func setRightButtonAction(action: (() -> ())?) {
        rightButtonAction = action
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        leftButtonAction?()
    }
    @IBAction func rightButtonTapped(_ sender: Any) {
        rightButtonAction?()
    }
    
    public func showSearchBar() {
        searchBar.isHidden = false
    }
    
    public func hideLeftButton() {
        LeftButton.isHidden = true
    }
    
    public func showLeftButton() {
        LeftButton.isHidden = false
    }
    
    public func hideRightButton() {
        rightButton.isHidden = true
    }
    
    public func showRightButton() {
        rightButton.isHidden = false
    }
    
    public func setRighButtonImage(imagename: String) {
        rightButton.setImage(UIImage(systemName: imagename), for: .normal)
        //button.setImage(UIImage(systemName: "search"), for: .normal)
    }
    public func hideTitle() {
        pageTitle.isHidden = true
    }
    
    public func setTitle(title: String) {
        pageTitle.text = title
    }
    
}
