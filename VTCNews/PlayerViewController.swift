//
//  PlayerViewController.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/24/21.
//

import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    typealias DissmissBlock = () -> Void
    var onDismiss: DissmissBlock?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            onDismiss?()
        }
    }
}
