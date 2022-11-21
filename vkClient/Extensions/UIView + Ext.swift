//
//  UIView + Ext.swift
//  vkClient
//
//  Created by Lina Prosvetova on 16.11.2022.
//

import UIKit


extension UIView {
    static var NibName: String {
        return String(describing: self)
    }

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static func uiNib() -> UINib {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }

    static func viewForNibName<T: UIView>() -> T {
        guard let view = Bundle.main.loadNibNamed(T.NibName, owner: self, options: nil)?.first as? T else {
            fatalError("Could not loadNibNamed: \(T.NibName)")
        }
        return view
    }
}
