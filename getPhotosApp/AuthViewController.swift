//
//  AuthViewController.swift
//  getPhotosApp
//
//  Created by Кирилл Любарских  on 25.07.2021.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var authInVkButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAuthInVkButton()
    }
    
    
    
    func configureAuthInVkButton() {
        authInVkButton.layer.cornerRadius = 8
        authInVkButton.addTarget(self,
                                 action: #selector(configureAndPresentWebView),
                                 for: .touchUpInside)
    }
    
    @objc private func configureAndPresentWebView() {
        let clientId = "7910663"
        let redirect_uri = "https://vk.com"
        let viewController = UIViewController()
        let webView = WKWebView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: viewController.view.frame.width,
                                              height: viewController.view.frame.height))
        viewController.view.addSubview(webView)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        guard let authUrl = URL(string: "https://oauth.vk.com/authorize?client_id=\(clientId)&redirect_uri=\(redirect_uri)&response_type=token&revoke=1") else {
            showAlertWith(error: "Error make URL", message: "Возникла ошибка при создании URL")
            return
            
        }
        let authRequest = URLRequest(url: authUrl)
        webView.load(authRequest)
        DispatchQueue.main.async {
            self.present(viewController, animated: true, completion: nil)
        }
        
        
        
    }
    
    func showAlertWith(error title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okActtion = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okActtion)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            if let title = (object as! WKWebView).title {
                if title == "OAuth Blank" {
                    dismiss(animated: true) {
                        self.parsLink((object as! WKWebView).url!)
                    }
                }
            }
        }
    }
    
    
    func parsLink(_ link: URL){
        let linkForString = link.absoluteString
        if linkForString.contains("token=") {
            let token = linkForString.sliceFrom(start: "token=", to: "&")!
            let userId = linkForString.sliceFrom(start: "user_id=", to: nil)!
            saveInfoInUserDefault(token: token, userId: userId)
            dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "goToPhotoView", sender: nil)
        } else {
            showAlertWith(error: "Ошибка авторизации", message: "Вы не дали доступ")
        }

    }
    
    func saveInfoInUserDefault(token: String, userId: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(token, forKey: "token")
        userDefaults.setValue(userId, forKey: "user")
    }
    
    
    
    
}
extension String {
    func sliceFrom(start: String, to: String?) -> String? {
        guard let startPoint = range(of: start) else {return nil}
        guard let to = to else {return self[startPoint.upperBound..<endIndex].description}
        guard let endPoint = range(of: to, range: startPoint.upperBound..<endIndex) else {return nil}
        return self[startPoint.upperBound..<endPoint.lowerBound].description
    }
}
