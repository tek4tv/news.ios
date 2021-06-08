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
    var id = 0{
        didSet{
            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! RootTabbar
            vc.idNoti = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        if NetworkMonitor.shared.isConnected {
            APIService.shared.getMenu() { (response, error) in
                if let listData = response {
                    for i in listData {
                        listMenu.append(i)
                    }
                    if listMenu.count != 0 {
                        DispatchQueue.main.async {
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! RootTabbar
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        print("aaaaaaa")
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Không có kết nối mạng", message: "Hãy kiểm tra lại kết nối mạng của bạn trong cài đặt", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Thoát", style: UIAlertAction.Style.default, handler: { action in
                                            exit(0)}
            ))
            self.present(alert, animated: true, completion: nil)
        }        
    }
}
