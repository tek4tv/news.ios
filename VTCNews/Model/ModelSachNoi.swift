//
//  ModelChanelByPostCast.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/27/21.
//

import Foundation
import SwiftyJSON

class ModelSachNoi{
    var author : String = ""
    var channelId : Int = 0
    var createdDate : String = ""
    var des : String = ""
    var id : Int = 0
    var image182182 : String = ""
    var image360360 : String = ""
    var imageId : Int = 0
    var imageUrl : String = ""
    var name : String = ""
    var sEODes : String = ""
    var sEOKeyword : String = ""
    var sEOSlug : String = ""
    var sEOTitle : String = ""
    
    init(json : JSON) {
        author = json["Author"].stringValue
        channelId = json["ChannelId"].intValue
        createdDate = json["CreatedDate"].stringValue
        des = json["Des"].stringValue
        id = json["Id"].intValue
        image182182 = json["image182_182"].stringValue
        image360360 = json["image360_360"].stringValue
        imageId = json["ImageId"].intValue
        imageUrl = json["ImageUrl"].stringValue
        name = json["Name"].stringValue
        sEODes = json["SEODes"].stringValue
        sEOKeyword = json["SEOKeyword"].stringValue
        sEOSlug = json["SEOSlug"].stringValue
        sEOTitle = json["SEOTitle"].stringValue
    }
    
}
