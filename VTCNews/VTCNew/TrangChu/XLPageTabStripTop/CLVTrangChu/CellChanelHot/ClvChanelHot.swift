//
//  ClvChanelHot.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/26/21.
//

import UIKit

class ClvChanelHot: UICollectionViewCell {
    var delegate: CellChanelHotDelegate!
    var listChanelHot = [ModelChanelHot]()
    @IBOutlet weak var clv: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clv.delegate = self
        clv.dataSource = self
        clv.backgroundColor = UIColor(hexString: "#e1990a")
        clv.register(UINib(nibName: "CellChanelHot", bundle: nil),forCellWithReuseIdentifier: "CellChanelHot")
        getDataChanelHot()
    }
    func getDataChanelHot(){
        APIService.shared.getChanelHot() { (response, error) in
            if let rs = response {
                self.listChanelHot = rs
                DispatchQueue.main.async {
                    self.clv.reloadData()                    
                }
            }
        }
    }
}

extension ClvChanelHot: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listChanelHot.count != 0 ? listChanelHot.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellChanelHot", for: indexPath) as! CellChanelHot
        cell.lblTitle.text = listChanelHot.count != 0 ? listChanelHot[indexPath.row].title : ""
        
        if let url = URL(string: listChanelHot[indexPath.row].image169){
            cell.img.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (clv.bounds.width - 45)/2, height: scale * 220)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: scale * 16, bottom: 0, right: scale * 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChannelHotVC") as! ChannelHotVC
        vc.id = listChanelHot[indexPath.row].id
        delegate?.didSelect(vc)
    }
}
protocol CellChanelHotDelegate {
    func didSelect(_ vc:ChannelHotVC)
}
