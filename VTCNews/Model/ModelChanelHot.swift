//
//  ModelChanelHot.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/26/21.
//

import Foundation
import SwiftyJSON

class ModelChanelHot{
    var categoryId : Int = 0
    var channelThemeId : Int = 0
    var createdDate : String = ""
    var id : Int = 0
    var image : Int = 0
    var image169 : String = ""
    var imageUrl : String = ""
    var isHotNews : Bool = true
    var order : Int = 0
    var sEODesciption : String = ""
    var sEOKeyword : String = ""
    var sEOTitle : String = ""
    var status : Int = 0
    var title : String = ""
    var titleWithoutUnicode : String = ""
    
    init(json : JSON) {
        categoryId = json["CategoryId"].intValue
        channelThemeId = json["ChannelThemeId"].intValue
        createdDate = json["CreatedDate"].stringValue
        id = json["Id"].intValue
        image = json["Image"].intValue
        image169 = json["image16_9"].stringValue
        imageUrl = json["ImageUrl"].stringValue
        isHotNews = json["IsHotNews"].boolValue
        order = json["Order"].intValue
        sEODesciption = json["SEODesciption"].stringValue
        sEOKeyword = json["SEOKeyword"].stringValue
        sEOTitle = json["SEOTitle"].stringValue
        status = json["Status"].intValue
        title = json["Title"].stringValue
        titleWithoutUnicode = json["TitleWithoutUnicode"].stringValue
    }
}
