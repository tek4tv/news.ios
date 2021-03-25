//
//  CellAudio.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/27/21.
//

import UIKit

class CellAudio: UICollectionViewCell {
    var delegate:CellAudioDelegate!
    var listSachNoi = [ModelSachNoi]()
    var listAmNhac = [ModelAmNhac]()
    var listPodCast = [ModelPodCast]()
    
    @IBOutlet weak var heightClv: NSLayoutConstraint!
    @IBOutlet weak var btnXemThem: UIButton!
    @IBOutlet weak var clv: UICollectionView!
    @IBOutlet weak var viewLarge: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        getSachNoi()
        getAmNhac()
        getPodcast()
        
        clv.delegate = self
        clv.dataSource = self
        
        clv.backgroundColor = .clear
        clv.register(UINib(nibName: "CellContentAudio", bundle: nil), forCellWithReuseIdentifier: "CellContentAudio")
        
        let height = clv.collectionViewLayout.collectionViewContentSize.height
        heightClv.constant = height
        self.contentView.setNeedsLayout()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return self.clv.contentSize
    }
    
    @IBAction func btnXemThem(_ sender: Any) {
    }
    
    func getSachNoi(){
        APIService.shared.getSachNoi() { (response, error) in
            if let rs = response {
                self.listSachNoi = rs
                DispatchQueue.main.async {
                    self.clv.reloadData()
                }
            }
        }
    }
    
    func getAmNhac(){
        APIService.shared.getAmNhacVietNam() { (response, error) in
            if let rs = response {
                self.listAmNhac = rs
                DispatchQueue.main.async {
                    self.clv.reloadData()
                }
            }
        }
    }
    
    func getPodcast(){
        APIService.shared.getPodcast() { (response, error) in
            if let rs = response {
                self.listPodCast = rs
                DispatchQueue.main.async {
                    self.clv.reloadData()
                }
            }
        }
    }
}
extension CellAudio: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: scale * 165)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellContentAudio", for: indexPath) as! CellContentAudio
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = listAmNhac.count != 0 ? listAmNhac[0].name : ""
            if listAmNhac.count != 0 {
                let url = URL(string: listAmNhac[0].image182182)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
            cell.imgType.image = UIImage(named: "imgAmNhac")
        case 1:
            cell.lblTitle.text = listSachNoi.count != 0 ? listSachNoi[1].name : ""
            if listSachNoi.count != 0 {
                let url = URL(string: listSachNoi[1].image182182)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)            }
            cell.imgType.image = UIImage(named: "imgSachNoi")
        default:
            cell.lblTitle.text = listPodCast.count != 0 ? listPodCast[1].name : ""
            if listPodCast.count != 0 {
                let url = URL(string: listPodCast[1].image182182)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
            cell.imgType.image = UIImage(named: "imgPodcast")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var id = 0
        switch indexPath.row {
        case 0:
            id = listAmNhac[0].id
        case 1:
            id = listSachNoi[1].id
        default:
            id = listPodCast[1].id
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
        vc.id = id
        delegate?.didSelect(vc)
        
    }
}
protocol CellAudioDelegate {
    func didSelect(_ vc:DetailAudioVC)
}
