//
//  ModelMenu.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import Foundation
import SwiftyJSON

class ModelMenu{
    var id:Int = 0
    var seoSlug:String = ""
    var title:String = ""
    var orderMobile:Int = 0
    var isShowMenu:Bool
    var parentID:Int?
    
    init(json : JSON) {
        self.id = json["Id"].intValue
        self.seoSlug = json["SEOSlug"].stringValue
        self.title = json["Title"].stringValue
        self.orderMobile = json["OrderMobile"].intValue
        self.isShowMenu = json["IsShowMenu"].boolValue
        self.parentID = json["ParentId"].intValue
    }
    
    
}
