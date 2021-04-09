//
//  WebviewSearch.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/25/21.
//

import UIKit
import WebKit
import SideMenu

class WebviewSearch: UIViewController, WKNavigationDelegate {
    let url = "https://cse.google.com/cse?cx=partner-pub-2579189069606201%3A4583669249&ie=UTF-8&q="
    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        actionBar()
        
        //        webview.load(NSURLRequest(url: NSURL(string: "https://cse.google.com/cse?cx=partner-pub-2579189069606201%3A4583669249&ie=UTF-8&q=")! as URL) as URLRequest)
        //        webview.load(NSURLRequest(url: NSURL(string: "https://vtc.vn/nu-sinh-lop-8-bi-danh-hoi-dong-da-man-phong-gd-dt-huyen-noi-gi-ar605776.html")! as URL) as URLRequest)
        webview.frame = view.bounds
        webview.navigationDelegate = self
        
        webview.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
        webview.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
               let host = url.host, !host.hasPrefix("www.google.com"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
                let url = navigationAction.request.url!
                UIApplication.shared.open(url)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
    
    
    func actionBar(){
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#a3151d")
        navigationController?.navigationBar.isTranslucent = false
        //setLogo
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icLogo")
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        //settup leftBarbutton item
        let menuBtnLeft = UIButton(type: .custom)
        menuBtnLeft.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtnLeft.setImage(UIImage(named:"icBack"), for: .normal)
        //            menuBtn.addTarget(self, action: #selector(vc.onMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let menuBarItemLeft = UIBarButtonItem(customView: menuBtnLeft)
        menuBarItemLeft.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItemLeft.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItemLeft
        
        //setup rightbarbutton item
        let menuBtnRight = UIButton(type: .custom)
        menuBtnRight.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtnRight.setImage(UIImage(named:"icSearch"), for: .normal)
        //            menuBtn.addTarget(self, action: #selector(vc.onMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let menuBarItemRight = UIBarButtonItem(customView: menuBtnRight)
        menuBarItemRight.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItemRight.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItemRight
        
        menuBtnLeft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back(_:))))
    }
    @objc func back(_ sender: UITapGestureRecognizer){
        self.navigationController?.popViewController(animated: true)
    }
}
