//
//  XemThemCmtVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 3/5/21.
//

import UIKit

class XemThemCmtVC: UIViewController {
    var listComment = [ModelComment]()
    var listChildrenCmt = [ModelComment]()
    var page:Int = 1
    var id = 0
    
    var totalPage = 0
    
    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        tbl.delegate = self
        tbl.dataSource = self
        tbl.register(UINib(nibName: "CellContentComment", bundle: nil), forCellReuseIdentifier: "CellContentComment")
        
        getComment(id: id, page: 1)
    }
    
    @objc func tapSearch(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getComment(id:Int, page: Int){
        APIService.shared.getComment(page: page, id: id){
            (response, totalAllRecord, totalPage,error) in
            if let rs = response {
                for i in rs {
                    if i.parentId == 0 {
                        self.listComment.append(i)
                    } else {
                        self.listChildrenCmt.append(i)
                    }
                }
                DispatchQueue.main.async {
                    self.tbl.reloadData()
                }
            }
            if let rs = totalPage {
                self.totalPage = rs
            }
        }
    }
    
    
}

extension XemThemCmtVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Listcmt: \(listComment.count)")
        return listComment.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = listComment.count - 1
        if indexPath.row == lastElement {
            if page < totalPage+1 {
                page = page + 1
                print("Page: \(page)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellContentComment", for: indexPath) as! CellContentComment
        
        if indexPath.row == listComment.count - 1 {
            if page < totalPage {
                print("PageCell: \(page)")
                getComment(id: id, page: page+1)
            }
        }
        
        
        cell.lblName.text = listComment.count != 0 ? listComment[indexPath.row].customerName : ""
        cell.lblContent.text = listComment.count != 0 ? listComment[indexPath.row].content : ""
        cell.countLike.setTitle(" \(listComment[indexPath.row].countLike) thích", for: .normal)
        
        let schedule = listComment.count != 0 ? listComment[indexPath.row].createdDate : ""
        let timePass = publishedDate(schedule: schedule)
        cell.lblPublished.text = timePass
        
        if listComment[indexPath.row].countChild != 0 {
            cell.lblMoreReply.isHidden = false
            cell.btnMoreReplyConstrainTop.constant = scale * 16
            cell.btnMoreReplyConstrainBottom.constant = scale * 16
            cell.lblMoreReply.text = "Xem thêm \(listComment[indexPath.row].countChild) phản hồi"
            cell.lblMoreReply.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapMoreReply(_:))))
        } else {
            cell.lblMoreReply.isHidden = true
            cell.btnMoreReplyConstrainTop.constant = scale * -4
            cell.btnMoreReplyConstrainBottom.constant = scale * -4
        }
        
        cell.reply.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapbtnReply(_:))))
        

        return cell
    }
    
    
    @objc func tapMoreReply(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: self.tbl)
        let indexPath = self.tbl.indexPathForRow(at: location)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReplyCommentVC") as! ReplyCommentVC
        vc.name = listComment[indexPath!.row].customerName
        vc.content = listComment[indexPath!.row].content
        let schedule = listComment.count != 0 ? listComment[indexPath!.row].createdDate : ""
        let timePass = publishedDate(schedule: schedule)
        vc.published = timePass
        vc.countLike = String(listComment[indexPath!.row].countLike)
        vc.idCmt = listComment[indexPath!.row].parentId
        vc.idArticle = listComment[indexPath!.row].id
        vc.listCmt = self.listChildrenCmt
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
 
    
    @objc func tapbtnReply(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: self.tbl)
        let indexPath = self.tbl.indexPathForRow(at: location)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReplyCommentVC") as! ReplyCommentVC
        vc.name = listComment[indexPath!.row].customerName
        vc.content = listComment[indexPath!.row].content
        let schedule = listComment.count != 0 ? listComment[indexPath!.row].createdDate : ""
        let timePass = publishedDate(schedule: schedule)
        vc.published = timePass
        vc.countLike = String(listComment[indexPath!.row].countLike)
        vc.idCmt = listComment[indexPath!.row].parentId
        vc.idArticle = listComment[indexPath!.row].id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
