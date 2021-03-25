//
//  ModelAlbumDetail.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/17/21.
//

import Foundation
import SwiftyJSON

class ModelAlbumDetail{
    var albumId : Int = 0
    var createdDate : String = ""
    var des : String = ""
    var fileUrl : String = ""
    var id : Int = 0
    var image182182 : String = ""
    var name : String = ""
    var publishedDate : String = ""
    var status : Int = 0
    var time : Int = 0
    
    init(json: JSON!){
        albumId = json["AlbumId"].intValue
        createdDate = json["CreatedDate"].stringValue
        des = json["Des"].stringValue
        fileUrl = json["FileUrl"].stringValue
        id = json["Id"].intValue
        image182182 = json["image182_182"].stringValue
        name = json["Name"].stringValue
        publishedDate = json["PublishedDate"].stringValue
        status = json["Status"].intValue
        time = json["Time"].intValue
    }
}
