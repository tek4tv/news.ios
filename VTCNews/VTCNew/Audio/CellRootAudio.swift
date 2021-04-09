//
//  CellRootAudio.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/28/21.
//

import UIKit

class CellRootAudio: UICollectionViewCell {
    var delegate:CellRootAudioDelegate!
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
    
    
    @IBOutlet weak var btnMaginTop: NSLayoutConstraint!
    @IBOutlet weak var btnMarginBot: NSLayoutConstraint!
    @IBOutlet weak var clvMarginTop: NSLayoutConstraint!
    @IBOutlet weak var imgMarginTop: NSLayoutConstraint!
    
    @IBOutlet weak var test: NSLayoutConstraint!
    var listSachNoi = [ModelSachNoi]()
    var listAmNhac = [ModelAmNhac]()
    var listAmNhac1 = [ModelAmNhac]()
    var listPodCast = [ModelPodCast]()
    var index = IndexPath()
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var clv: UICollectionView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var viewBg: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clv.delegate = self
        clv.dataSource = self
        
        clv.register(UINib(nibName: "CellChildrenAudio", bundle: nil), forCellWithReuseIdentifier: "CellChildrenAudio")
        let layout = UICollectionViewFlowLayout()
        clv.collectionViewLayout = layout
        clv.backgroundColor = .clear
        
        viewBg.layer.masksToBounds = true
        getSachNoi()
        getAmNhac()
        getPodcast()
        
        let height = clv.collectionViewLayout.collectionViewContentSize.height
        heightClv.constant = height
        self.contentView.setNeedsLayout()
    }
    
    
    
    func getSachNoi(){
        APIService.shared.getSachNoi() { (response, error) in
            if let rs = response {
                self.listSachNoi = rs
                DispatchQueue.main.async {
                    self.clv.reloadData()
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
                    self.clv.reloadData()
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
                    self.clv.reloadData()
                }
            }
        }
    }
    
    @IBAction func btnXemThem(_ sender: Any) {
    }
}
extension CellRootAudio: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: scale * 16, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width , height: collectionView.bounds.width + scale * 80)
        } else {
            return CGSize(width: (clv.bounds.width - 25)/2, height: (clv.bounds.width - 25)/2 + scale * 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellChildrenAudio", for: indexPath) as! CellChildrenAudio
        cell.indexRow = indexPath
        
        if indexPath.section == 0 {
            cell.lblTitle.font = cell.lblTitle.font.withSize(20)
            cell.heightImg.constant = collectionView.bounds.width-scale*40
        } else {
            cell.lblTitle.font = cell.lblTitle.font.withSize(10)
            cell.heightImg.constant = (clv.bounds.width - 25)/2-scale*40
        }
        
        cell.viewBg.backgroundColor = .white
        
        if index.row == 0 {
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
        }
        else if index.row == 1 {
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
            
        } else if index.row == 2 {
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
        if index.row == 0 {
            if indexPath.section == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listPodCast[indexPath.row].id
                delegate?.didSelect(vc)
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listPodCast[indexPath.row+1].id
                delegate?.didSelect(vc)
            }
        } else if index.row == 1 {
            if indexPath.section == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listSachNoi[indexPath.row].id
                delegate?.didSelect(vc)
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listSachNoi[indexPath.row].id
                delegate?.didSelect(vc)
            }
        } else {
            if indexPath.section == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listAmNhac[indexPath.row].id
                delegate?.didSelect(vc)

            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
                vc.id = listAmNhac[indexPath.row + 1].id
                delegate?.didSelect(vc)

            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
}


protocol CellRootAudioDelegate {
    func didSelect(_ vc:DetailAudioVC)
}
