//
//  CellPlayAudio.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/19/21.
//

import UIKit

class CellPlayAudio: UICollectionViewCell {

    @IBOutlet weak var imgStatusPlay: UIImageView!
    @IBOutlet weak var icShare: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: LazyImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        imgStatusPlay.isHidden = true
    }

}
