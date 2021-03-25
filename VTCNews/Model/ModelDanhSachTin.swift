//
//  ModelDanhSachTin.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import Foundation
import SwiftyJSON

class ModelDanhSachTin{
    var id:Int = 0
    var title:String = ""
    var categoryID:Int = 0
    var description:String = ""
    var categoryName:String = ""
    var publishedDate:String = ""
    var image:String = ""
    var isPhotoArticle:Int = 0
    var isVideoArticle:Int = 0
    init(json: JSON) {
        self.id = json["Id"].intValue
        self.title = json["Title"].stringValue
        self.categoryID = json["CategoryId"].intValue
        self.description = json["Description"].stringValue
        self.categoryName = json["CategoryName"].stringValue
        self.publishedDate = json["PublishedDate"].stringValue
        self.image = json["image16_9"].stringValue
        self.isPhotoArticle = json["IsPhotoArticle"].intValue
        self.isVideoArticle = json["IsVideoArticle"].intValue
    }
}
