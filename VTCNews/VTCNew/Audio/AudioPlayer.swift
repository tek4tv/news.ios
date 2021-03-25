//
//  AudioPlayer.swift
//  DearCalls
//
//  Created by dovietduy on 1/14/21.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate{
    var player : AVPlayer!
    var delegate: AudioPlayerDelegate!
   
    override init() {
    }
    func playAudio(fileURL: URL) {
        
        do {
            let playerItem = AVPlayerItem(url: fileURL)
            self.player = try AVPlayer(playerItem: playerItem)
//            player.delegate = self
            player.volume = 1.0
//            player.prepareToPlay()
            var audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            }
            catch {
                
            }
            player.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }

    func stopAudio(){
        if player != nil {
            //player.stop()
            player = nil
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.didFinishPlaying()
    }
}

protocol AudioPlayerDelegate: class {
    func didFinishPlaying()
}

