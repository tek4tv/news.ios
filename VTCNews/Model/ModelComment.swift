//
//  ModelComment.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/2/21.
//

import Foundation
import SwiftyJSON

class ModelComment{
    var accountId : Int = 0
    var avatar : String = ""
    var content : String = ""
    var countChild : Int = 0
    var countLike : Int = 0
    var createdDate : String = ""
    var customerName : String = ""
    var id : Int = 0
    var parentId : Int = 0
    init(json : JSON) {
        accountId = json["AccountId"].intValue
        avatar = json["Avatar"].stringValue
        content = json["Content"].stringValue
        countChild = json["CountChild"].intValue
        countLike = json["CountLike"].intValue
        createdDate = json["CreatedDate"].stringValue
        customerName = json["CustomerName"].stringValue
        id = json["Id"].intValue
        parentId = json["ParentId"].intValue
    }
}
