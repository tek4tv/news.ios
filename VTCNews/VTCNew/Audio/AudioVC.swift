//
//  AudioVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import UIKit
import SideMenu
import Kingfisher

class AudioVC: UIViewController {
    var listSachNoi = [ModelSachNoi]()
    var listAmNhac = [ModelAmNhac]()
    var listAmNhac1 = [ModelAmNhac]()
    var listPodCast = [ModelPodCast]()
    
    private let refreshControl = UIRefreshControl()

    @IBOutlet weak var heightAmNhac: NSLayoutConstraint!
    @IBOutlet weak var heightSachNoi: NSLayoutConstraint!
    @IBOutlet weak var heightPodCast: NSLayoutConstraint!
    @IBOutlet weak var clvAmNhac: UICollectionView!
    @IBOutlet weak var clvSachNoi: UICollectionView!
    @IBOutlet weak var clvPodCast: UICollectionView!
    @IBAction func btnXemThemAmNhac(_ sender: Any) {
        APIService.shared.getChanelByPodcast(id: 2) { (response, error) in
            if let rs = response {
                self.listPage = rs
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageAudioVC") as! PageAudioVC
                self.navigationController?.pushViewController(vc, animated: true)
                vc.listPage = self.listPage
                vc.bg = "#50b5ba"
            }
        }
    }
    @IBAction func btnXemThemSachNoi(_ sender: Any) {
        APIService.shared.getChanelByPodcast(id: 1) { (response, error) in
            if let rs = response {
                self.listPage = rs
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageAudioVC") as! PageAudioVC
                self.navigationController?.pushViewController(vc, animated: true)
                vc.listPage = self.listPage
                vc.bg = "#fd6f61"
            }
        }
    }
    @IBAction func btnXemThemPodCast(_ sender: Any) {
        APIService.shared.getChanelByPodcast(id: 5) { (response, error) in
            if let rs = response {
                self.listPage = rs
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageAudioVC") as! PageAudioVC
                self.navigationController?.pushViewController(vc, animated: true)
                vc.listPage = self.listPage
                vc.bg = "#fff9cb"
            }
        }
    }
    var listPage = [ModelChanelByPodcast]()
    
    @objc private func didPullToRefresh(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.refreshControl.endRefreshing()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        
        clvPodCast.delegate = self
        clvSachNoi.delegate = self
        clvAmNhac.delegate = self
        clvAmNhac.dataSource = self
        clvSachNoi.dataSource = self
        clvPodCast.dataSource = self
        
        clvPodCast.register(UINib(nibName: "CellChildrenAudio", bundle: nil), forCellWithReuseIdentifier: "CellChildrenAudio")
        clvAmNhac.register(UINib(nibName: "CellChildrenAudio", bundle: nil), forCellWithReuseIdentifier: "CellChildrenAudio")
        clvSachNoi.register(UINib(nibName: "CellChildrenAudio", bundle: nil), forCellWithReuseIdentifier: "CellChildrenAudio")
        
        let layoutPodCast = UICollectionViewFlowLayout()
        clvPodCast.collectionViewLayout = layoutPodCast
        let layoutSachNoi = UICollectionViewFlowLayout()
        clvSachNoi.collectionViewLayout = layoutSachNoi
        let layoutAmNhac = UICollectionViewFlowLayout()
        clvAmNhac.collectionViewLayout = layoutAmNhac
        
        clvPodCast.backgroundColor = .clear
        clvAmNhac.backgroundColor = .clear
        clvSachNoi.backgroundColor = .clear
        
        getSachNoi()
        getAmNhac()
        getPodcast()
        
        heightPodCast.constant = UIScreen.main.bounds.width + scale * 80 + ((UIScreen.main.bounds.width - 35)/2 + scale * 60)*2 + scale*120
        heightSachNoi.constant = UIScreen.main.bounds.width + scale * 80 + ((UIScreen.main.bounds.width - 35)/2 + scale * 60)*2 + scale*120
        heightAmNhac.constant = UIScreen.main.bounds.width + scale * 80 + ((UIScreen.main.bounds.width - 35)/2 + scale * 60)*2 + scale*120
        
    }
    
    @objc func tapSideMenu(_ sender: UITapGestureRecognizer){
        let menu = storyboard?.instantiateViewController(withIdentifier: "leftMenu") as! SideMenuNavigationController
        menu.menuWidth = scaleW * 350
        menu.navigationBar.isHidden = true
        menu.presentationStyle = .menuSlideIn
        present(menu, animated: true, completion: nil)
    }
    
    @objc func tapSearch(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getSachNoi(){
        APIService.shared.getSachNoi() { (response, error) in
            if let rs = response {
                self.listSachNoi = rs
                DispatchQueue.main.async {
                    self.clvSachNoi.reloadData()
                }
                print(self.listSachNoi.count)
            }
        }
    }
    
    func getAmNhac(){
        APIService.shared.getAmNhacVietNam() { (response, error) in
            if let rs = response {
                self.listAmNhac = rs
                DispatchQueue.main.async {
                    self.clvAmNhac.reloadData()
                    for i in 0...4 {
                        self.listAmNhac1.append(self.listAmNhac[i])
                    }
                }
            }
        }
    }
    
    func getPodcast(){
        APIService.shared.getPodcast() { (response, error) in
            if let rs = response {
                self.listPodCast = rs
                DispatchQueue.main.async {
                    self.clvPodCast.reloadData()
                }
            }
        }
    }
}

extension AudioVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width , height: collectionView.bounds.width + scale * 80)
        } else {
            return CGSize(width: (collectionView.bounds.width - scale*20)/2, height: (collectionView.bounds.width - scale*20)/2 + scale * 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: scale * 16, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellChildrenAudio", for: indexPath) as! CellChildrenAudio
        
        if indexPath.section == 0 {
            cell.lblTitle.font = cell.lblTitle.font.withSize(25)
        } else {
            cell.lblTitle.font = cell.lblTitle.font.withSize(17)
        }
        
        if collectionView.tag == 0 {
            if indexPath.section == 0 {
                cell.lblTitle.text = listPodCast.count != 0 ? listPodCast[indexPath.row].name : ""
                if listPodCast.count != 0 {
                    let url = URL(string: listPodCast[indexPath.row].image182182)
                    cell.img.kf.setImage(with: url){ result in
                        cell.img.stopSkeletonAnimation()
                        cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                    }
                } else {
                    cell.img.isSkeletonable = true
                    cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
                }
            } else {
                cell.lblTitle.text = listPodCast.count != 0 ? listPodCast[indexPath.row+1].name : ""
                if listPodCast.count != 0 {
                    let url = URL(string: listPodCast[indexPath.row+1].image182182)
                    cell.img.kf.setImage(with: url){ result in
                        cell.img.stopSkeletonAnimation()
                        cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                    }
                } else {
                    cell.img.isSkeletonable = true
                    cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
                }
            }
        } else if collectionView.tag == 1 {
            if indexPath.section == 0 {
                cell.lblTitle.text = listSachNoi.count != 0 ? listSachNoi[indexPath.row].name : ""
                if listSachNoi.count != 0 {
                    let url = URL(string: listSachNoi[indexPath.row].image182182)
                    cell.img.kf.setImage(with: url){ result in
                        cell.img.stopSkeletonAnimation()
                        cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                    }
                } else {
                    cell.img.isSkeletonable = true
                    cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
                }
            } else {
                cell.lblTitle.text = listSachNoi.count != 0 ? listSachNoi[indexPath.row].name : ""
                if listSachNoi.count != 0 {
                    let url = URL(string: listSachNoi[indexPath.row].image182182)
                    cell.img.kf.setImage(with: url){ result in
                        cell.img.stopSkeletonAnimation()
                        cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                    }
                } else {
                    cell.img.isSkeletonable = true
                    cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
                }
            }
        } else {
            if indexPath.section == 0 {
                cell.lblTitle.text = listAmNhac.count != 0 ? listAmNhac[indexPath.row].name : ""
                if listAmNhac.count != 0 {
                    let url = URL(string: listAmNhac[indexPath.row].image182182)
                    cell.img.kf.setImage(with: url){ result in
                        cell.img.stopSkeletonAnimation()
                        cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                    }
                } else {
                    cell.img.isSkeletonable = true
                    cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
                }
            } else {
                cell.lblTitle.text = listAmNhac.count != 0 ? listAmNhac[indexPath.row+1].name : ""
                if listAmNhac.count != 0 {
                    let url = URL(string: listAmNhac[indexPath.row+1].image182182)
                    cell.img.kf.setImage(with: url){ result in
                        cell.img.stopSkeletonAnimation()
                        cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                    }
                } else {
                    cell.img.isSkeletonable = true
                    cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            if indexPath.section == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listPodCast[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listPodCast[indexPath.row+1].id
                self.navigationController?.pushViewController(vc, animated: true)            }
        } else if collectionView.tag == 1 {
            if indexPath.section == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listSachNoi[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listSachNoi[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)            }
        } else {
            if indexPath.section == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listAmNhac[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listAmNhac[indexPath.row + 1].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
   
    
    func getData(id: Int){
        APIService.shared.getChanelByPodcast(id: id) { (response, error) in
            if let rs = response {
                self.listPage = rs
            }
        }
    }

    
    
}

extension AudioVC: CellRootAudioDelegate{
    func didSelect(_ vc: DetailAudioVC) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
