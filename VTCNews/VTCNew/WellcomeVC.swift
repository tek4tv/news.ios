//
//  WellcomeVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import UIKit
var listMenu = [ModelMenu]()
let scale = UIScreen.main.bounds.height / 896

class WellcomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        APIService.shared.getMenu() { (response, error) in
            if let listData = response {
                for i in listData {
                    listMenu.append(i)
                }
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! RootTabbar
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}
