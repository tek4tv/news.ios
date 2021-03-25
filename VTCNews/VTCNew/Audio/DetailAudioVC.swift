import UIKit

class DetailAudioVC: UIViewController {
    var id:Int = 0
    
    var listData = [ModelAlbumDetail]()
    var name:String = ""
    var des:String = ""
    var chanelID:Int = 0
    var image:String = ""
    var countMoreAudio = 0
    var countItem = 0
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var tbl: UITableView!
    
    func navigationTop(){
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
        menuBtnRight.setImage(UIImage(named:"iconShareAudioDetail"), for: .normal)
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(id: id)
        navigationTop()
        
        
        tbl.register(UINib(nibName: "CellDetailAudio", bundle: nil), forCellReuseIdentifier: "CellDetailAudio")
        tbl.register(UINib(nibName: "CellMoreAudio", bundle: nil), forCellReuseIdentifier: "CellMoreAudio")
        
        tbl.delegate = self
        tbl.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAudio(_:)), name: NSNotification.Name("reloadAudio"), object: nil)
        
    }
    
    
    @objc func reloadAudio(_ notification: Notification){
        let id = (notification.userInfo?["id"] as? Int)!
        let topRow = IndexPath(row: 0,
                               section: 0)
        self.tbl.scrollToRow(at: topRow,
                             at: .top,
                             animated: true)
        getData(id: id)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func getData(id: Int){
        APIService.shared.getAlbumDetail(id: id) {
            (response, name, des, chanelID, image, countItem, error) in
            if let rs = response {
                self.listData = rs
            }
            if name != nil {
                self.name = name!
            }
            if des != nil {
                self.des = des!
            }
            if chanelID != nil {
                self.chanelID = chanelID!
            }
            if image != nil {
                self.image = image!
            }
            if countItem != nil {
                self.countItem = countItem!
            }
            
            DispatchQueue.main.async {
                self.tbl.reloadData()
            }
        }
    }
}

extension DetailAudioVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SectionDetailAudio(rawValue: section) else {
            return 0
        }
        switch section {
        case .Detail:
            return 1
        case .More:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionDetailAudio(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
        case .Detail:
            let cell = tbl.dequeueReusableCell(withIdentifier: "CellDetailAudio", for: indexPath) as! CellDetailAudio
            if let url = URL(string: image){
                cell.img.loadImage(fromURL: url)
            }
            cell.lblTitle.text = name
            cell.lblDes.text = des
            cell.listData = self.listData
            return cell
        case .More:
            let cell = tbl.dequeueReusableCell(withIdentifier: "CellMoreAudio", for: indexPath) as! CellMoreAudio
            cell.id = chanelID
            countMoreAudio = cell.listData.count
            return cell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionDetailAudio(rawValue: indexPath.section) else { return 0}
        switch section {
        case .Detail:
            return scale * 900
        case .More:
            var a = 0
            if Double(countMoreAudio/2)<Double(countMoreAudio)/2.0{
                a = Int(countMoreAudio/2)+1
            } else {
                a = Int(countMoreAudio/2)
            }
//            return CGFloat(a) * scale * 210 + CGFloat(countMoreAudio/2)*scale*10 + scale*270
            return scale * 600
        }
    }
    
}

enum SectionDetailAudio: Int{
    case Detail = 0
    case More = 1
}
