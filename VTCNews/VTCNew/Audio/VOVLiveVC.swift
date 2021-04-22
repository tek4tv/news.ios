//
//  VOVLiveVC.swift
//  VTCNews
//
//  Created by Nguyễn Văn Chiến on 4/14/21.
//

import UIKit
import MediaPlayer


class VOVLiveVC: UIViewController {
    var listImg = ["icVOV1","icVOV2","icVOV3","icVOV4","icVOV5","icVOV6","icVOVGT","icVOVGT"]
    var listTitle = ["Thời sự","Văn hóa - Xã hội","Âm nhạc","Dân tộc","Đối ngoại","Văn học - Nghệ thuật","VOV Giao thông Hà Nội","VOV Giao thông TPHCM"]
    var listLink = ["https://streaming1.vov.vn:8443/audio/vovvn1_vov1.stream_aac/playlist.m3u8",
                    "https://streaming1.vov.vn:8443/audio/vovvn1_vov2.stream_aac/playlist.m3u8",
                    "https://streaming1.vov.vn:8443/audio/vovvn1_vov3.stream_aac/playlist.m3u8",
                    "https://streaming1.vov.vn:8443/audio/vovvn1_vovTTHCM.stream_aac/playlist.m3u8",
                    "https://streaming1.vov.vn:8443/audio/vovvn1_vov5.stream_aac/playlist.m3u8",
                    "https://streaming1.vov.vn:8443/audio/vovvn1_vov2.stream_aac/playlist.m3u8",
                    "https://streaming1.vov.vn:8443/audio/vovvn1_vovGT.stream_aac/playlist.m3u8",
                    "https://5a6872aace0ce.streamlock.net/nghevovgthcm/vovgthcm.stream_aac/playlist.m3u8"]
    var player:AVPlayer!
    var index = -1
    var isPlayVOV = false
    @IBAction func btnPrevious(_ sender: Any) {
        if index > 0 {
            index = index - 1
            playAudio(url: listLink[index])
            imgKenhLive.image = UIImage(named: listImg[index])
            lblKenhLive.text = listTitle[index]
        }
        
    }
    @IBAction func btnNext(_ sender: Any) {
        if index < listLink.count - 1 {
            index = index + 1
            playAudio(url: listLink[index])
            imgKenhLive.image = UIImage(named: listImg[index])
            lblKenhLive.text = listTitle[index]
        }
        
    }
    @IBAction func btnStatus(_ sender: Any) {
        if isPlayVOV {
            self.viewBottom.player?.pause()
            btnStatus.setImage(UIImage(named: "play"), for: .normal)
        } else {
            self.viewBottom.player?.play()
            btnStatus.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlayVOV = !isPlayVOV
    }
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var viewBottom: PlayerView!
    @IBOutlet weak var lblKenhLive: UILabel!
    @IBOutlet weak var imgKenhLive: UIImageView!
    @IBOutlet weak var clv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        viewBottom.isHidden = true
        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "CellKenhLive", bundle: nil), forCellWithReuseIdentifier: "CellKenhLive")
        let layout = UICollectionViewFlowLayout()
        clv.collectionViewLayout = layout
        
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopVOVLive), name: NSNotification.Name("stopVOVLive"), object: nil)
    }
    
    @objc func stopVOVLive(){
        self.viewBottom.player?.pause()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func tapSearch(_ sender: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func playAudio(url:String){
        do {
            try AVAudioSession.sharedInstance()
                .setCategory(AVAudioSession.Category.playback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.player = AVPlayer(url: URL(string: url)!)
        self.viewBottom.player = self.player
        self.viewBottom.player?.play()
    }
    
    
    
}
extension VOVLiveVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellKenhLive", for: indexPath) as! CellKenhLive
        cell.img.image = UIImage(named: listImg[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3 , height: scale * 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        isPlayVOV = true
        viewBottom.isHidden = false
        lblKenhLive.text = listTitle[indexPath.row]
        imgKenhLive.image = UIImage(named: listImg[indexPath.row])
        btnStatus.setImage(UIImage(named: "pause"), for: .normal)
        setupRemoteTransportControls()
        playAudio(url: listLink[indexPath.row])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopAudioRoot"), object: nil)
        setupNowPlaying()
    }
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.previousTrackCommand.isEnabled = false
        commandCenter.playCommand.isEnabled = false
        commandCenter.pauseCommand.isEnabled = false
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            print("Play")
//            if !isPlayVOV {
                playAudio(url: listLink[index])
                btnStatus.setImage(UIImage(named: "pause"), for: .normal)
                
                return .success
//            } else {
//                print("aaa")
//                playAudio(url: listLink[index])
//                btnStatus.setImage(UIImage(named: "pause"), for: .normal)
//
//                return .success
//            }
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            print("pause")
//            if !isPlayVOV {
                viewBottom.player?.pause()
                btnStatus.setImage(UIImage(named: "play"), for: .normal)
                
                return .success
//            } else {
//                viewBottom.player?.pause()
//                btnStatus.setImage(UIImage(named: "play"), for: .normal)
//
//                return .success
//            }
        }
        
//        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
//            print("Next")
//            if index == listTitle.count - 1 {
//                return .commandFailed
//            } else {
//                index = index + 1
//            }
//            print(index)
//            playAudio(url: listLink[index])
//            lblKenhLive.text = listTitle[index]
//            imgKenhLive.image = UIImage(named: listImg[index])
//            setupNowPlaying()
//            return .commandFailed
//        }
//
//        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
//            if index == 0 {
//                return .commandFailed
//            } else {
//                index = index - 1
//            }
//            print(index)
//            playAudio(url: listLink[index])
//            lblKenhLive.text = listTitle[index]
//            imgKenhLive.image = UIImage(named: listImg[index])
//            setupNowPlaying()
//            return .commandFailed
//        }
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = listTitle[index]
        
        if let image = UIImage(named: listImg[index]) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
extension VOVLiveVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = false
        commandCenter.pauseCommand.isEnabled = false
        return true
    }
}
