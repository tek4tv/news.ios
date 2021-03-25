//
//  ReplyCommentVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 3/8/21.
//

import UIKit

class ReplyCommentVC: UIViewController {
    @IBOutlet weak var lblPublished: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblCountLike: UILabel!
    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var tbl: UITableView!
    
    var listCmt = [ModelComment]()
    var listCmtById = [ModelComment]()
    
    var published = ""
    var name = ""
    var content = ""
    var countLike = ""
    var idCmt = 0
    var idArticle = 0
    
    @objc func tapSearch(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.present(vc, animated: true, completion: nil)
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = name
        lblContent.text = content
        lblPublished.text = published
        lblCountLike.text = "\(countLike) thích"
        btnSend.layer.masksToBounds = true
        btnSend.layer.cornerRadius = scale * 10
        
        tbl.delegate = self
        tbl.dataSource = self
        
        for i in listCmt {
            if i.parentId == self.idArticle{
                listCmtById.append(i)
            }
        }
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icLogo")
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        //setup rightbarbutton item
        let menuBtnRight = UIButton(type: .custom)
        menuBtnRight.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtnRight.setImage(UIImage(named:"icSearch"), for: .normal)
        //            menuBtn.addTarget(self, action: #selector(vc.onMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let menuBarItemRight = UIBarButtonItem(customView: menuBtnRight)
        menuBarItemRight.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItemRight.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItemRight
        
        //settup leftBarbutton item
        let menuBtnLeft = UIButton(type: .custom)
        menuBtnLeft.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtnLeft.setImage(UIImage(named:"icBack"), for: .normal)
        menuBtnLeft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        let menuBarItemLeft = UIBarButtonItem(customView: menuBtnLeft)
        menuBarItemLeft.customView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
        menuBarItemLeft.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItemLeft
        menuBtnRight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSearch(_:))))
        
        tbl.register(UINib(nibName: "CellContentComment", bundle: nil), forCellReuseIdentifier: "CellContentComment")

    }
    @IBAction func btnSend(_ sender: Any) {
        if tf.text! == "" {
            self.navigationController?.view.makeToast("Không được để trống nội dung")
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DialogPushComment") as! DialogPushComment
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.content = tf.text!
            vc.idArticle = idArticle
            vc.idComment = idCmt
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension ReplyCommentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listCmtById.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellContentComment", for: indexPath) as! CellContentComment
     
        
        
        cell.lblName.text = listCmtById.count != 0 ? listCmtById[indexPath.row].customerName : ""
        cell.lblContent.text = listCmtById.count != 0 ? listCmtById[indexPath.row].content : ""
        cell.countLike.setTitle(" \(listCmtById[indexPath.row].countLike) thích", for: .normal)
        
        let schedule = listCmtById.count != 0 ? listCmtById[indexPath.row].createdDate : ""
        let timePass = publishedDate(schedule: schedule)
        cell.lblPublished.text = timePass
        
        
            cell.lblMoreReply.isHidden = true
            cell.btnMoreReplyConstrainTop.constant = scale * -4
            cell.btnMoreReplyConstrainBottom.constant = scale * -4
        
        
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
