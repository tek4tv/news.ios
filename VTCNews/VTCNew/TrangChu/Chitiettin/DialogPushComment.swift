//
//  DialogPushComment.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/24/21.
//

import UIKit
import Alamofire

class DialogPushComment: UIViewController {
    var content = ""
    var idArticle = 0
    var idComment = 0
    
    @IBOutlet weak var viewPushCmt: UIView!
    @IBOutlet weak var tfname: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    
    @IBOutlet weak var viewDone: UIView!
    @IBOutlet weak var btnClose: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDone.layer.masksToBounds = true
        viewDone.layer.cornerRadius = scale * 15
        btnSend.layer.cornerRadius = scale * 10
        
        viewPushCmt.layer.masksToBounds = true
        viewPushCmt.layer.cornerRadius = scale * 15
        btnClose.layer.cornerRadius = scale * 10
        
    }
    @IBAction func btnSend(_ sender: Any) {
        let userName = tfname.text!
        let email = tfEmail.text!
        
        if userName == "" || email == "" {
            
        } else {
            let url = "https://api.vtcnews.tek4tv.vn/api/home/comment/PostComment?_username=\(userName)&_email=\(email)&_idArticle=\(idArticle)&_idComment=\(idComment)&_value=\(content)"
            
            
            
            AF.request(url, method:.post, parameters: nil,encoding: JSONEncoding.default) .responseJSON { (response) in
                self.viewDone.isHidden = false
                self.viewPushCmt.isHidden = true
            }
        }
    }
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
