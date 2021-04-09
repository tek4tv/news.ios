//
//  ChildrenTabMenuVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/29/21.
//

import UIKit
import XLPagerTabStrip

class ChildrenTabMenuVC: ButtonBarPagerTabStripViewController {
    
    var listChildrenMenu = [ModelMenu]()
    var id:Int = 0{
        didSet {
            for i in listMenu {
                if i.parentID == id && i.isShowMenu == true {
                    listChildrenMenu.append(i)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDesign()
        
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
        
        //setup rightbarbutton item
        let menuBtnRight = UIButton(type: .custom)
        menuBtnRight.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtnRight.setImage(UIImage(named:"icSearch"), for: .normal)
        //            menuBtn.addTarget(self, action: #selector(vc.onMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let menuBarItemRight = UIBarButtonItem(customView: menuBtnRight)
        menuBarItemRight.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItemRight.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItemRight
        
        //settup leftBarbutton item
        let menuBtnLeft = UIButton(type: .custom)
        menuBtnLeft.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtnLeft.setImage(UIImage(named:"icBack"), for: .normal)
        menuBtnLeft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        let menuBarItemLeft = UIBarButtonItem(customView: menuBtnLeft)
        menuBarItemLeft.customView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
        menuBarItemLeft.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItemLeft
        
        menuBtnRight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSearch(_:))))

        
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapSearch(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var child:[UIViewController] = []
        if listChildrenMenu.count != 0 {
            for i in listChildrenMenu {
                let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Clv1VC") as! Clv1VC
                child_1.name = i.title
                child_1.id = i.id
                child.append(child_1)
            }
            return child
        } else {
            let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Clv1VC") as! Clv1VC
            return [child_1]
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let selectedBarHeight: CGFloat = 2
        
        buttonBarView.selectedBar.frame.origin.y = buttonBarView.frame.size.height - selectedBarHeight
        buttonBarView.selectedBar.frame.size.height = selectedBarHeight
        
    }
    func loadDesign(){
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?,newCell:ButtonBarViewCell?,progressPercentage:CGFloat,changeCurrentIndex:Bool,animated:Bool) -> Void in
            guard changeCurrentIndex == true else {return}
            newCell?.transform = CGAffineTransform(scaleX: 1, y: 1)
            oldCell?.transform = CGAffineTransform(scaleX: 1, y: 1)
            oldCell?.label.textColor = .white
            newCell?.label.textColor = .white
        }
    }
}

