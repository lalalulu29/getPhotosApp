//
//  ViewController.swift
//  getPhotosApp
//
//  Created by Кирилл Любарских  on 24.07.2021.
//

import UIKit
import WebKit
class ViewController: UIViewController {
    
    @IBOutlet weak var authInVK: WKWebView!
    
    let clientId = "7910663"
    let redirect_uri = "https://vk.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authInVK.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        
        let url = URL(string: "https://oauth.vk.com/authorize?client_id=\(clientId)&redirect_uri=\(redirect_uri)&revoke=1&response_type=token")
        let urlReq = URLRequest(url: url!)
        authInVK.load(urlReq)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            if let title = authInVK.title {
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
            print("good auth")
            print(link)
        } else {
            print("Вы  не авторизовались")
        }
        
    }
    
}



