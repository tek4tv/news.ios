//
//  HomeVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import UIKit

class RootTabbar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.visitTabAudio(_:)), name: NSNotification.Name(rawValue: "VisitTabAudio"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.visitTabVideo(_:)), name: NSNotification.Name(rawValue: "VisitTabVideo"), object: nil)
    }
    
    @objc func visitTabAudio(_ sender: Notification){
        self.selectedIndex = 3
    }
    @objc func visitTabVideo(_ sender: Notification){
        self.selectedIndex = 2
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
