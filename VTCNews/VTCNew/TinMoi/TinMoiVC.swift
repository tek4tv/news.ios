//
//  TinMoiVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import UIKit
import SideMenu
import Toast_Swift
import FBAudienceNetwork
import GoogleMobileAds

class TinMoiVC: UIViewController {
    //Admod
    var fbNativeAds: FBNativeAd?
    var admobNativeAds: GADUnifiedNativeAd?
    
    private let refreshControl = UIRefreshControl()
    
    var listData = [ModelDanhSachTin]()
    var page = 1
    var dataVideo = [ModelVideoDetail]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let native = AdmobManager.shared.randoomNativeAds(){
            if native is FBNativeAd{
                fbNativeAds = native as? FBNativeAd
                admobNativeAds = nil
            }else{
                admobNativeAds = native as? GADUnifiedNativeAd
                fbNativeAds = nil
            }
            clv.reloadData()
        }
    }
    
    @IBOutlet weak var clv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionBar()
        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "CellCLV1", bundle: nil), forCellWithReuseIdentifier: "CellCLV1")
        let layout = UICollectionViewFlowLayout()
        clv.collectionViewLayout = layout
        getData(page: page)
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        clv.alwaysBounceVertical = true
        clv.refreshControl = refreshControl // iOS 10+
        //register cell admod
        clv.register(UINib(nibName: "nativeAdmobCLVCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "nativeAdmobCLVCell")
        AdmobManager.shared.loadAllNativeAds()
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        APIService.shared.getTinMoi(page: page){
            (response, error) in
            if let rs = response{
                self.listData.append(contentsOf: rs)
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.clv.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func getData(page:Int){
        APIService.shared.getTinMoi(page: page){
            (response, error) in
            if let rs = response{
                self.listData.append(contentsOf: rs)
                DispatchQueue.main.async {
                    self.clv.reloadData()
                }
            }
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
    }
    
    @objc func tapSearch(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.present(vc, animated: true, completion: nil)
    }
    @objc func tapSideMenu(_ sender: UITapGestureRecognizer){
        let menu = storyboard?.instantiateViewController(withIdentifier: "leftMenu") as! SideMenuNavigationController
        menu.menuWidth = scaleW * 350
        menu.navigationBar.isHidden = true
        menu.presentationStyle = .menuSlideIn
        present(menu, animated: true, completion: nil)
    }
    
    
}

extension TinMoiVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: scale * 135)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == listData.count - 5 {
            page = page + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clv.dequeueReusableCell(withReuseIdentifier: "CellCLV1", for: indexPath) as! CellCLV1
        if indexPath.row == listData.count - 1  {
            getData(page: page)
        }
        
        if listData[indexPath.row].isVideoArticle == 1 {
            cell.icVideo.isHidden = false
        }
        
        cell.lblTitle.text = listData.count != 0 ? listData[indexPath.row].title : ""
        
        if listData.count != 0 {
            let schedule = listData[indexPath.row].publishedDate
            let timePass = publishedDate(schedule: schedule)
            cell.lblPublished.text = timePass
        } else {
            cell.lblPublished.text = ""
        }
        
        cell.lblCategory.text = listData.count != 0 ?  listData[indexPath.row].categoryName : ""
        
        if let url = URL(string: listData[indexPath.row].image){
            cell.img.loadImage(fromURL: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        
        if listData[indexPath.row].isVideoArticle == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
            vc.id = listData[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            APIService.shared.getVideoDetail(id: self.listData[indexPath.row].id){
                (response, error) in
                if let rs = response {
                    self.dataVideo = rs
                }
                
                if self.dataVideo.count != 0 {
                    let schedule = self.listData[indexPath.row].publishedDate
                    let timePass = publishedDate(schedule: schedule)
                    NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listData[indexPath.row].categoryName, "id":self.listData[indexPath.row].id,"name":self.listData[indexPath.row].title,"published":timePass,"des":self.listData[indexPath.row].description,"cateID":self.listData[indexPath.row].categoryID])
                } else {
                    self.navigationController?.view.makeToast("Video bị lỗi")
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "nativeAdmobCLVCell", for: indexPath) as! nativeAdmobCLVCell
            if let native = self.admobNativeAds {
                headerView.setupHeader(nativeAd: native)
            }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if fbNativeAds == nil && admobNativeAds == nil{
            return CGSize(width: DEVICE_WIDTH, height: 0)
        }
        return CGSize(width: DEVICE_WIDTH, height: 150 * scale)
    }
}
