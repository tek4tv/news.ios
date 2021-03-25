//
//  ModelVideoTab.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 3/2/21.
//

import Foundation
import SwiftyJSON

class ModelVideoTab{
    var categoryId : Int = 0
    var categoryName : String = ""
    var cateGorySEOSlug : String = ""
    var countComment : Int = 0
    var descriptionField : String = ""
    var duration : Int = 0
    var id : Int = 0
    var imageResize430x243 : String = ""
    var imageUrl : String = ""
    var isPhotoArticle : Int = 0
    var isVideoArticle : Int = 0
    var likeCount : Int = 0
    var orderBy : Int = 0
    var publishedDate : String = ""
    var sEOSlug : String = ""
    var title : String = ""
    var type : Int = 0
    var viewCount : Int = 0
    
    init(json: JSON!){
        
        categoryId = json["CategoryId"].intValue
        categoryName = json["CategoryName"].stringValue
        cateGorySEOSlug = json["CateGorySEOSlug"].stringValue
        countComment = json["CountComment"].intValue
        descriptionField = json["Description"].stringValue
        duration = json["Duration"].intValue
        id = json["Id"].intValue
        imageResize430x243 = json["ImageResize430x243"].stringValue
        imageUrl = json["ImageUrl"].stringValue
        isPhotoArticle = json["IsPhotoArticle"].intValue
        isVideoArticle = json["IsVideoArticle"].intValue
        likeCount = json["LikeCount"].intValue
        orderBy = json["OrderBy"].intValue
        publishedDate = json["PublishedDate"].stringValue
        sEOSlug = json["SEOSlug"].stringValue
        title = json["Title"].stringValue
        type = json["Type"].intValue
        viewCount = json["ViewCount"].intValue
    }
}
