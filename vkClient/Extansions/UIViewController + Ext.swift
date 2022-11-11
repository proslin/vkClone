//
//  UIViewController + Ext.swift
//  vkClient
//
//  Created by Lina Prosvetova on 10.11.2022.
//

import UIKit

fileprivate var loadingView: UIView?

extension UIViewController {
    func showSpinner() {
        loadingView = UIView(frame: view.bounds)
        loadingView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = loadingView!.center
        activityIndicator.startAnimating()
        loadingView?.addSubview(activityIndicator)
        self.view.addSubview(loadingView!)
        
    }
    
    func removeSpinner() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
