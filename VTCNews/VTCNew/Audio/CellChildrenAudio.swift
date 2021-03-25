//
//  CellChildrenAudio.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/28/21.
//

import UIKit

class CellChildrenAudio: UICollectionViewCell {
    
    var indexRow = IndexPath()
    
    @IBOutlet weak var heightImg: NSLayoutConstraint!
    @IBOutlet weak var constrainCoutn: NSLayoutConstraint!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBg.layer.cornerRadius = scale * 10
        viewBg.layer.masksToBounds = true
    }
}
