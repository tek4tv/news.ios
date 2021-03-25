//
//  ModelArticleHot.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/26/21.
//

import Foundation
import SwiftyJSON

class ModelArticleHot{
    var categoryId : Int = 0
    var categoryName : String = ""
    var cateGorySEOSlug : String = ""
    var countComment : Int = 0
    var descriptionField : String = ""
    var duration : Int = 0
    var id : Int = 0
    var image169 : String = ""
    var image169Large : String = ""
    var imageUrl : String = ""
    var isPhotoArticle : Int = 0
    var isVideoArticle : Int = 0
    var likeCount : Int = 0
    var listUrlImages : String = ""
    var orderBy : Int = 0
    var publishedDate : String = ""
    var sEOSlug : String = ""
    var title : String = ""
    var type : Int = 0
    var viewCount : Int = 0
    
    init(json : JSON) {
        categoryId = json["CategoryId"].intValue
        categoryName = json["CategoryName"].stringValue
        cateGorySEOSlug = json["CateGorySEOSlug"].stringValue
        countComment = json["CountComment"].intValue
        descriptionField = json["Description"].stringValue
        duration = json["Duration"].intValue
        id = json["Id"].intValue
        image169 = json["image16_9"].stringValue
        image169Large = json["image16_9_large"].stringValue
        imageUrl = json["ImageUrl"].stringValue
        isPhotoArticle = json["IsPhotoArticle"].intValue
        isVideoArticle = json["IsVideoArticle"].intValue
        likeCount = json["LikeCount"].intValue
        listUrlImages = json["ListUrlImages"].stringValue
        orderBy = json["OrderBy"].intValue
        publishedDate = json["PublishedDate"].stringValue
        sEOSlug = json["SEOSlug"].stringValue
        title = json["Title"].stringValue
        type = json["Type"].intValue
        viewCount = json["ViewCount"].intValue
    }
}
