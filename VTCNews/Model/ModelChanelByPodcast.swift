//
//  ModelChanelByPodcast.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/17/21.
//

import Foundation
import SwiftyJSON

class ModelChanelByPodcast{
    var id : Int = 0
    var name : String = ""
    var podcast : Int = 0
    var slug : String = ""
    
    init(json: JSON){
        id = json["Id"].intValue
        name = json["Name"].stringValue
        podcast = json["Podcast"].intValue
        slug = json["Slug"].stringValue
    }
}
