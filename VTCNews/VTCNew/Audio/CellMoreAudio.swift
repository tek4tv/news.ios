//
//  CellMoreAudio.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/19/21.
//

import UIKit

class CellMoreAudio: UITableViewCell {

    var listData = [ModelAlbumPaging]()
    var id:Int = 0{
        didSet{
            getData(id: id)
        }
    }

    @IBOutlet weak var clv: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clv.register(UINib(nibName: "CellChildrenAudio", bundle: nil), forCellWithReuseIdentifier: "CellChildrenAudio")
        clv.delegate = self
        clv.dataSource = self
        let layout = UICollectionViewFlowLayout()
        clv.collectionViewLayout = layout

    }
    
    func getData(id:Int){
        APIService.shared.getAlbumPaging(id: id, page: 1){
            (response, error) in
            if let rs = response {
                self.listData = rs
                DispatchQueue.main.async {
                    self.clv.reloadData()
                }
            }
        }
    }
}

extension CellMoreAudio: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - scale*20)/2, height: (collectionView.bounds.width - scale*20)/2 + scale * 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return scale * 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clv.dequeueReusableCell(withReuseIdentifier: "CellChildrenAudio", for: indexPath) as! CellChildrenAudio
        cell.lblTitle.font = cell.lblTitle.font.withSize(20)
        cell.lblTitle.text = listData.count != 0 ? listData[indexPath.row].name : ""
        cell.viewBg.backgroundColor = UIColor(hexString: "#e5e5e5")
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("reloadAudio"), object: nil, userInfo: ["id":listData[indexPath.row].id])
    }
}
