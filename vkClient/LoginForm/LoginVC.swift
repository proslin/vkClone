//
//  LoginVC.swift
//  vkClient
//
//  Created by Lina Prosvetova on 31.10.2022.
//

import UIKit
import WebKit

class LoginVC: UIViewController {

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
        URLQueryItem(name: "client_id", value: "51461702"), URLQueryItem(name: "display", value: "mobile"), URLQueryItem(name: "redirect_uri", value:
        "https://oauth.vk.com/blank.html"),
        URLQueryItem(name: "scope", value: "262150"),
        URLQueryItem(name: "response_type", value: "token"),
        URLQueryItem(name: "v", value: "5.68") ]
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)

    }
}

// MARK: WKNavigationDelegate
extension LoginVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse:
                 WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        let token = params["access_token"]
        guard token != nil else { return }
        Session.shared.token = token ?? " "
        let tabBarController = (self.storyboard?.instantiateViewController(withIdentifier: "TabBarControllerKey"))!
        present(tabBarController, animated: true, completion: nil)
    decisionHandler(.cancel)
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.presentAlertVC(title: "Ошибка", message: error.localizedDescription)
    }
}
