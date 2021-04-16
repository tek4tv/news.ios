//
//  CaNhanVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import UIKit
import SideMenu

class CaNhanVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        menuBtnLeft.setImage(UIImage(named:"icMenu"), for: .normal)
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
        
        menuBtnLeft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSideMenu(_:))))
        
        menuBtnRight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSearch(_:))))
        
        let btnLive = UIButton()
        btnLive.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnLive)
        btnLive.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(80*scale)).isActive = true
        btnLive.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16*scale).isActive = true
        btnLive.widthAnchor.constraint(equalToConstant: scale*64).isActive = true
        btnLive.heightAnchor.constraint(equalToConstant: scale*64).isActive = true
        btnLive.setImage(UIImage(named: "icLive"), for: .normal)
        btnLive.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBtnLive)))
        
    }
    @objc func tapBtnLive(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "VOVLiveVC") as! VOVLiveVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapSearch(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @objc func tapSideMenu(_ sender: UITapGestureRecognizer){
        let menu = storyboard?.instantiateViewController(withIdentifier: "leftMenu") as! SideMenuNavigationController
        menu.menuWidth = scaleW * 350
        menu.navigationBar.isHidden = true
        menu.presentationStyle = .menuSlideIn
        present(menu, animated: true, completion: nil)
    }

}
