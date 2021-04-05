//
//  VideoVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import UIKit
import SideMenu
import FBAudienceNetwork
import GoogleMobileAds

class VideoVC: UIViewController {
    //Admod
    var fbNativeAds: FBNativeAd?
    var admobNativeAds: GADUnifiedNativeAd?
    
    private let refreshControl = UIRefreshControl()

    var listData = [ModelVideoTab]()
    var page = 0
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
        
        getVideoFirst()
        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "CellRootVideoHome", bundle: nil), forCellWithReuseIdentifier: "CellRootVideoHome")
        let layout = UICollectionViewFlowLayout()
        clv.collectionViewLayout = layout
        
        menuBtnLeft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSideMenu(_:))))
        menuBtnRight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSearch(_:))))
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
            clv.alwaysBounceVertical = true
            clv.refreshControl = refreshControl // iOS 10+
        //register cell admod
        clv.register(UINib(nibName: "nativeAdmobCLVCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "nativeAdmobCLVCell")
        AdmobManager.shared.loadAllNativeAds()
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        APIService.shared.getVideoTab(page: page) { (response, error) in
            if let rs = response{
                self.listData.append(contentsOf: rs)
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.clv.reloadData()
                    self.refreshControl.endRefreshing()

                }
            }
        }
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
    
    func getVideoHome(page:Int){
        APIService.shared.getVideoTab(page: page) { (response, error) in
            if let rs = response{
                self.listData.append(contentsOf: rs)
                DispatchQueue.main.async {
                    self.clv.reloadData()
                    print(self.listData.count)
                }
            }
        }
    }
    
    func getVideoFirst(){
        APIService.shared.getVideo0Tab(){
            (response, error) in
            if let rs = response{
                self.listData.append(contentsOf: rs)
                DispatchQueue.main.async {
                    self.clv.reloadData()
                }
            }
        }
    }
}


extension VideoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == listData.count - 5 {
            page = page + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: scaleW * 380)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clv.dequeueReusableCell(withReuseIdentifier: "CellRootVideoHome", for: indexPath) as! CellRootVideoHome
        if indexPath.row == listData.count - 1  {
            getVideoHome(page: page)
        }
        if let url = URL(string: listData[indexPath.row].imageResize430x243){
            cell.img.loadImage(fromURL: url)
        }
        cell.lblTitle.text = listData[indexPath.row].title
        cell.lblCategory.text = listData[indexPath.row].categoryName
        let schedule = listData[indexPath.row].publishedDate
        let timePass = publishedDate(schedule: schedule)
        cell.lblPublished.text = timePass
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        APIService.shared.getVideoDetail(id: self.listData[indexPath.row].id){
            (response, error) in
            if let rs = response {
                self.dataVideo = rs
            }
            
            if self.dataVideo.count != 0 {
                let schedule = self.listData[indexPath.row].publishedDate
                let timePass = publishedDate(schedule: schedule)
                NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listData[indexPath.row].categoryName, "id":self.listData[indexPath.row].id,"name":self.listData[indexPath.row].title,"published":timePass,"des":self.listData[indexPath.row].descriptionField,"cateID":self.listData[indexPath.row].categoryId])
            } else {
                self.navigationController?.view.makeToast("Video bị lỗi")
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
