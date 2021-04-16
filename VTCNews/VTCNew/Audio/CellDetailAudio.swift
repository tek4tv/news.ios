//
//  CellDetailAudio.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/17/21.
//

import UIKit
import AVFoundation

var isPlaying = false

class CellDetailAudio: UITableViewCell {
    var indexSelect: IndexPath!
    var indexPlaying: IndexPath!
    var beforeIndexPlaying: IndexPath!
    @IBOutlet weak var viewBg: UIView!
    var listData = [ModelAlbumDetail](){
        didSet{
            clvDetail.reloadData()
        }
    }
    @IBOutlet weak var clvDetail: UICollectionView!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: LazyImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        clvDetail.register(UINib(nibName: "CellPlayAudio", bundle: nil), forCellWithReuseIdentifier: "CellPlayAudio")
        clvDetail.dataSource = self
        clvDetail.delegate = self
        let layout = UICollectionViewFlowLayout()
        clvDetail.collectionViewLayout = layout
        viewBg.backgroundColor = UIColor(hexString: "#1f2341")
        clvDetail.backgroundColor = UIColor(hexString: "#fff7cb")
        clvDetail.layer.masksToBounds = true
        clvDetail.layer.cornerRadius = scale * 10
        img.layer.cornerRadius = scale * 10
    }
    
}

extension CellDetailAudio: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Cell: \(listData.count)")
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvDetail.dequeueReusableCell(withReuseIdentifier: "CellPlayAudio", for: indexPath) as! CellPlayAudio
        if let url = URL(string: listData[indexPath.row].image182182){
            cell.img.loadImage(fromURL: url)
        }
        cell.lblTitle.text = listData[indexPath.row].name
        if indexPath == indexSelect {
            cell.imgStatusPlay.isHidden = false
        } else {
            cell.imgStatusPlay.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: clvDetail.bounds.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: NSNotification.Name("playAudio"), object: nil, userInfo: ["listData":listData, "index":indexPath.row])
        isPlaying = false
        indexSelect = indexPath
        clvDetail.reloadData()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopVOVLive"), object: nil)
        
    }
    func cellForRowAt(indexPath: IndexPath) -> CellPlayAudio? {
        guard let cell = clvDetail.cellForItem(at: indexPath) as? CellPlayAudio else {
            return clvDetail.dequeueReusableCell(withReuseIdentifier: "CellPlayAudio", for: indexPath) as? CellPlayAudio
        }
        return cell
    }
}

