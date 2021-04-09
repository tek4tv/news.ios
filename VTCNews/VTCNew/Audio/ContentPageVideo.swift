//
//  ContentPageVideo.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/17/21.
//

import UIKit
import XLPagerTabStrip

class ContentPageVideo: UIViewController {
    
    @IBOutlet var viewBg: UIView!
    var bg:String = ""
    var listData = [ModelAlbumPaging]()
    @IBOutlet weak var clv: UICollectionView!
    var id: Int = 0
    var page: Int = 1
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBg.backgroundColor = UIColor(hexString: bg)
        getData(id: id, page: 1)
        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "CellChildrenAudio", bundle: nil), forCellWithReuseIdentifier: "CellChildrenAudio")
        let layout = UICollectionViewFlowLayout()
        clv.collectionViewLayout = layout
        clv.backgroundColor = .clear
    }
    
    func getData(id: Int, page: Int){
        APIService.shared.getAlbumPaging(id: id, page: page){ (response, error) in
            if let rs = response {
                self.listData.append(contentsOf: rs)
                DispatchQueue.main.async {
                    self.clv.reloadData()
                }
            }
        }
    }
}

extension ContentPageVideo: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: name)
    }
}
extension ContentPageVideo: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == listData.count - 5 {
                page = page + 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width , height: collectionView.bounds.width + scale * 80)
        } else {
            return CGSize(width: (collectionView.bounds.width - 35)/2, height: (collectionView.bounds.width - 35)/2 + scale * 60)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return listData.count - 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clv.dequeueReusableCell(withReuseIdentifier: "CellChildrenAudio", for: indexPath) as! CellChildrenAudio
        if indexPath.section == 1{
            if indexPath.row == listData.count - 1 {
                getData(id: id, page: page)
            }
        }
        
        
        if indexPath.section == 0 {
            cell.lblTitle.text = listData.count != 0 ? listData[indexPath.row].name : ""
            if listData.count != 0 {
                let url = URL(string: listData[indexPath.row].image182182)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
        } else {
            cell.lblTitle.text = listData.count != 0 ? listData[indexPath.row+1].name : ""
            if listData.count != 0 {
                let url = URL(string: listData[indexPath.row+1].image182182)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
        }
        
        if indexPath.section == 0 {
            cell.lblTitle.font = cell.lblTitle.font.withSize(25)
        } else {
            cell.lblTitle.font = cell.lblTitle.font.withSize(17)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return scale * 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return scale * 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
        if indexPath.section == 0 {
            vc.id = listData[indexPath.row].id
        }else {
            vc.id = listData[indexPath.row+1].id
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
