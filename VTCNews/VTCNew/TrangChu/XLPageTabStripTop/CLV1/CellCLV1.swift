//
//  CellCLV1.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import UIKit
class CellCLV1: UICollectionViewCell {

    @IBOutlet weak var icVideo: UIImageView!
    @IBOutlet weak var img: LazyImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblPublished: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.layer.cornerRadius = scale * 5
        
    }
    
    override func prepareForReuse() {
        img.image = nil
        icVideo.isHidden = true
        super.prepareForReuse()
    }
}
