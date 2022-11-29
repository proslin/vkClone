//
//  UIViewController + Ext.swift
//  vkClient
//
//  Created by Lina Prosvetova on 10.11.2022.
//

import UIKit

extension UIViewController {
    
    func presentAlertVC(title: String, message: String) {
        let alertVC = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    func showSpinner() {
        if self.view.viewWithTag(VKConstants.loadingViewTag) != nil { return }
        let loadingView = UIView(frame: view.bounds)
        loadingView.tag = VKConstants.loadingViewTag
        loadingView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        self.view.addSubview(loadingView)
    }
    
    func removeSpinner() {
        guard let loadingView = self.view.viewWithTag(VKConstants.loadingViewTag) else { return }
        loadingView.removeFromSuperview()
    }
}
