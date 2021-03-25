//
//  ChannelHotVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 3/1/21.
//

import UIKit
import Toast_Swift

class ChannelHotVC: UIViewController {
    var id = 0
    var listData = [ModelDanhSachTin]()
    var dataVideo = [ModelVideoDetail]()

    @IBOutlet weak var clv: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawNavigation()
        registerCell()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: scale * 135)
        clv.collectionViewLayout = layout
        
        clv.delegate = self
        clv.dataSource = self
        
        getData(id: id)
        
    }
    
    func registerCell(){
        clv.register(UINib(nibName: "CellCLV1", bundle: nil), forCellWithReuseIdentifier: "CellCLV1")
    }
    
    
    
    func drawNavigation(){
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
    }
    
    @objc func tapSearch(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData(id: Int){
        APIService.shared.getDanhSachTinChanelHot(id: id) { (response, error) in
            if let rs = response {
                self.listData = rs
                DispatchQueue.main.async {
                    self.clv.reloadData()
                }
            }
        }
    }
}

extension ChannelHotVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listData[indexPath.row].isVideoArticle == 1 {
            APIService.shared.getVideoDetail(id: self.listData[indexPath.row].id){
                (response, error) in
                if let rs = response {
                    self.dataVideo = rs
                }
                
                if self.dataVideo.count != 0 {
                    let schedule = self.listData[indexPath.row].publishedDate
                    let timePass = publishedDate(schedule: schedule)
                    NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listData[indexPath.row].categoryName, "id":self.listData[indexPath.row].id,"name":self.listData[indexPath.row].title,"published":timePass,"des":self.listData[indexPath.row].description,"cateID":self.listData[indexPath.row].categoryID])
                } else {
                    self.navigationController?.view.makeToast("Video bị lỗi")
                }
            }
            
          
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
            vc.id = listData[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCLV1", for: indexPath) as! CellCLV1
        if indexPath.row == listData.count - 1  {
            getData(id: id)
        }
        
        if listData[indexPath.row].isVideoArticle == 1 {
            cell.icVideo.isHidden = false
        }
        
        cell.lblTitle.text = listData.count != 0 ? listData[indexPath.row].title : ""
        
        if listData.count != 0 {
            let schedule = listData[indexPath.row].publishedDate
            let timePass = publishedDate(schedule: schedule)
            cell.lblPublished.text = timePass
        } else {
            cell.lblPublished.text = ""
        }
        
        cell.lblCategory.text = listData.count != 0 ?  listData[indexPath.row].categoryName : ""
        
        if let url = URL(string: listData[indexPath.row].image){
            cell.img.loadImage(fromURL: url)
        }
        return cell
    }
    
    
}
