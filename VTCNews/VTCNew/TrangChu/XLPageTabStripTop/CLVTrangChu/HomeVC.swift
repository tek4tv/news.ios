//
//  HomeVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/28/21.
//

import UIKit
import SideMenu
import Toast_Swift

class HomeVC: UIViewController {
    var idArticle = 0 {
        didSet{
            print("idArticle: \(idArticle)")
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    private let refreshControl = UIRefreshControl()

    
    @IBOutlet weak var imgHeaderArtilce: UIImageView!
    @IBOutlet weak var lblTitleHeaderArticle: UILabel!
    @IBOutlet weak var lblPublisherHeaderArticle: UILabel!
    @IBOutlet weak var lblCategoryHeaderArticle: UILabel!
    @IBOutlet weak var icVideoHeaderArticle: UIImageView!
    
    @IBOutlet weak var clvHotArticle: UICollectionView!
    
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var icPlayVideo: UIImageView!
    @IBOutlet weak var lblTitleVideo: UILabel!
    @IBOutlet weak var clvVideo: UICollectionView!
    @IBAction func btnMoreVideo(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VisitTabVideo"), object: nil)
    }
    
    @IBOutlet weak var icPlayAudio: UIImageView!
    @IBOutlet weak var imgAudio: UIImageView!
    @IBOutlet weak var lblTitleAudio: UILabel!
    @IBOutlet weak var imgCategoryAudio: UIImageView!
    @IBOutlet weak var clvAudio: UICollectionView!
    @IBAction func btnMoreAudio(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VisitTabAudio"), object: nil)
    }
    
    @IBOutlet weak var clvArticleHome: UICollectionView!
    @IBOutlet weak var clvSuggesttionHome1: UICollectionView!
    @IBOutlet weak var clvSuggesttionHome2: UICollectionView!
    @IBOutlet weak var clvSuggestionHome3: UICollectionView!
    
    @IBOutlet weak var heightClvArticleHome: NSLayoutConstraint!
    @IBOutlet weak var heightClvSuggestionHome1: NSLayoutConstraint!
    @IBOutlet weak var heightClvVideo: NSLayoutConstraint!
    @IBOutlet weak var heightClvSuggestionHome2: NSLayoutConstraint!
    @IBOutlet weak var heightClvAudio: NSLayoutConstraint!
    @IBOutlet weak var heightClvSuggestionHome3: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var viewIcHome: UIView!
    var listMenuShow = [ModelMenu]()
    
    var listArticle = [ModelArticleHot]()
    var listSugestionHome = [ModelSuggestionHome]()
    var listSachNoi = [ModelSachNoi]()
    var listSugestionHome0 = [ModelSuggestionHome]()
    var listSugestionHome1 = [ModelSuggestionHome]()
    var listSugestionHome2 = [ModelSuggestionHome]()
    var listChanelHot = [ModelChanelHot]()
    var listVideoHome = [ModelVideoHome]()
    var listAmNhac = [ModelAmNhac]()
    var listPodCast = [ModelPodCast]()

    //conect outlet Collectionview
    @IBOutlet weak var clvTabMenu: UICollectionView!
    
    @objc func tapSideMenu(_ sender: UITapGestureRecognizer){
        let menu = storyboard?.instantiateViewController(withIdentifier: "leftMenu") as! SideMenuNavigationController
        menu.menuWidth = scaleW * 350
        menu.navigationBar.isHidden = true
        menu.presentationStyle = .menuSlideIn
        present(menu, animated: true, completion: nil)
    }
    
    @objc func tapHeaderArticle(_ sender: UITapGestureRecognizer){
        if listArticle[0].isVideoArticle == 1 {
            var dataVideo = [ModelVideoDetail]()
            APIService.shared.getVideoDetail(id: self.listArticle[0].id){
                (response, error) in
                if let rs = response {
                    dataVideo = rs
                }
                
                if dataVideo.count != 0 {
                    let schedule = self.listArticle[0].publishedDate
                    let timePass = publishedDate(schedule: schedule)
                    NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listArticle[0].categoryName, "id":self.listArticle[0].id,"name":self.listArticle[0].title,"published":timePass,"des":self.listArticle[0].descriptionField,"cateID":self.listArticle[0].categoryId])
                } else {
                    self.navigationController?.view.makeToast("Video bị lỗi")
                }
            }
            
            
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
            self.navigationController?.pushViewController(vc, animated: true)
            vc.id = listArticle[0].id
        }
    }
    
    @objc func tapPlayVideo(_ sender: UITapGestureRecognizer){
        APIService.shared.getVideoDetail(id: self.listVideoHome[0].id){
            (response, error) in
            
            var dataVideo = [ModelVideoDetail]()

            if let rs = response {
                dataVideo = rs
            }
            
            if dataVideo.count != 0 {
                let schedule = self.listVideoHome[0].publishedDate
                let timePass = publishedDate(schedule: schedule)
                NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listVideoHome[0].categoryName, "id":self.listVideoHome[0].id,"name":self.listVideoHome[0].title,"published":timePass,"des":self.listVideoHome[0].descriptionField,"cateID":self.listVideoHome[0].categoryId])
            } else {
                self.navigationController?.view.makeToast("Video bị lỗi")
            }
        }
    }
    
    
    @objc func tapPlayAudio(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
        vc.id = listSachNoi[0].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        getDataArticleHot()
        getSuggestionHome()
        getSachNoi()
        getAmNhac()
        getPodcast()
        getDataChanelHot()
        getVideoHome()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.refreshControl.endRefreshing()
        }
    }
    @objc func openDetail(_ sender: Notification){
        let id = sender.userInfo?["id"] as! Int
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
        vc.id = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("callAppdelegate"), object: nil)
    }
    @objc func listener(_ sender: Notification){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
        vc.id = idGloba
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(openDetail(_:)), name: NSNotification.Name("openDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(listener(_:)), name: NSNotification.Name("openReadDetail"), object: nil)
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
            scrollView.alwaysBounceVertical = true
        scrollView.refreshControl = refreshControl

        clvTabMenu.delegate = self
        clvTabMenu.dataSource = self
        clvArticleHome.delegate = self
        clvArticleHome.dataSource = self
        clvHotArticle.delegate = self
        clvHotArticle.dataSource = self
        clvSuggesttionHome1.delegate = self
        clvSuggesttionHome1.dataSource = self
        clvVideo.delegate = self
        clvVideo.dataSource = self
        clvSuggesttionHome2.delegate = self
        clvSuggesttionHome2.dataSource = self
        clvAudio.delegate = self
        clvAudio.dataSource = self
        clvSuggestionHome3.delegate = self
        clvSuggestionHome3.dataSource = self
        clvHotArticle.isScrollEnabled = false
        
        imgHeaderArtilce.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeaderArticle(_:))))
        lblTitleHeaderArticle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeaderArticle(_:))))
        lblCategoryHeaderArticle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeaderArticle(_:))))
        lblPublisherHeaderArticle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeaderArticle(_:))))
        
        imgVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPlayVideo(_:))))
        lblTitleVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPlayVideo(_:))))
        
        imgAudio.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPlayAudio(_:))))
        lblTitleAudio.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPlayAudio(_:))))
        imgCategoryAudio.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPlayAudio(_:))))
        
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#a3151d")
        navigationController?.navigationBar.isTranslucent = false
        
        //setLogo
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
        
        //settup leftBarbutton item
        let menuBtnLeft = UIButton(type: .custom)
        menuBtnLeft.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtnLeft.setImage(UIImage(named:"icMenu"), for: .normal)
        //            menuBtn.addTarget(self, action: #selector(vc.onMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let menuBarItemLeft = UIBarButtonItem(customView: menuBtnLeft)
        menuBarItemLeft.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItemLeft.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItemLeft
        
        //setup rightbarbutton item
        let menuBtnRight = UIButton(type: .custom)
        menuBtnRight.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtnRight.setImage(UIImage(named:"icSearch"), for: .normal)
        //            menuBtn.addTarget(self, action: #selector(vc.onMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let menuBarItemRight = UIBarButtonItem(customView: menuBtnRight)
        menuBarItemRight.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItemRight.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItemRight
        
        
        menuBtnLeft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSideMenu(_:))))
        
        
        registerLayout()
        registerTabMenu()
        registerMain()
        
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .horizontal
        layout1.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        clvTabMenu.collectionViewLayout = layout1
        
        
        getDataArticleHot()
        getSuggestionHome()
        getSachNoi()
        getAmNhac()
        getPodcast()
        getDataChanelHot()
        getVideoHome()
        
        for i in listMenu {
            if i.orderMobile > 0 && i.parentID! == 0  {
                listMenuShow.append(i)
            }
        }
        heightClvAudio.constant = 3 * scale * 165 + scale*80
        heightClvVideo.constant = 2 * scale * 210 + scale*110
        menuBtnRight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSearch(_:))))
    }
    
    @objc func tapSearch(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.present(vc, animated: true, completion: nil)
    }
    func getDataArticleHot(){
        APIService.shared.getArticleHot() { (response, error) in
            if let rs = response {
                self.listArticle = rs
                DispatchQueue.main.async {
                    if self.listArticle[0].isVideoArticle == 1 {
                        self.icVideoHeaderArticle.isHidden = false
                    } else {
                        self.icVideoHeaderArticle.isHidden = true
                    }
                    let schedule = self.listArticle[0].publishedDate
                    let timePass = publishedDate(schedule: schedule)
                    self.lblPublisherHeaderArticle.text = timePass
                    
                    self.lblCategoryHeaderArticle.text = self.listArticle[0].categoryName
                    
                    self.lblTitleHeaderArticle.text = self.listArticle[0].title

                    if let url = URL(string: self.listArticle[0].image169Large){
                        self.imgHeaderArtilce.kf.setImage(with: url)
                    }
                    self.heightClvArticleHome.constant = CGFloat(self.listArticle.count-1) * scale * 135
                    self.clvArticleHome.reloadData()
                }
            }
        }
    }
    
    func getDataChanelHot(){
        APIService.shared.getChanelHot() { (response, error) in
            if let rs = response {
                self.listChanelHot = rs
                DispatchQueue.main.async {
                    self.clvHotArticle.reloadData()
                }
            }
        }
    }
    
    func getSuggestionHome(){
        APIService.shared.getSuggestionHome() { (response, error) in
            if let rs = response {
                self.listSugestionHome = rs
                DispatchQueue.main.async {
                    for i in 0...2 {
                        self.listSugestionHome0.append(self.listSugestionHome[i])
                        self.clvSuggesttionHome1.reloadData()
                    }
                    
                    for i in 3...5 {
                        self.listSugestionHome1.append(self.listSugestionHome[i])
                        self.clvSuggesttionHome2.reloadData()
                    }
                    
                    for i in 6...self.listSugestionHome.count-1 {
                        self.listSugestionHome2.append(self.listSugestionHome[i])
                        self.clvSuggestionHome3.reloadData()
                    }
                    
                    self.heightClvSuggestionHome1.constant = CGFloat(self.listSugestionHome0.count) * scale * 135
                    self.heightClvSuggestionHome2.constant = CGFloat(self.listSugestionHome1.count) * scale * 135
                    self.heightClvSuggestionHome3.constant = CGFloat(self.listSugestionHome2.count) * scale * 135
                }
            }
        }
    }
    
    func getSachNoi(){
        APIService.shared.getSachNoi() { (response, error) in
            if let rs = response {
                self.listSachNoi = rs
                DispatchQueue.main.async {
                    self.lblTitleAudio.text = self.listSachNoi[0].name
                    let url = URL(string: self.listSachNoi[0].image182182)
                    self.imgAudio.kf.setImage(with: url)
                    self.clvAudio.reloadData()
                }
            }
        }
    }
    
    func getVideoHome(){
        APIService.shared.getVideoHome() { (response, error) in
            if let rs = response {
                self.listVideoHome = rs
                DispatchQueue.main.async {
                    self.imgVideo.kf.setImage(with: URL(string: self.listVideoHome[0].image169Large))
                    self.lblTitleVideo.text = self.listVideoHome[0].title
                    self.clvVideo.reloadData()
                }
            }
        }
    }
    
    
    func getAmNhac(){
        APIService.shared.getAmNhacVietNam() { (response, error) in
            if let rs = response {
                self.listAmNhac = rs
                DispatchQueue.main.async {
                    self.clvAudio.reloadData()
                }
            }
        }
    }
    
    func getPodcast(){
        APIService.shared.getPodcast() { (response, error) in
            if let rs = response {
                self.listPodCast = rs
                DispatchQueue.main.async {
                    self.clvAudio.reloadData()
                }
            }
        }
    }
    
    func registerTabMenu(){
        clvTabMenu.register(UINib(nibName: "CellMenuText", bundle: nil), forCellWithReuseIdentifier: "CellMenuText")
    }
    
    func registerMain(){
        clvArticleHome.register(UINib(nibName: "CellCLV1", bundle: nil), forCellWithReuseIdentifier: "CellCLV1")
        clvHotArticle.register(UINib(nibName: "CellChanelHot", bundle: nil), forCellWithReuseIdentifier: "CellChanelHot")
        clvSuggestionHome3.register(UINib(nibName: "CellCLV1", bundle: nil), forCellWithReuseIdentifier: "CellCLV1")
        clvSuggesttionHome1.register(UINib(nibName: "CellCLV1", bundle: nil), forCellWithReuseIdentifier: "CellCLV1")
        clvSuggesttionHome2.register(UINib(nibName: "CellCLV1", bundle: nil), forCellWithReuseIdentifier: "CellCLV1")
        clvVideo.register(UINib(nibName: "CellContenVideoHome", bundle: nil), forCellWithReuseIdentifier: "CellContenVideoHome")
        clvAudio.register(UINib(nibName: "CellContentAudio", bundle: nil), forCellWithReuseIdentifier: "CellContentAudio")
    }
    
    func registerLayout(){
        let layoutclvArticleHome = UICollectionViewFlowLayout()
        clvArticleHome.collectionViewLayout = layoutclvArticleHome
        
        let layoutclvHotArticle = UICollectionViewFlowLayout()
        clvHotArticle.collectionViewLayout = layoutclvHotArticle
        
        let layoutclvSuggestionHome3 = UICollectionViewFlowLayout()
        clvSuggestionHome3.collectionViewLayout = layoutclvSuggestionHome3
        
        let layoutclvSuggesttionHome1 = UICollectionViewFlowLayout()
        clvSuggesttionHome1.collectionViewLayout = layoutclvSuggesttionHome1
        
        let layoutclvSuggesttionHome2 = UICollectionViewFlowLayout()
        clvSuggesttionHome2.collectionViewLayout = layoutclvSuggesttionHome2
        
        let layoutclvVideo = UICollectionViewFlowLayout()
        clvVideo.collectionViewLayout = layoutclvVideo
        
        let layoutclvAudio = UICollectionViewFlowLayout()
        clvAudio.collectionViewLayout = layoutclvAudio

    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellMenuText", for: indexPath) as! CellMenuText
            cell.lbl.text = listMenuShow[indexPath.row].title
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCLV1", for: indexPath) as! CellCLV1
            if listArticle.count != 0 {
                if listArticle[indexPath.row+1].isVideoArticle == 1 {
                    cell.icVideo.isHidden = false
                } else {
                    cell.icVideo.isHidden = true
                }
                
                if listArticle.count != 0 {
                    let schedule = listArticle[indexPath.row+1].publishedDate
                    let timePass = publishedDate(schedule: schedule)
                    cell.lblPublished.text = timePass
                } else {
                    cell.lblPublished.text = ""
                }
                
                cell.lblCategory.text = listArticle.count != 0 ? listArticle[indexPath.row+1].categoryName : ""
                
                cell.lblTitle.text = listArticle[indexPath.row+1].title
                
                if let url = URL(string: listArticle[indexPath.row+1].image169Large){
                    cell.img.kf.setImage(with: url)
                }
            }
           
      
            return cell
        } else if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellChanelHot", for: indexPath) as! CellChanelHot
            cell.lblTitle.text = listChanelHot[indexPath.row].title
            
            if let url = URL(string: listChanelHot[indexPath.row].image169){
                cell.img.kf.setImage(with: url)
            }
            
            return cell
        } else if collectionView.tag == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCLV1", for: indexPath) as! CellCLV1
            if listSugestionHome0[indexPath.row].isVideoArticle == 1 {
                cell.icVideo.isHidden = false
            } else {
                cell.icVideo.isHidden = true
            }
            if listSugestionHome0.count != 0 {
                let schedule = listSugestionHome0[indexPath.row].publishedDate
                let timePass = publishedDate(schedule: schedule)
                cell.lblPublished.text = timePass
            } else {
                cell.lblPublished.text = ""
            }
            
            cell.lblCategory.text = listSugestionHome0.count != 0 ? listSugestionHome0[indexPath.row].categoryName : ""
            
            cell.lblTitle.text = listSugestionHome0[indexPath.row].title
            
            if listSugestionHome0.count != 0 {
                let url = URL(string: listSugestionHome0[indexPath.row].image169)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
            return cell
        } else if collectionView.tag == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellContenVideoHome", for: indexPath) as! CellContenVideoHome
            if listVideoHome.count != 0 {
                cell.lblTitle.font = cell.lblTitle.font.withSize(15)
                
                if listVideoHome.count != 0 {
                    cell.lblTitle.text = listVideoHome[indexPath.row+1].title
                    let url = URL(string: listVideoHome[indexPath.row + 1].image169Large)
                    cell.img.kf.setImage(with: url){ result in
                        cell.img.stopSkeletonAnimation()
                        cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                    }
                } else {
                    cell.img.isSkeletonable = true
                    cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
                }
            }
            return cell
        } else if collectionView.tag == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCLV1", for: indexPath) as! CellCLV1
            if listSugestionHome1[indexPath.row].isVideoArticle == 1 {
                cell.icVideo.isHidden = false
            } else {
                cell.icVideo.isHidden = true
            }
            if listSugestionHome1.count != 0 {
                let schedule = listSugestionHome1[indexPath.row].publishedDate
                let timePass = publishedDate(schedule: schedule)
                cell.lblPublished.text = timePass
            } else {
                cell.lblPublished.text = ""
            }
            
            cell.lblCategory.text = listArticle.count != 0 ? listSugestionHome1[indexPath.row].categoryName : ""
            
            cell.lblTitle.text = listSugestionHome1[indexPath.row].title
            
            if listSugestionHome1.count != 0 {
                let url = URL(string: listSugestionHome1[indexPath.row].image169)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
            return cell
        } else if collectionView.tag == 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellContentAudio", for: indexPath) as! CellContentAudio
            switch indexPath.row {
            case 0:
                cell.lblTitle.text = listAmNhac.count != 0 ? listAmNhac[2].name : ""
                if listAmNhac.count != 0 {
                    let url = URL(string: listAmNhac[2].image182182)
                    cell.img.kf.setImage(with: url){ result in
                        cell.img.stopSkeletonAnimation()
                        cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                    }
                } else {
                    cell.img.isSkeletonable = true
                    cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
                }
                cell.imgType.image = UIImage(named: "imgAmNhac")
            case 1:
                cell.lblTitle.text = listSachNoi.count != 0 ? listSachNoi[2].name : ""
                if listSachNoi.count != 0 {
                    let url = URL(string: listSachNoi[2].image182182)
                    cell.img.kf.setImage(with: url){ result in
                        cell.img.stopSkeletonAnimation()
                        cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                    }
                } else {
                    cell.img.isSkeletonable = true
                    cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)            }
                cell.imgType.image = UIImage(named: "imgSachNoi")
            default:
                cell.lblTitle.text = listPodCast.count != 0 ? listPodCast[1].name : ""
                if listPodCast.count != 0 {
                    let url = URL(string: listPodCast[1].image182182)
                    cell.img.kf.setImage(with: url){ result in
                        cell.img.stopSkeletonAnimation()
                        cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                    }
                } else {
                    cell.img.isSkeletonable = true
                    cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
                }
                cell.imgType.image = UIImage(named: "imgPodcast")
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCLV1", for: indexPath) as! CellCLV1
            if listSugestionHome2[indexPath.row].isVideoArticle == 1 {
                cell.icVideo.isHidden = false
            } else {
                cell.icVideo.isHidden = true
            }
            if listSugestionHome2.count != 0 {
                let schedule = listSugestionHome2[indexPath.row].publishedDate
                let timePass = publishedDate(schedule: schedule)
                cell.lblPublished.text = timePass
            } else {
                cell.lblPublished.text = ""
            }
            
            cell.lblCategory.text = listArticle.count != 0 ? listSugestionHome2[indexPath.row].categoryName : ""
            
            cell.lblTitle.text = listSugestionHome2[indexPath.row].title
            
            if listSugestionHome2.count != 0 {
                let url = URL(string: listSugestionHome2[indexPath.row].image169)
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
    
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return listMenuShow.count
        } else if collectionView.tag == 1 {
            return listArticle.count-1
        }else if collectionView.tag == 2 {
            return listChanelHot.count
        }else if collectionView.tag == 3 {
            return listSugestionHome0.count
        }else if collectionView.tag == 4 {
            return 4
        }else if collectionView.tag == 5 {
            return listSugestionHome1.count
        }else if collectionView.tag == 6 {
            return 3
        }else {
            return listSugestionHome2.count
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildrenTabMenuVC") as! ChildrenTabMenuVC
            vc.id = listMenuShow[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        } else if collectionView.tag == 1 {
            if listArticle[indexPath.row+1].isVideoArticle == 1 {
                var dataVideo = [ModelVideoDetail]()
                APIService.shared.getVideoDetail(id: self.listArticle[indexPath.row+1].id){
                    (response, error) in
                    if let rs = response {
                        dataVideo = rs
                    }
                    
                    if dataVideo.count != 0 {
                        let schedule = self.listArticle[indexPath.row+1].publishedDate
                        let timePass = publishedDate(schedule: schedule)
                        NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listArticle[indexPath.row+1].categoryName, "id":self.listArticle[indexPath.row+1].id,"name":self.listArticle[indexPath.row+1].title,"published":timePass,"des":self.listArticle[indexPath.row+1].descriptionField,"cateID":self.listArticle[indexPath.row+1].categoryId])
                    } else {
                        self.navigationController?.view.makeToast("Video bị lỗi")
                    }
                }
                
                
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
                self.navigationController?.pushViewController(vc, animated: true)
                vc.id = listArticle[indexPath.row+1].id
            }
        } else if collectionView.tag == 2 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChannelHotVC") as! ChannelHotVC
            vc.id = listChanelHot[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        } else if collectionView.tag == 3 {
            if listSugestionHome0[indexPath.row].isVideoArticle == 1 {
                var dataVideo = [ModelVideoDetail]()
                APIService.shared.getVideoDetail(id: self.listSugestionHome[indexPath.row].id){
                    (response, error) in
                    if let rs = response {
                        dataVideo = rs
                    }
                    
                    if dataVideo.count != 0 {
                        let schedule = self.listSugestionHome0[indexPath.row].publishedDate
                        let timePass = publishedDate(schedule: schedule)
                        NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listSugestionHome0[indexPath.row].categoryName, "id":self.listSugestionHome0[indexPath.row].id,"name":self.listSugestionHome0[indexPath.row].title,"published":timePass,"des":self.listSugestionHome0[indexPath.row].descriptionField,"cateID":self.listSugestionHome0[indexPath.row].categoryId])
                    } else {
                        self.navigationController?.view.makeToast("Video bị lỗi")
                    }
                }
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
                self.navigationController?.pushViewController(vc, animated: true)
                vc.id = listSugestionHome[indexPath.row].id
            }
        } else if collectionView.tag == 4 {
            APIService.shared.getVideoDetail(id: self.listVideoHome[indexPath.row+1].id){
                (response, error) in
                
                var dataVideo = [ModelVideoDetail]()

                if let rs = response {
                    dataVideo = rs
                }
                
                if dataVideo.count != 0 {
                    let schedule = self.listVideoHome[indexPath.row+1].publishedDate
                    let timePass = publishedDate(schedule: schedule)
                    NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listVideoHome[indexPath.row+1].categoryName, "id":self.listVideoHome[indexPath.row+1].id,"name":self.listVideoHome[indexPath.row+1].title,"published":timePass,"des":self.listVideoHome[indexPath.row+1].descriptionField,"cateID":self.listVideoHome[indexPath.row+1].categoryId])
                } else {
                    self.navigationController?.view.makeToast("Video bị lỗi")
                }
            }
        } else if collectionView.tag == 5 {
            if listSugestionHome1[indexPath.row].isVideoArticle == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
                self.navigationController?.pushViewController(vc, animated: true)
                vc.id = listSugestionHome1[indexPath.row].id
                
            } else {
                var dataVideo = [ModelVideoDetail]()
                APIService.shared.getVideoDetail(id: self.listSugestionHome1[indexPath.row].id){
                    (response, error) in
                    if let rs = response {
                        dataVideo = rs
                    }
                    
                    if dataVideo.count != 0 {
                        let schedule = self.listSugestionHome1[indexPath.row].publishedDate
                        let timePass = publishedDate(schedule: schedule)
                        NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listSugestionHome1[indexPath.row].categoryName, "id":self.listSugestionHome1[indexPath.row].id,"name":self.listSugestionHome1[indexPath.row].title,"published":timePass,"des":self.listSugestionHome1[indexPath.row].descriptionField,"cateID":self.listSugestionHome1[indexPath.row].categoryId])
                    } else {
                        self.navigationController?.view.makeToast("Video bị lỗi")
                    }
                }
            }
        } else if collectionView.tag == 6 {
            var id = 0
            switch indexPath.row {
            case 0:
                id = listAmNhac[2].id
            case 1:
                id = listSachNoi[2].id
            default:
                id = listPodCast[1].id
            }
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAudioVC") as! DetailAudioVC
            vc.id = id
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if listSugestionHome2[indexPath.row].isVideoArticle == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
                vc.id = listSugestionHome2[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)

            } else {
                var dataVideo = [ModelVideoDetail]()
                APIService.shared.getVideoDetail(id: self.listSugestionHome2[indexPath.row].id){
                    (response, error) in
                    if let rs = response {
                        dataVideo = rs
                    }
                    
                    if dataVideo.count != 0 {
                        let schedule = self.listSugestionHome2[indexPath.row].publishedDate
                        let timePass = publishedDate(schedule: schedule)
                        NotificationCenter.default.post(name: Notification.Name("openVideo"), object: nil, userInfo: ["category":self.listSugestionHome2[indexPath.row].categoryName, "id":self.listSugestionHome2[indexPath.row].id,"name":self.listSugestionHome2[indexPath.row].title,"published":timePass,"des":self.listSugestionHome2[indexPath.row].descriptionField,"cateID":self.listSugestionHome2[indexPath.row].categoryId])
                    } else {
                        self.navigationController?.view.makeToast("Video bị lỗi")
                    }
                }
            }
        }
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellMenuText", for: indexPath) as! CellMenuText
            return CGSize(width: cell.lbl.frame.width, height: clvTabMenu.frame.height)
        } else if collectionView.tag == 1 {
            return CGSize(width: UIScreen.main.bounds.width, height: scale * 135)
        } else if collectionView.tag == 2 {
            return CGSize(width: (clvHotArticle.bounds.width - scale*30)/2, height: scale * 220)
        } else if collectionView.tag == 3 {
            return CGSize(width: UIScreen.main.bounds.width, height: scale * 135)
        } else if collectionView.tag == 4 {
            return CGSize(width: (clvVideo.bounds.width - scale*35)/2 , height: scale * 210)
        } else if collectionView.tag == 5 {
            return CGSize(width: UIScreen.main.bounds.width, height: scale * 135)
        } else if collectionView.tag == 6 {
            return CGSize(width: UIScreen.main.bounds.width, height: scale * 165)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: scale * 135)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 10
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0 {
            return UIEdgeInsets(top: 0, left: scale * 8, bottom: 0, right: scale * 8)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}




