//
//  ReadDetailVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 3/3/21.
//

import UIKit
import WebKit
import TagListView
import Toast_Swift
import FBAudienceNetwork
import GoogleMobileAds

class ReadDetailVC: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var lblCountCmt: UILabel!
    @IBOutlet weak var btnLikeCount: UIButton!
    //Admod
    var fbNativeAds: FBNativeAd?
    var admobNativeAds: GADUnifiedNativeAd?
    
    var sizeCmt:CGFloat = 0
    @IBOutlet weak var lblAuthor: UILabel!
    
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var clvThemThongTin: UICollectionView!
    @IBOutlet weak var heightClvThemThongTin: NSLayoutConstraint!
    @IBOutlet weak var tblComment: UITableView!
    @IBOutlet weak var heightTblComment: NSLayoutConstraint!
    
    @IBOutlet weak var btnXemThem: UIButton!
    @IBAction func btnXemThemBinhLuan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XemThemCmtVC") as! XemThemCmtVC
        vc.id = self.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var tfBinhLuan: UITextField!
    var listSizeCmt : [CGFloat] = []
    @IBAction func btnSendComent(_ sender: Any) {
        if tfBinhLuan.text! == "" {
            self.navigationController?.view.makeToast("Không được để trống nội dung")
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DialogPushComment") as! DialogPushComment
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.content = tfBinhLuan.text!
            vc.idArticle = chitietTin.id
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var btnSendComent: UIButton!
    @IBOutlet weak var clvCungChuyenMuc: UICollectionView!
    
    @IBOutlet weak var heightClvCungChuyenMuc: NSLayoutConstraint!
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.heightWebview.constant = webView.scrollView.contentSize.height
            self.heightClvThemThongTin.constant = scale * 145 * CGFloat(self.listArticleRelated.count)
            self.heightClvCungChuyenMuc.constant = scale * 145 * CGFloat(self.listDanhSachTin.count)
        }
    }
    @IBOutlet weak var heightWebview: NSLayoutConstraint!
    
    @IBOutlet weak var btnXemThemBinhLuanMarginTop: NSLayoutConstraint!
    @IBOutlet weak var tfMarginTop: NSLayoutConstraint!
    
    var listDanhSachTin = [ModelDanhSachTin]()
    
    var id:Int = 0 {
        didSet{
            print("sdsdsds: \(id)")
        }
    }
    
    var countComment = 0
    var chitietTin = ModelChiTietTin()
    var listTag = [ListTag]()
    var listArticleRelated = [ListArticleRelated]()
    
    var listComment = [ModelComment]()
    var sizeCmmt : [CGFloat] = []
    var imgString:String = ""
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var btnLike: UIView!
    @IBAction func btnShareTwiter(_ sender: Any) {
        sharePost()
    }
    @IBAction func btnShareZalo(_ sender: Any) {
        sharePost()
    }
    @IBAction func btnShareFb(_ sender: Any) {
        sharePost()
    }
    @IBOutlet weak var wbContent: WKWebView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblPublished: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        
        if let native = AdmobManager.shared.randoomNativeAds(){
            if native is FBNativeAd{
                fbNativeAds = native as? FBNativeAd
                admobNativeAds = nil
            }else{
                admobNativeAds = native as? GADUnifiedNativeAd
                fbNativeAds = nil
            }
            clvCungChuyenMuc.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        iMes = false
        btnLike.layer.masksToBounds = true
        btnLike.layer.cornerRadius = scale * 5
        
        wbContent.navigationDelegate = self
        wbContent.scrollView.isScrollEnabled = false
        clvCungChuyenMuc.isScrollEnabled = false
        registerCell()
        clvCungChuyenMuc.delegate = self
        clvCungChuyenMuc.dataSource = self
        clvThemThongTin.delegate = self
        clvThemThongTin.dataSource = self
        tblComment.delegate = self
        tblComment.dataSource = self
        
        let layoutCungChuyenMuc = UICollectionViewFlowLayout()
        clvCungChuyenMuc.collectionViewLayout = layoutCungChuyenMuc
        let layoutThemThongTin = UICollectionViewFlowLayout()
        clvThemThongTin.collectionViewLayout = layoutThemThongTin
        
        
        
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
        
        
        tfBinhLuan.layer.masksToBounds = true
        tfBinhLuan.layer.cornerRadius = scale * 10
        tfBinhLuan.layer.borderWidth = scale * 1
        tfBinhLuan.layer.borderColor = UIColor(hexString: "e5e5e5").cgColor
        btnSendComent.layer.masksToBounds = true
        btnSendComent.layer.cornerRadius = scale * 5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getChitiettin(id: self.id)
        }
        getComment(id: id, page: 1)
        
    }

    
    
    func getData(page: Int, id: Int){
        APIService.shared.getDanhSachTinTheoID(page: page, id: id) { (response, error) in
            if let rs = response {
                self.listDanhSachTin.append(contentsOf: rs)
                DispatchQueue.main.async {
                    self.clvCungChuyenMuc.reloadData()
                    self.clvThemThongTin.reloadData()
                }
            }
        }
    }
   
    
    func getChitiettin(id:Int){
        APIService.shared.getChiTietTin(id: id) { (response, img, listTag, listArticleRelated, error) in
            if let rs = response {
                self.chitietTin = rs
                DispatchQueue.main.async {
                    self.lblDes.text = self.chitietTin.description
                    self.lblTitle.text = self.chitietTin.title
                    self.lblCategoryName.text = self.chitietTin.categoryName
                    self.lblAuthor.text = self.chitietTin.author
                    self.btnLikeCount.setTitle(" THÍCH \(self.chitietTin.likeCount)", for: .normal)
                    let schedule = self.chitietTin.publishedDate
                    let timePass = publishedDate(schedule: schedule)
                    self.lblPublished.text = timePass
                    self.tagListView.removeAllTags()
                    self.tagListView.addTag("Tag:")
                    self.tagListView.textColor = UIColor(hexString: "#1b6eae")
                    self.tagListView.textFont = UIFont.systemFont(ofSize: 17)
                    
                    print("HeightTagView: \(self.tagListView.intrinsicContentSize)")
                    for i in self.listTag{
                        let tagView = self.tagListView.addTag("\(i.tagName),")
                        
                        tagView.onTap = { tagView in
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultTagVC") as! ResultTagVC
                            vc.textTag = i.tagTitleWithoutUnicode
                            vc.text = i.tagName
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                    let html = """
                    <html lang="en">

                    <head>
                      <meta charset="utf-8">
                      <title>Swiper demo</title>
                      <link href="https://vjs.zencdn.net/7.10.2/video-js.css" rel="stylesheet" />
                      <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
                      <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
                      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
                      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
                                  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.10/jquery.lazy.min.js"></script>
                                  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.10/jquery.lazy.plugins.min.js"></script>
                                  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
                                  <script src="https://vjs.zencdn.net/7.10.2/video.min.js"></script>
                                
                        <style>
                          body {
                            font-size: 40px;
                            margin-left: 10px;
                            margin-right: 10px;
                          }
                       
                        p{padding-left:10px;padding-right:10px;}
                        img {
                          width: 100%;
                        }
                        blockquote{
                          font-size: 40px !important;
                          line-height: 50px !important;
                        }
                        .expEdit{
                          font-size: 35px !important;
                          line-height: 40px !important;
                        }
                        
                        .vjs-big-play-button {
                        top: 50% ;
                        left: 50% ;
                      }
                     .video-js{
                       height: 450px;
                     }
                        .expEdit{
                          background-color: rgb(243, 243, 243);
                          padding-top: 5px;
                          padding-bottom: 5px;
                        }
                         </style>
                    </head>

                    <body>
                    <div>
                      \(self.chitietTin.content)
                    </div>
                      <script>
                         
                        $(document).ready(function(){
                               $(".lazy").each(function () {
                                    $(this).attr("src", $(this).attr("data-src"));
                                    $(this).removeAttr("data-src");
                                    $(this).addClass('img-fluid');
                                });
                                var dataId = $(".video-element").data("id");
                                var text = '<div id="loadding" class="hidden d-flex justify-content-center" style="margin-bottom:60px; align-items:center">';
                                text + '=  < i class="demo-icon icon-spin5 animate-spin" ></i >';
                                text += '</div >';
                                $(".video-element").html(text);
                                if (dataId) {
                                    if (dataId.length > 0) {
                                        var html = '';
                                        $.ajax({
                                            url: "https://api.vtcnews.tek4tv.vn/api/home/video/GetVideoById?text=" + dataId,
                                            type: 'GET'
                                        }).done(function (data) {
                                           
                                            html += '<video id="my-video"';
                                            html += 'class="video-js lazy"';
                                            html += 'controls';
                                            html += ' preload="auto"';
                                            html += ' height="300" ';
                                            html += 'poster="MY_VIDEO_POSTER.jpg"';
                                            html += ' data-setup="{}" style="width:100%">';
                                            html += '  <source src="https://media.vtc.vn' + data[0].URL + '" type="video/mp4" />';
                                            html += '   <source src="MY_VIDEO.webm" type="video/webm" />';
                                            html += '</video> ';
                                            $(".video-element").html(html);
                                        })
                                    }
                                }
                                
                    });
                       
                        </script>
                      </body>
                      </html>

                    """
                    
                    self.wbContent.loadHTMLString(html, baseURL: nil)
                }
            }
            if let rs = img {
                self.imgString = rs
                DispatchQueue.main.async {
                    
                }
            }
            if let rs = listTag {
                self.listTag = rs
                DispatchQueue.main.async {
                    
                }
            }
            if let rs = listArticleRelated {
                self.listArticleRelated = rs
                DispatchQueue.main.async {
                    self.clvThemThongTin.reloadData()
                    print("Count: \(self.listArticleRelated.count)")
                }
            }
            self.getData(page: 1, id: self.chitietTin.categoryId)
        }
    }
    
    func sharePost(){
        let url = "https://vtc.vn/\(chitietTin.seoSlug)-ar\(chitietTin.id).html"
        print(url)
        // set up activity view controller
        let textToShare = [ url ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func getComment(id:Int, page: Int){
        APIService.shared.getComment(page: page, id: id){
            (response, totalAllRecord, totalPage,error) in
            if let rs = response {
                self.listComment = rs
                DispatchQueue.main.async {
                    self.tblComment.reloadData()
                }
            }
            if let rs = totalAllRecord {
                self.countComment = rs
                if self.countComment == 0 {
                    self.heightTblComment.constant = 0
                }
                self.lblCountCmt.text = String(self.countComment)
                self.btnXemThem.setTitle("Xem tất cả bình luận", for: .normal)
            }
        }
    }
    
    
    
    func registerCell(){
        clvThemThongTin.register(UINib(nibName: "CellCLV1", bundle: nil), forCellWithReuseIdentifier: "CellCLV1")
        clvCungChuyenMuc.register(UINib(nibName: "CellCLV1", bundle: nil), forCellWithReuseIdentifier: "CellCLV1")
        tblComment.register(UINib(nibName: "CellContentComment", bundle: nil), forCellReuseIdentifier: "CellContentComment")
        clvCungChuyenMuc.register(UINib(nibName: "nativeAdmobCLVCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "nativeAdmobCLVCell")
        AdmobManager.shared.loadAllNativeAds()
    }
    
    
    
    @objc func tapSearch(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.navigationController?.pushViewController(vc, animated: true)
    }
    var dataVideo = [ModelVideoDetail]()

}

extension ReadDetailVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ReadDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 0 {
            if listArticleRelated[indexPath.row].isVideoArticle == 1 {
                APIService.shared.getVideoDetail(id: self.listArticleRelated[indexPath.row].id){
                    (response, error) in
                    if let rs = response {
                        self.dataVideo = rs
                    }
                    
                    if self.dataVideo.count != 0 {
                        let schedule = self.listArticleRelated[indexPath.row].publishedDate
                        let timePass = publishedDate(schedule: schedule)
                        NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listArticleRelated[indexPath.row].categoryName, "id":self.listArticleRelated[indexPath.row].id,"name":self.listArticleRelated[indexPath.row].title,"published":timePass,"des":self.listArticleRelated[indexPath.row].description,"cateID":self.listArticleRelated[indexPath.row].categoryID])
                    } else {
                        self.navigationController?.view.makeToast("Video bị lỗi")
                    }
                }
                
              
            } else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
                vc.id = listArticleRelated[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if listDanhSachTin[indexPath.row].isVideoArticle == 1 {
                APIService.shared.getVideoDetail(id: self.listDanhSachTin[indexPath.row].id){
                    (response, error) in
                    if let rs = response {
                        self.dataVideo = rs
                    }
                    
                    if self.dataVideo.count != 0 {
                        let schedule = self.listDanhSachTin[indexPath.row].publishedDate
                        let timePass = publishedDate(schedule: schedule)
                        NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listDanhSachTin[indexPath.row].categoryName, "id":self.listDanhSachTin[indexPath.row].id,"name":self.listDanhSachTin[indexPath.row].title,"published":timePass,"des":self.listDanhSachTin[indexPath.row].description,"cateID":self.listDanhSachTin[indexPath.row].categoryID])
                    } else {
                        self.navigationController?.view.makeToast("Video bị lỗi")
                    }
                }
                
              
            } else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
                vc.id = listDanhSachTin[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: scale*145)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return listArticleRelated.count
        } else {
            return listDanhSachTin.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCLV1", for: indexPath) as! CellCLV1
            
            if listArticleRelated[indexPath.row].isVideoArticle == 1 {
                cell.icVideo.isHidden = false
            }
            if listArticleRelated.count != 0 {
                let schedule = listArticleRelated[indexPath.row].publishedDate
                let timePass = publishedDate(schedule: schedule)
                cell.lblPublished.text = timePass
            } else {
                cell.lblPublished.text = ""
            }
            
            cell.lblCategory.text = listArticleRelated.count != 0 ? listArticleRelated[indexPath.row].categoryName : ""
            
            cell.lblTitle.text = listArticleRelated.count != 0 ? listArticleRelated[indexPath.row].title : ""
            
            if listArticleRelated.count != 0 {
                let url = URL(string: listArticleRelated[indexPath.row].image)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCLV1", for: indexPath) as! CellCLV1
            if listDanhSachTin.count != 0 {
                let schedule = listDanhSachTin[indexPath.row].publishedDate
                let timePass = publishedDate(schedule: schedule)
                cell.lblPublished.text = timePass
            } else {
                cell.lblPublished.text = ""
            }
            
            if listDanhSachTin[indexPath.row].isVideoArticle == 1 {
                cell.icVideo.isHidden = false
            }
            
            cell.lblCategory.text = listDanhSachTin.count != 0 ? listDanhSachTin[indexPath.row].categoryName : ""
            
            cell.lblTitle.text = listDanhSachTin.count != 0 ? listDanhSachTin[indexPath.row].title : ""
            
            if listDanhSachTin.count != 0 {
                let url = URL(string: listDanhSachTin[indexPath.row].image)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView.tag == 1 {
            if kind == UICollectionView.elementKindSectionHeader{
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "nativeAdmobCLVCell", for: indexPath) as! nativeAdmobCLVCell
                if let native = self.admobNativeAds {
                    headerView.setupHeader(nativeAd: native)
                }
                return headerView
            }
            return UICollectionReusableView()
        } else {
            return UICollectionReusableView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.tag == 1 {
            if fbNativeAds == nil && admobNativeAds == nil{
                return CGSize(width: DEVICE_WIDTH, height: 0)
            }
            return CGSize(width: DEVICE_WIDTH, height: 145 * scale)
        } else {
            return CGSize(width: DEVICE_WIDTH, height: 0)
        }
    }
}
extension ReadDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listComment.count > 3 {
            self.btnXemThem.isHidden = false
            self.tfMarginTop.constant = scale * 16
            return 3
        } else {
            self.tfMarginTop.constant = 0
            self.btnXemThem.isHidden = true
            return listComment.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellContentComment", for: indexPath) as! CellContentComment
        
        cell.lblName.text = listComment.count != 0 ? listComment[indexPath.row].customerName : ""
        cell.lblContent.text = listComment.count != 0 ? listComment[indexPath.row].content : ""
        cell.countLike.setTitle(" \(listComment[indexPath.row].countLike) thích", for: .normal)
        
        let schedule = listComment.count != 0 ? listComment[indexPath.row].createdDate : ""
        let timePass = publishedDate(schedule: schedule)
        cell.lblPublished.text = timePass
        
        cell.countLike.titleLabel?.text = listComment.count != 0 ? " \(listComment[indexPath.row].countLike) Thích" : ""
        if listComment[indexPath.row].countChild != 0 {
            cell.lblMoreReply.isHidden = false
            cell.btnMoreReplyConstrainTop.constant = scale * 16
            cell.btnMoreReplyConstrainBottom.constant = scale * 16
        } else {
            cell.lblMoreReply.isHidden = true
            cell.btnMoreReplyConstrainTop.constant = scale * -4
            cell.btnMoreReplyConstrainBottom.constant = scale * -4
        }
        
        if listComment.count != 0 {
            DispatchQueue.main.async {
                self.sizeCmt += cell.contentView.bounds.height
                self.listSizeCmt.append(self.sizeCmt)
                if indexPath.row == 2{
                    self.heightTblComment.constant = self.listSizeCmt[2]
                }else if indexPath.row == 1{
                    self.heightTblComment.constant = self.listSizeCmt[1]
                }else if indexPath.row == 0 {
                    self.heightTblComment.constant = self.listSizeCmt[0]
                }
            }
        } else {
            self.heightTblComment.constant = 0
        }
        
        cell.reply.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapbtnReply(_:))))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func tapbtnReply(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: self.tblComment)
        let indexPath = self.tblComment.indexPathForRow(at: location)
        
        print(indexPath!)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReplyCommentVC") as! ReplyCommentVC
        vc.name = listComment[indexPath!.row].customerName
        vc.content = listComment[indexPath!.row].content
        let schedule = listComment.count != 0 ? listComment[indexPath!.row].createdDate : ""
        let timePass = publishedDate(schedule: schedule)
        vc.published = timePass
        vc.countLike = String(listComment[indexPath!.row].countLike)
        vc.idCmt = listComment[indexPath!.row].parentId
        vc.idArticle = chitietTin.id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
