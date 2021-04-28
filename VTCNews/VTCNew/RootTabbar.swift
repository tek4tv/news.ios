//
//  HomeVC.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 1/25/21.
//

import UIKit
import MarqueeLabel
import Kingfisher
import AVKit
import Toast_Swift
import MediaPlayer

var isPlayingVideo = false

class RootTabbar: UITabBarController {
    
    var idNoti = 0 {
        didSet{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ReadDetailVC") as! ReadDetailVC
            vc.id = idNoti
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    var nameMFCenter = ""
    
    @IBAction func btnSearch(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewSearch") as! WebviewSearch
        self.present(vc, animated: true, completion: nil)
        self.viewVideoPlaying.player?.pause()
        self.btnPlayPauseVideo.setImage(UIImage(named: "icPlay"), for: .normal)
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.viewVideo.isHidden = true
        self.viewVideoPlaying.player?.pause()
    }
    
    //get InfoVideo
    var categoryName = ""
    var nameVideo = ""
    var published = ""
    var des = ""
    var cateID = 0
    
    var audioPlayer: AudioPlayer!
    var listData = [ModelAlbumDetail]()
    var index: Int = 0
    var url = ""
    var listVideoMore = [ModelDanhSachTin]()
    
    var timeObserver: Any?
    
    //viewPlayVideo
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!{
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    
    @IBOutlet var viewVideo: UIView!
    @IBOutlet weak var viewVideoPlaying: PlayerView!
    @IBOutlet weak var clvMoreVideo: UICollectionView!
    @IBOutlet weak var topViewPlaying: NSLayoutConstraint!
    @IBOutlet weak var widthViewPlaying: NSLayoutConstraint!
    @IBOutlet weak var btnFullScreen: UIButton!
    @IBOutlet weak var viewNav: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var subViewVideoPlaying: UIView!
    @IBOutlet weak var btnPlayPauseVideo: UIButton!
    @IBAction func btnFullSc(_ sender: Any) {
        self.viewVideoPlaying.player?.pause()
        
        let newPlayer = self.viewVideoPlaying.player
        self.viewVideoPlaying.player = nil
        let vc = PlayerViewController()
        
        vc.player = newPlayer
        
        present(vc, animated: true) {
            vc.player?.play()
            vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
        }
        vc.onDismiss = {[weak self] in
            self?.viewVideoPlaying.player = vc.player
            vc.player = nil
            self?.viewVideoPlaying.player?.play()
            //                    self?.isPlaying = true
            //                    self?.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-48"), for: .normal)
            if let window = UIApplication.shared.keyWindow {
                window.addSubview(self!.viewVideo)
            }
        }
    }
    @IBOutlet weak var lblTimeVideo: UILabel!
    @IBOutlet weak var lblTimeRun: UILabel!
    @IBAction func slider(_ sender: UISlider) {
        //Tua video
        isSliderChanging = true
        viewVideoPlaying.player?.pause()
        isPlayingVideo = false
        if let timeObserver = timeObserver {
            viewVideoPlaying.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        viewVideoPlaying.player?.seek(to: CMTimeMake(value: Int64(sender.value) * 1000, timescale: 1000), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    func getTimeString(from time: CMTime) -> String{
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds / 60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0{
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else{
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    func addTimeObserver(){
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        timeObserver = viewVideoPlaying.player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {[weak self] (time) in
            guard let currentItem = self?.viewVideoPlaying.player?.currentItem, currentItem.duration >= CMTime.zero else {return}
            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
            self?.slider.maximumValue =  (Float(currentItem.duration.seconds) > 0) ? Float(currentItem.duration.seconds) : 0
            self?.slider.minimumValue = 0
            self?.slider.value = Float(currentItem.currentTime().seconds)
            self?.lblTimeRun.text = self?.getTimeString(from: currentItem.currentTime())
        })
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges", viewVideoPlaying != nil, let duration = viewVideoPlaying.player?.currentItem?.duration.seconds, duration > 0.0{
            self.lblTimeVideo.text = getTimeString(from: (viewVideoPlaying.player?.currentItem!.duration)!)
        }
        
        if keyPath == "timeControlStatus"{
            if (viewVideoPlaying.player?.timeControlStatus == .playing) {
                activityIndicatorView.stopAnimating()
                //player is playing
            }
            else if (viewVideoPlaying.player?.timeControlStatus == .paused) {
                
                //player is pause
            }
            else if (viewVideoPlaying.player?.timeControlStatus == .waitingToPlayAtSpecifiedRate) {
                //player is waiting to play
                activityIndicatorView.startAnimating()
                
            }
        }
        
    }
    let btnCloseVideo:UIButton = UIButton()
    let btnPlayStopVideo:UIButton = UIButton()
    let lblName:MarqueeLabel = MarqueeLabel()
    
    
    var dataVideo = [ModelVideoDetail]()
    var player:AVPlayer!
    func getVideo(id:Int){
        APIService.shared.getVideoDetail(id: id){
            (response, error) in
            if let rs = response {
                self.dataVideo = rs
            }
            if self.dataVideo.count != 0 {
                self.player = AVPlayer(url: URL(string: "https://media.vtc.vn\(self.dataVideo[0].videoURL)")!)
                self.viewVideoPlaying.player = self.player
                self.viewVideoPlaying.player?.play()
                self.viewVideoPlaying.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
                self.viewVideoPlaying.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
                self.addTimeObserver()
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
            } else {
                self.navigationController?.view.makeToast("Video bị lỗi")
            }
        }
    }
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        AdmobManager.shared.loadAdFull(inVC: self)
    }
    @IBAction func btnBackNav(_ sender: Any) {
        self.viewVideoPlaying.player?.pause()
        viewVideo.isHidden = true
    }
    @IBAction func btnSearchNav(_ sender: Any) {
        
    }
    
    //ViewPlayAudio
    @IBOutlet weak var btnPlayStop: UIButton!
    @IBAction func tapDelAudio(_ sender: Any) {
        viewAudio.isHidden = true
        audioPlayer.stopAudio()
        UIApplication.shared.endReceivingRemoteControlEvents()
                MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
    @IBAction func tapNextAudio(_ sender: Any) {
        if index == listData.count - 1 {
            return
        } else {
            index = index + 1
        }
        if listData[index].fileUrl.contains("http"){
            url = listData[index].fileUrl
        } else {
            url = "https://media.vtc.vn\(listData[index].fileUrl)"
        }
        print("index aa \(index)")
        audioPlayer.playAudio(fileURL: URL(string: url)!)
        lblNameAudio.text = listData[index].name
        if let url = URL(string: listData[index].image182182){
            imgAudio.loadImage(fromURL: url)
        }
        setupNowPlaying()
    }
    @IBAction func tapPlayStopAudio(_ sender: Any) {
        if isPlaying {
            audioPlayer.player.play()
            btnPlayStop.setImage(UIImage(named: "pause"), for: .normal)
            
        } else {
            audioPlayer.player.pause()
            btnPlayStop.setImage(UIImage(named: "play"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    @IBAction func tapPreviousAudi(_ sender: Any) {
        if index == 0 {
            return
        } else {
            index = index - 1
        }
        if listData[index].fileUrl.contains("http"){
            url = listData[index].fileUrl
        } else {
            url = "https://media.vtc.vn\(listData[index].fileUrl)"
        }
        print("index aa \(index)")
        lblNameAudio.text = listData[index].name
        if let url = URL(string: listData[index].image182182){
            imgAudio.loadImage(fromURL: url)
        }
        audioPlayer.playAudio(fileURL: URL(string: url)!)
        setupNowPlaying()
    }
    var tabBarIteam = UITabBarItem()
    
    
    
    @objc func sliderDidEndSliding(){
        print("slider ending...")
        addTimeObserver()
        viewVideoPlaying.player?.play()
        isPlaying = true
        isSliderChanging = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if self.isSliderChanging == false{
                self.hideComponentVideo()
                self.view.layoutIfNeeded()
            }
        }
    }
    @IBOutlet weak var lblNameAudio: MarqueeLabel!
    @IBOutlet weak var imgAudio: LazyImageView!
    @IBOutlet var viewAudio: UIView!
    
    func getVideoMore(page: Int, id: Int){
        APIService.shared.getDanhSachTinTheoID(page: page, id: id) { (response, error) in
            if let rs = response {
                self.listVideoMore = rs
                self.listVideoMore = self.listVideoMore.shuffled()
                DispatchQueue.main.async {
                    self.clvMoreVideo.reloadData()
                    print("ListvideoMore: \(self.listVideoMore.count)")
                }
            }
        }
    }
    
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
//        commandCenter.nextTrackCommand.isEnabled = false
//        commandCenter.previousTrackCommand.isEnabled = false
//        commandCenter.playCommand.isEnabled = false
//        commandCenter.pauseCommand.isEnabled = false
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            print("Play")
            if !isPlaying {
                audioPlayer.player.play()
                btnPlayStop.setImage(UIImage(named: "pause"), for: .normal)
                
                return .success
            } else {
                print("aaa")
                audioPlayer.player.play()
                btnPlayStop.setImage(UIImage(named: "pause"), for: .normal)
                
                return .success
            }
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            print("pause")
            if !isPlaying {
                audioPlayer.player.pause()
                btnPlayStop.setImage(UIImage(named: "play"), for: .normal)
                
                return .success
            } else {
                audioPlayer.player.pause()
                btnPlayStop.setImage(UIImage(named: "play"), for: .normal)
                
                return .success
            }
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            self.tapNextAudio(Any.self)
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            self.tapPreviousAudi(Any.self)
            return .success
        }
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = listData[index].name
        if let data = try? Data(contentsOf: URL(string: listData[index].image182182)!) {
            if let image = UIImage(data: data) {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
                }
            }
        }
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    
    func updateNowPlaying(isPause: Bool) {
        // Define Now Playing Info
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!
        
        //        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.player.currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPause ? 0 : 1
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewVideoPlaying.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: viewVideoPlaying.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: viewVideoPlaying.centerYAnchor).isActive = true
        clvMoreVideo.delegate = self
        clvMoreVideo.dataSource = self
        clvMoreVideo.register(UINib(nibName: "CellHeaderMoreVideo", bundle: nil), forCellWithReuseIdentifier: "CellHeaderMoreVideo")
        clvMoreVideo.register(UINib(nibName: "CellContenVideoHome", bundle: nil), forCellWithReuseIdentifier: "CellContenVideoHome")
        let layout = UICollectionViewFlowLayout()
        clvMoreVideo.collectionViewLayout = layout
        audioPlayer = AudioPlayer()
        
        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        subViewVideoPlaying.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSubViewVideoPlaying(_:))))
        NotificationCenter.default.addObserver(self, selector: #selector(self.visitTabAudio(_:)), name: NSNotification.Name(rawValue: "VisitTabAudio"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.visitTabVideo(_:)), name: NSNotification.Name(rawValue: "VisitTabVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.visitTabHome(_:)), name: NSNotification.Name(rawValue: "VisitTabHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.visitTabMe(_:)), name: NSNotification.Name(rawValue: "VisitTabMe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.visitTabNew(_:)), name: NSNotification.Name(rawValue: "VisitTabNew"), object: nil)
        
        
        let selectedImage0 = UIImage(named: "home-white-24")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage0 = UIImage(named: "home-grey-24")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = self.tabBar.items![0]
        tabBarIteam.image = deSelectedImage0
        tabBarIteam.selectedImage = selectedImage0
        
        let selectedImage1 = UIImage(named: "tinmoi-white-svg")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "tinmoi-grey-24")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = self.tabBar.items![1]
        tabBarIteam.image = deSelectedImage1
        tabBarIteam.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "video-white-svg")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "video-grey-svg")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = self.tabBar.items![2]
        tabBarIteam.image = deSelectedImage2
        tabBarIteam.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "icHeadPhoneSelected-24-svg")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "icHeadPhoneUnselect-24-svg")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = self.tabBar.items![3]
        tabBarIteam.image = deSelectedImage3
        tabBarIteam.selectedImage = selectedImage3
        
        let selectedImage4 = UIImage(named: "canhan-white-svg")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "canhan-grey-svg")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = self.tabBar.items![4]
        tabBarIteam.image = deSelectedImage4
        tabBarIteam.selectedImage = selectedImage4
        
        self.selectedIndex = 0
        
        let safeAreaInsetsBottom = UIApplication.shared.windows[0].safeAreaInsets.bottom
        let numberOfTab = CGFloat((tabBar.items?.count)!)
        let tabbarSize = CGSize(width: tabBar.frame.width / numberOfTab, height: tabBar.frame.size.height + safeAreaInsetsBottom)        
        tabBar.selectionIndicatorImage = UIImage.imageWithColorNav(color: UIColor(hexString: "#a3151d"), size: tabbarSize)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(openAudio(_:)), name: NSNotification.Name("playAudio"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openVideo(_:)), name: NSNotification.Name("openVideo"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopAudio), name: NSNotification.Name("stopAudioRoot"), object: nil)
        
    }
    
    @objc func stopAudio(){
        audioPlayer.stopAudio()
        viewAudio.isHidden = true
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    var isTapSubviewVideoPlaying = false
    var timeerVideo = Timer()
    var isSliderChanging = false
    @objc func tapSubViewVideoPlaying(_ sender: UITapGestureRecognizer){
        if isTapSubviewVideoPlaying{
            self.hideComponentVideo()
            timeerVideo.invalidate()
        } else {
            self.showComponentVideo()
            timeerVideo = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
                if self.isSliderChanging == false {
                    self.hideComponentVideo()
                    self.isTapSubviewVideoPlaying = false
                    timer.invalidate()
                }
            })
        }
        isTapSubviewVideoPlaying = !isTapSubviewVideoPlaying
    }
    
    @objc func openVideo(_ notification: Notification){
        AdmobManager.shared.loadAdFull(inVC: self)
        clvMoreVideo.setContentOffset(CGPoint.zero, animated: true)
        audioPlayer.stopAudio()
        clvMoreVideo.isHidden = false
        lblName.removeFromSuperview()
        isPlayingVideo = true
        viewAudio.isHidden = true
        viewVideo.isHidden = false
        viewVideo.alpha = 0
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.viewVideo)
        }
        UIView.animate(withDuration: 0.5) {
            self.viewVideo.alpha = 1
            self.viewVideo.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-self.tabBar.frame.size.height)
            self.widthViewPlaying.constant = scaleW * 414
            self.ShowComponent()
            self.hideComponentVideo()
        }
        let id = (notification.userInfo?["id"] as? Int)!
        self.nameVideo = (notification.userInfo?["name"] as? String)!
        self.categoryName = (notification.userInfo?["category"] as? String)!
        self.des = (notification.userInfo?["des"] as? String)!
        self.published = (notification.userInfo?["published"] as? String)!
        self.cateID = (notification.userInfo?["cateID"] as? Int)!
        getVideoMore(page: 1, id: self.cateID)
        
        
        getVideo(id: id)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
        swipeDown.direction = .down
        viewVideo.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
        swipeUp.direction = .up
        viewVideo.addGestureRecognizer(swipeUp)
        
        self.btnPlayPauseVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPlayPauseVideo(_:))))
        self.btnPlayPauseVideo.setImage(UIImage(named: "icPause"), for: .normal)
        
    }
    
    @objc func tapPlayPauseVideo(_ sender: UITapGestureRecognizer){
        if isPlayingVideo {
            self.viewVideoPlaying.player?.pause()
            btnPlayPauseVideo.setImage(UIImage(named: "icPlay"), for: .normal)
        } else {
            self.viewVideoPlaying.player?.play()
            btnPlayPauseVideo.setImage(UIImage(named: "icPause"), for: .normal)
        }
        isPlayingVideo = !isPlayingVideo
    }
    
    @objc func swipeDown(_ sender: Any){
        UIView.animate(withDuration: 0.5) { [self] in
            clvMoreVideo.delegate = self
            clvMoreVideo.dataSource = self
            if isPlayingVideo {
                self.btnPlayStopVideo.setImage(UIImage(named: "icPause"), for: .normal)
            } else {
                self.btnPlayStopVideo.setImage(UIImage(named: "icPlay"), for: .normal)
            }
            
            self.viewVideo.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - self.tabBar.bounds.height - scale * 80, width: UIScreen.main.bounds.width, height: scale * 80)
            self.widthViewPlaying.constant = scale * 142
            self.hideComponent()
            
            self.viewVideo.addSubview(self.btnCloseVideo)
            self.btnCloseVideo.translatesAutoresizingMaskIntoConstraints = false
            self.btnCloseVideo.trailingAnchor.constraint(equalTo: self.viewVideo.trailingAnchor, constant: -8).isActive = true
            self.btnCloseVideo.centerYAnchor.constraint(equalTo: self.viewVideo.centerYAnchor).isActive = true
            self.btnCloseVideo.setImage(UIImage(named: "icDelete"), for: .normal)
            self.btnCloseVideo.heightAnchor.constraint(equalTo: self.viewVideo.heightAnchor, multiplier: 0.4).isActive = true
            self.btnCloseVideo.widthAnchor.constraint(equalTo: self.viewVideo.heightAnchor, multiplier: 0.4).isActive = true
            self.btnCloseVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapBtnCloseVideo(_:))))
            
            self.viewVideo.addSubview(self.btnPlayStopVideo)
            self.btnPlayStopVideo.translatesAutoresizingMaskIntoConstraints = false
            self.btnPlayStopVideo.trailingAnchor.constraint(equalTo: self.btnCloseVideo.leadingAnchor, constant: -8).isActive = true
            self.btnPlayStopVideo.centerYAnchor.constraint(equalTo: self.viewVideo.centerYAnchor).isActive = true
            self.btnPlayStopVideo.setImage(UIImage(named: "pause"), for: .normal)
            self.btnPlayStopVideo.heightAnchor.constraint(equalTo: self.viewVideo.heightAnchor, multiplier: 0.3).isActive = true
            self.btnPlayStopVideo.widthAnchor.constraint(equalTo: self.viewVideo.heightAnchor, multiplier: 0.3).isActive = true
            self.btnPlayStopVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapBtnPlayStopVideo(_:))))
            
            self.viewVideo.addSubview(self.lblName)
            self.lblName.translatesAutoresizingMaskIntoConstraints = false
            self.lblName.centerYAnchor.constraint(equalTo: self.viewVideo.centerYAnchor).isActive = true
            self.lblName.trailingAnchor.constraint(equalTo: self.btnPlayStopVideo.leadingAnchor, constant: -8).isActive = true
            self.lblName.leadingAnchor.constraint(equalTo: self.viewVideoPlaying.trailingAnchor, constant: 8).isActive = true
            self.lblName.text = self.nameVideo
            
            self.viewVideo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(swipeUp(_:))))
        }
    }
    
    @objc func tapBtnCloseVideo(_ sender: UITapGestureRecognizer){
        self.viewVideoPlaying.player?.pause()
        self.viewVideo.isHidden = true
    }
    
    @objc func tapBtnPlayStopVideo(_ sender: UITapGestureRecognizer){
        if isPlayingVideo {
            self.viewVideoPlaying.player?.pause()
            btnPlayStopVideo.setImage(UIImage(named: "play"), for: .normal)
        } else {
            self.viewVideoPlaying.player?.play()
            btnPlayStopVideo.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlayingVideo = !isPlayingVideo
    }
    
    @objc func swipeUp(_ sender: Any){
        self.clvMoreVideo.isHidden = false
        self.clvMoreVideo.delegate = self
        self.clvMoreVideo.dataSource = self
        self.clvMoreVideo.reloadData()
        
        UIView.animate(withDuration: 0.5) {
            self.lblName.removeFromSuperview()
            if isPlayingVideo {
                self.btnPlayPauseVideo.setImage(UIImage(named: "icPause"), for: .normal)
            } else {
                self.btnPlayPauseVideo.setImage(UIImage(named: "icPlay"), for: .normal)
            }
            
            self.viewVideo.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-self.tabBar.frame.size.height)
            self.widthViewPlaying.constant = scaleW * 414
            self.ShowComponent()
            
        }
    }
    
    func hideComponent(){
        self.viewNav.isHidden = true
        self.clvMoreVideo.isHidden = true
        self.btnCloseVideo.isHidden = false
        self.btnPlayStopVideo.isHidden = false
    }
    
    func hideComponentVideo(){
        self.lblTimeRun.isHidden = true
        self.lblTimeVideo.isHidden = true
        self.slider.isHidden = true
        self.btnFullScreen.isHidden = true
        self.btnPlayPauseVideo.isHidden = true
    }
    func showComponentVideo(){
        self.lblTimeRun.isHidden = false
        self.lblTimeVideo.isHidden = false
        self.slider.isHidden = false
        self.btnFullScreen.isHidden = false
        self.btnPlayPauseVideo.isHidden = false
    }
    
    func ShowComponent(){
        self.viewNav.isHidden = false
        self.clvMoreVideo.isHidden = false
        self.btnCloseVideo.isHidden = true
        self.btnPlayStopVideo.isHidden = true
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            UIApplication.shared.endReceivingRemoteControlEvents()
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
        let commandCenter = MPRemoteCommandCenter.shared()
           commandCenter.playCommand.removeTarget(self)
           commandCenter.pauseCommand.removeTarget(self)
           commandCenter.previousTrackCommand.removeTarget(self)
           commandCenter.nextTrackCommand.removeTarget(self)
        }
    
    @objc func openAudio(_ notification: Notification){
        setupRemoteTransportControls()
        viewVideo.isHidden = true
        viewVideoPlaying.player?.pause()
        viewAudio.isHidden = false
        clvMoreVideo.delegate = self
        clvMoreVideo.dataSource = self
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.viewAudio)
        }
        UIView.animate(withDuration: 0.5) {
            self.viewAudio.frame = CGRect(x: 0, y: (CGFloat(UIScreen.main.bounds.height) - CGFloat(self.tabBar.frame.size.height) - 80 * scale), width: UIScreen.main.bounds.width, height: 80*scale)
        }
        
        print("abcde \(index)")
        
        listData = notification.userInfo?["listData"] as! [ModelAlbumDetail]
        index = (notification.userInfo?["index"] as? Int)!
        print("aaaaaa \(index)")
        if listData[index].fileUrl.contains("http"){
            url = listData[index].fileUrl
        } else {
            url = "https://media.vtc.vn\(listData[index].fileUrl)"
        }
        
        if isPlaying {
            audioPlayer.player.pause()
            btnPlayStop.setImage(UIImage(named: "play"), for: .normal)
        } else {
            audioPlayer.playAudio(fileURL: URL(string: url)!)
            btnPlayStop.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
        
        lblNameAudio.text = listData[index].name
        self.nameMFCenter = listData[index].name
        if let url = URL(string: listData[index].image182182){
            imgAudio.loadImage(fromURL: url)
        }
        
        setupNowPlaying()
        
    }
    
    @objc func visitTabMe(_ sender: Notification){
        self.selectedIndex = 4
    }
    @objc func visitTabAudio(_ sender: Notification){
        self.selectedIndex = 3
    }
    @objc func visitTabVideo(_ sender: Notification){
        self.selectedIndex = 2
    }
    @objc func visitTabNew(_ sender: Notification){
        self.selectedIndex = 1
    }
    @objc func visitTabHome(_ sender: Notification){
        self.selectedIndex = 0
    }
}



extension UIImage {
    class func imageWithColorNav(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
extension RootTabbar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let lbldes = UILabel(frame: CGRect.zero)
            lbldes.text = self.des
            lbldes.sizeToFit()
            let lblTitle = UILabel(frame: CGRect.zero)
            lblTitle.text = self.nameVideo
            lblTitle.sizeToFit()
            return CGSize(width: UIScreen.main.bounds.width, height: lbldes.frame.height + scale * 200 + lblTitle.frame.height)
        } else {
            return CGSize(width: (clvMoreVideo.bounds.width - 40)/2 , height: scale * 210)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return listVideoMore.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = clvMoreVideo.dequeueReusableCell(withReuseIdentifier: "CellHeaderMoreVideo", for: indexPath) as! CellHeaderMoreVideo
            cell.lblTitle.text = self.nameVideo
            cell.lblPublished.text = self.published
            cell.lblCateName.text = self.categoryName
            cell.lblDes.text = self.des
            return cell
        } else {
            let cell = clvMoreVideo.dequeueReusableCell(withReuseIdentifier: "CellContenVideoHome", for: indexPath) as! CellContenVideoHome
            cell.lblTitle.text = listVideoMore.count != 0 ? listVideoMore[indexPath.row].title : ""
            cell.lblTitle.textColor = .black
            cell.lblCategory.text = listVideoMore[indexPath.row].categoryName
            let schedule = listVideoMore[indexPath.row].publishedDate
            let timePass = publishedDate(schedule: schedule)
            cell.lblPublished.text = timePass
            if listVideoMore.count != 0 {
                let url = URL(string: listVideoMore[indexPath.row].image)
                cell.img.kf.setImage(with: url){ result in
                    cell.img.stopSkeletonAnimation()
                    cell.img.hideSkeleton(reloadDataAfter: true, transition: .none)
                }
            } else {
                cell.img.isSkeletonable = true
                cell.img.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .none)
            }
            
            cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            
            return cell
        }
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.clvMoreVideo)
        let indexPath = self.clvMoreVideo.indexPathForItem(at: location)
        
        getVideo(id: listVideoMore[indexPath!.row].id)
        self.categoryName = listVideoMore[indexPath!.row].categoryName
        self.cateID = listVideoMore[indexPath!.row].categoryID
        self.des = listVideoMore[indexPath!.row].description
        self.nameVideo = listVideoMore[indexPath!.row].title
        let schedule = listVideoMore[indexPath!.row].publishedDate
        let timePass = publishedDate(schedule: schedule)
        print("MoreVideoCateID: \(self.cateID)")
        getVideoMore(page: 1, id: self.cateID)
        self.published = timePass
        clvMoreVideo.setContentOffset(CGPoint.zero, animated: true)
        clvMoreVideo.reloadData()
        AdmobManager.shared.loadAdFull(inVC: self)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 0, left: scale * 8, bottom: scale * 8, right: scale * 16)
        } else {
            return UIEdgeInsets(top: 0, left: scale * 0, bottom: scale * 0, right: scale * 0)
        }
    }
}
