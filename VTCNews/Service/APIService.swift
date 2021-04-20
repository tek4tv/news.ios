//
//  APIService.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService{
    static let shared: APIService = APIService()
    
    func getMenu(closure: @escaping (_ response: [ModelMenu]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/menu", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listMenu = [ModelMenu]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelMenu(json: i)
                    listMenu.append(c)
                }
                closure(listMenu, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getDanhSachTinTheoID(page:Int, id:Int , closure: @escaping (_ response: [ModelDanhSachTin]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/ArticleCategoryPaging/\(page)/\(id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelDanhSachTin]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelDanhSachTin(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getDanhSachTinHotTheoID(id:Int , closure: @escaping (_ response: [ModelDanhSachTin]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/NewsHot/\(id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelDanhSachTin]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelDanhSachTin(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getTinMoi(page:Int, closure: @escaping (_ response: [ModelDanhSachTin]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/trending/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelDanhSachTin]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelDanhSachTin(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    
    func getArticleHot(closure: @escaping (_ response: [ModelArticleHot]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/getarticlehot", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelArticleHot]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelArticleHot(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getChanelHot(closure: @escaping (_ response: [ModelChanelHot]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/getchannelhot", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelChanelHot]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelChanelHot(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getSuggestionHome(closure: @escaping (_ response: [ModelSuggestionHome]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/GetArticleSuggestionHome", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelSuggestionHome]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelSuggestionHome(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getVideoHome(closure: @escaping (_ response: [ModelVideoHome]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/GetVideoHome", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelVideoHome]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelVideoHome(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getVideoTab(page:Int,closure: @escaping (_ response: [ModelVideoTab]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/Video/VideoSuggestionAjax/27/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelVideoTab]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelVideoTab(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getVideo0Tab(closure: @escaping (_ response: [ModelVideoTab]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/Video/VideoHot/27", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelVideoTab]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelVideoTab(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getSachNoi(closure: @escaping (_ response: [ModelSachNoi]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/podcast/GetAlbumPaging/chanId/3/pageIndex/1", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelSachNoi]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelSachNoi(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getAmNhacVietNam(closure: @escaping (_ response: [ModelAmNhac]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/podcast/GetAlbumPaging/chanId/14/pageIndex/1", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelAmNhac]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelAmNhac(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getAmNhacAuMy(closure: @escaping (_ response: [ModelAmNhac]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/podcast/GetAlbumPaging/chanId/2/pageIndex/1", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelAmNhac]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelAmNhac(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getPodcast(closure: @escaping (_ response: [ModelPodCast]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/podcast/GetAlbumPaging/chanId/5/pageIndex/1", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelPodCast]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelPodCast(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getChiTietTin(id:Int ,closure: @escaping (_ response: ModelChiTietTin?, _ img:String?, _ listTag: [ListTag]?, _ listArticleRelated: [ListArticleRelated]? , _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api//home/news/detail/\(id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                if let data = value as? [String:Any]{
                    guard let detail = data["DetailData"] as? [String:Any] else {return}
                    let chitiettin = ModelChiTietTin().initLoad(detail)
                    guard let img = data["image16_9"] as? String else {return}
                    
                    var listDataTag = [ListTag]()
                    let jsonTag = JSON(data["ListTag"]!).arrayValue
                    for i in jsonTag {
                        let c = ListTag(json: i)
                        listDataTag.append(c)
                    }
                    
                    var listDataRelated = [ListArticleRelated]()
                    let jsonRelated = JSON(data["ListArticleRelated"]!).arrayValue
                    for i in jsonRelated {
                        let c = ListArticleRelated(json: i)
                        listDataRelated.append(c)
                    }
                    
                    closure(chitiettin,img,listDataTag,listDataRelated, nil)
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getAlbumDetail(id:Int ,closure: @escaping (_ response: [ModelAlbumDetail]?, _ name:String?, _ des: String?, _ chanelID: Int?, _ image:String?, _ countItem:Int? , _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/podcast/AlbumDetail/\(id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                if let data = value as? [String:Any]{
                    guard let info = data["Info"] as? [String:Any] else {return}
                    guard let name = info["Name"] as? String else {return}
                    guard let des = info["Des"] as? String else {return}
                    guard let chanelID = info["ChannelId"] as? Int else {return}
                    guard let image = info["image182_182"] as? String else {return}
                    guard let countItem = info["CountItem"] as? Int else {return}
                    var listItem = [ModelAlbumDetail]()
                    let js = JSON(data["Items"]!).arrayValue
                    for i in js {
                        let c = ModelAlbumDetail(json: i)
                        listItem.append(c)
                    }
                    closure(listItem,name,des,chanelID,image,countItem, nil)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    
    func getComment(page:Int, id:Int , closure: @escaping (_ response: [ModelComment]?,_ totalAllRecord: Int?,_ totalPage: Int? , _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/comment/GetComment/\(id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                if let data = value as? [String:Any] {
                    var listComment = [ModelComment]()
                    let jsonTag = JSON(data["Items"]!).arrayValue
                    for i in jsonTag {
                        let c = ModelComment(json: i)
                        listComment.append(c)
                    }
                    let totalAllRecord = JSON(data["TotalRecord"]!).intValue
                    let totalPage = JSON(data["TotalPage"]!).intValue
                    closure(listComment, totalAllRecord, totalPage,nil)
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getChanelByPodcast(id: Int,closure: @escaping (_ response: [ModelChanelByPodcast]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/podcast/ChannelByPodcast/\(id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelChanelByPodcast]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelChanelByPodcast(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getAlbumPaging(id: Int, page: Int,closure: @escaping (_ response: [ModelAlbumPaging]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/podcast/GetAlbumPaging/chanId/\(id)/pageIndex/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listDSTin = [ModelAlbumPaging]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelAlbumPaging(json: i)
                    listDSTin.append(c)
                }
                closure(listDSTin, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    
    func getVideoDetail(id:Int ,closure: @escaping (_ response: [ModelVideoDetail]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/GetVideoDetail/\(id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                var listMenu = [ModelVideoDetail]()
                let json = JSON(value).arrayValue
                for i in json {
                    let c = ModelVideoDetail(json: i)
                    listMenu.append(c)
                }
                closure(listMenu, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getDanhSachTinChanelHot(id:Int ,closure: @escaping (_ response: [ModelDanhSachTin]?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/IndexChannelPaging/1/\(id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                if let data = value as? [String:Any]{
                    var listData = [ModelDanhSachTin]()
                    let json = JSON(data["Items"]!).arrayValue
                    for i in json {
                        let c = ModelDanhSachTin(json: i)
                        listData.append(c)
                    }
                    closure(listData, nil)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getDanhSachTinTag(tag:String, page:Int ,closure: @escaping (_ response: [ModelResultTag]?, _ totalRecord: Int?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/IndexTagOld/\(tag)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                if let data = value as? [String:Any]{
                    var listData = [ModelResultTag]()
                    let json = JSON(data["Items"]!).arrayValue
                    for i in json {
                        let c = ModelResultTag(json: i)
                        listData.append(c)
                    }
                    
                    let totalRecord = JSON(data["TotalRecord"]!).intValue
                    
                    closure(listData, totalRecord, nil)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
