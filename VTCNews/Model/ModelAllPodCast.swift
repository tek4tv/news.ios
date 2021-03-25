//
//  ModelAllPostCast.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/27/21.
//

import Foundation
import SwiftyJSON

class ModelAllPodCast{
    var id:Int = 0
    var name:String = ""
    var createDate:String = ""
    
    init(json : JSON) {
        id = json["Id"].intValue
        name = json["Name"].stringValue
        createDate = json["CreatedDate"].stringValue
    }
}
