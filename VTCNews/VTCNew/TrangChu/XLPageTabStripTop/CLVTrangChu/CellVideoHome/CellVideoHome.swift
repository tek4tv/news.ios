//
//  CellVideoHome.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/26/21.
//

import UIKit
import SkeletonView

class CellVideoHome: UICollectionViewCell {

    var listVideoHome = [ModelVideoHome]()

    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return self.clv.contentSize
    }
    
    @IBOutlet weak var heightClv: NSLayoutConstraint!
    @IBOutlet weak var btnXemThem: UIButton!
    @IBOutlet weak var clv: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clv.delegate = self
        clv.dataSource = self
        clv.backgroundColor = .clear
        
        clv.register(UINib(nibName: "CellContenVideoHome", bundle: nil), forCellWithReuseIdentifier: "CellContenVideoHome")
        let layout = UICollectionViewFlowLayout()
        clv.collectionViewLayout = layout
        getVideoHome()
        
        let height = clv.collectionViewLayout.collectionViewContentSize.height
        heightClv.constant = height
        self.contentView.setNeedsLayout()
        
    }
    
    func getVideoHome(){
        APIService.shared.getVideoHome() { (response, error) in
            if let rs = response {
                self.listVideoHome = rs
                DispatchQueue.main.async {
                    self.clv.reloadData()
                }
            }
        }
    }

    @IBAction func btnXemThem(_ sender: Any) {
    }
}

extension CellVideoHome: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            APIService.shared.getVideoDetail(id: self.listVideoHome[indexPath.row].id){
                (response, error) in
                
                var dataVideo = [ModelVideoDetail]()

                if let rs = response {
                    dataVideo = rs
                }
                
                if dataVideo.count != 0 {
                    let schedule = self.listVideoHome[indexPath.row].publishedDate
                    let timePass = publishedDate(schedule: schedule)
                    NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listVideoHome[indexPath.row].categoryName, "id":self.listVideoHome[indexPath.row].id,"name":self.listVideoHome[indexPath.row].title,"published":timePass,"des":self.listVideoHome[indexPath.row].descriptionField,"cateID":self.listVideoHome[indexPath.row].categoryId])
                } else {
//                    self.navigationController?.view.makeToast("Video bị lỗi")
                    print("Loi")
                }
            }
        } else {
            APIService.shared.getVideoDetail(id: self.listVideoHome[indexPath.row].id){
                (response, error) in
                
                var dataVideo = [ModelVideoDetail]()

                if let rs = response {
                    dataVideo = rs
                }
                
                if dataVideo.count != 0 {
                    let schedule = self.listVideoHome[indexPath.row+1].publishedDate
                    let timePass = publishedDate(schedule: schedule)
                    NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listVideoHome[indexPath.row+1].categoryName, "id":self.listVideoHome[indexPath.row+1].id,"name":self.listVideoHome[indexPath.row+1].title,"published":timePass,"des":self.listVideoHome[indexPath.row+1].descriptionField,"cateID":self.listVideoHome[indexPath.row+1].categoryId])
                } else {
//                    self.navigationController?.view.makeToast("Video bị lỗi")
                    print("Loi")
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellContenVideoHome", for: indexPath) as! CellContenVideoHome
        
        if indexPath.section == 0 {
            cell.lblTitle.font = UIFont.boldSystemFont(ofSize: 23)
            cell.lblTitle.text = listVideoHome.count != 0 ? listVideoHome[indexPath.row].title : ""
            if listVideoHome.count != 0 {
                let url = URL(string: listVideoHome[indexPath.row].image169Large)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
        } else {
            cell.lblTitle.font = cell.lblTitle.font.withSize(15)
            cell.lblTitle.text = listVideoHome.count != 0 ? listVideoHome[indexPath.row+1].title : ""
            
            if listVideoHome.count != 0 {
                let url = URL(string: listVideoHome[indexPath.row + 1].image169Large)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
        }
    
        
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: clv.bounds.width, height: scale * 350)
        } else {
            return CGSize(width: (clv.bounds.width - 40)/2 , height: scale * 210)
        }
    }
    
}
