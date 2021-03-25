//
//  WebviewSearch.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/25/21.
//

import UIKit
import WebKit

class WebviewSearch: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        webview.load(NSURLRequest(url: NSURL(string: "https://cse.google.com/cse?cx=partner-pub-2579189069606201%3A4583669249&ie=UTF-8&q=")! as URL) as URLRequest)

    }

}
