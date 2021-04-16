//
//  Clv1VC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import UIKit
import XLPagerTabStrip
import Kingfisher
import Toast_Swift
import FBAudienceNetwork
import GoogleMobileAds

class Clv1VC: UICollectionViewController {
    //Admod
    var fbNativeAds: FBNativeAd?
    var admobNativeAds: GADUnifiedNativeAd?
    
    var name:String = ""
    var id:Int = 0
    var listDanhSachTin = [ModelDanhSachTin]()
    var page:Int = 0
    private let refreshControl = UIRefreshControl()

    var indexSelect = -1
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let native = AdmobManager.shared.randoomNativeAds(){
            if native is FBNativeAd{
                fbNativeAds = native as? FBNativeAd
                admobNativeAds = nil
            }else{
                admobNativeAds = native as? GADUnifiedNativeAd
                fbNativeAds = nil
            }
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.collectionView!.register(UINib(nibName: "CellCLV1", bundle: nil), forCellWithReuseIdentifier: "CellCLV1")
        self.collectionView!.register(UINib(nibName: "nativeAdmobCLVCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "nativeAdmobCLVCell")
        AdmobManager.shared.loadAllNativeAds()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: scale * 150)
        self.collectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
        
        getDataHot(id: id)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
            self.collectionView.alwaysBounceVertical = true
            self.collectionView.refreshControl = refreshControl // iOS 10+
        self.collectionView.delegate = self
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        APIService.shared.getDanhSachTinTheoID(page: 1, id: id) { (response, error) in
            if let rs = response {
                self.listDanhSachTin.append(contentsOf: rs)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    func getData(page: Int, id: Int){
        APIService.shared.getDanhSachTinTheoID(page: page, id: id) { (response, error) in
            if let rs = response {
                self.listDanhSachTin.append(contentsOf: rs)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    func getDataHot(id: Int){
        APIService.shared.getDanhSachTinHotTheoID(id: id) { (response, error) in
            if let rs = response {
                self.listDanhSachTin.append(contentsOf: rs)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    
    var dataVideo = [ModelVideoDetail]()
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listDanhSachTin[indexPath.row].isVideoArticle == 1 {
            APIService.shared.getVideoDetail(id: self.listDanhSachTin[indexPath.row].id){
                (response, error) in
                if let rs = response {
                    self.dataVideo = rs
                }
                
                if self.dataVideo.count != 0 {
                    let schedule = self.listDanhSachTin[indexPath.row].publishedDate
                    let timePass = publishedDate(schedule: schedule)
                    NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listDanhSachTin[indexPath.row].categoryName, "id":self.listDanhSachTin[indexPath.row].id,"name":self.listDanhSachTin[indexPath.row].title,"published":timePass,"des":self.listDanhSachTin[indexPath.row].description,"cateID":self.listDanhSachTin[indexPath.row].categoryID])
                } else {
                    self.navigationController?.view.makeToast("Video bị lỗi")
                }
            }
            
          
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
            vc.id = listDanhSachTin[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listDanhSachTin.count != 0 ? listDanhSachTin.count : 0
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == listDanhSachTin.count - 2 {
            page = page + 1
            getData(page: page, id: id)
        }
        print(page)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCLV1", for: indexPath) as! CellCLV1
        
        if listDanhSachTin[indexPath.row].isVideoArticle == 1 {
            cell.icVideo.isHidden = false
        }
        
        cell.lblTitle.text = listDanhSachTin.count != 0 ? listDanhSachTin[indexPath.row].title : ""
        
        if listDanhSachTin.count != 0 {
            let schedule = listDanhSachTin[indexPath.row].publishedDate
            let timePass = publishedDate(schedule: schedule)
            cell.lblPublished.text = timePass
        } else {
            cell.lblPublished.text = ""
        }
        
        cell.lblCategory.text = listDanhSachTin.count != 0 ?  listDanhSachTin[indexPath.row].categoryName : ""
        
        if listDanhSachTin.count != 0 {
            let url = URL(string: listDanhSachTin[indexPath.row].image)
            cell.img.kf.setImage(with: url){ result in
                cell.img.stopSkeletonAnimation()
                cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
            }
        } else {
            cell.img.isSkeletonable = true
            cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
        }
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "nativeAdmobCLVCell", for: indexPath) as! nativeAdmobCLVCell
            if let native = self.admobNativeAds {
                headerView.setupHeader(nativeAd: native)
            }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}


extension Clv1VC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: name)
    }
}

extension Clv1VC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if fbNativeAds == nil && admobNativeAds == nil{
            return CGSize(width: DEVICE_WIDTH, height: 0)
        }
        return CGSize(width: DEVICE_WIDTH, height: 150 * scale)

    }
}
extension Clv1VC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
