//
//  ModelChitiettin.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/27/21.
//

import Foundation
import SwiftyJSON

class ModelChiTietTin{
    var author:String = ""
    var categoryCode:String = ""
    var categoryId:Int = 0
    var categoryName:String = ""
    var content:String = ""
    var description:String = ""
    var publishedDate:String = ""
    var title:String = ""
    var id: Int = 0
    var seoSlug = ""
    var likeCount = 0

    
    func initLoad(_ json: [String: Any]) -> ModelChiTietTin{
        if let temp = json["Author"] as? String { self.author = temp}
        
        if let temp = json["CategoryCode"] as? String { self.categoryCode = temp}

        if let temp = json["CategoryId"] as? Int { self.categoryId = temp}

        if let temp = json["CategoryName"] as? String { self.categoryName = temp}

        if let temp = json["Content"] as? String { self.content = temp}

        if let temp = json["Description"] as? String { self.description = temp}

        if let temp = json["PublishedDate"] as? String { self.publishedDate = temp}

        if let temp = json["Title"] as? String { self.title = temp}
        
        if let temp = json["Id"] as? Int { self.id = temp}

        if let temp = json["SEOSlug"] as? String { self.seoSlug = temp}
        
        if let temp = json["LikeCount"] as? Int { self.likeCount = temp}

        return self
    }
}

class ListTag{
    var tagId:Int = 0
    var tagName:String = ""
    var tagTitleWithoutUnicode = ""
    
    init(json: JSON) {
        self.tagId = json["TagId"].intValue
        self.tagName = json["TagName"].stringValue
        self.tagTitleWithoutUnicode = json["TagTitleWithoutUnicode"].stringValue
    }
}

class ListArticleRelated{
    var id:Int = 0
    var title:String = ""
    var categoryId:Int = 0
    var description:String = ""
    var categoryName:String = ""
    var publishedDate:String = ""
    var image:String = ""
    
    init(json: JSON) {
        self.id = json["Id"].intValue
        self.title = json["Title"].stringValue
        self.categoryId = json["CategoryId"].intValue
        self.description = json["Description"].stringValue
        self.categoryName = json["CategoryName"].stringValue
        self.publishedDate = json["PublishedDate"].stringValue
        self.image = json["imagecrop"].stringValue
    }
}
