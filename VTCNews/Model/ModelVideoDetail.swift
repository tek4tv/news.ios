//
//  ModelVideoDetail.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/22/21.
//

import Foundation
import SwiftyJSON

class ModelVideoDetail{
    var articleId : Int = 0
    var fileId : Int = 0
    var id : Int = 0
    var videoURL : String = ""
    init(json: JSON!){
        articleId = json["ArticleId"].intValue
        fileId = json["FileId"].intValue
        id = json["Id"].intValue
        videoURL = json["VideoURL"].stringValue
    }
}
