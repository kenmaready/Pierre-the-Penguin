//
//  BackgroundMusic.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/25/22.
//

import AVFoundation

class BackgroundMusic: NSObject {
    // singleton
    static let instance = BackgroundMusic()
    var musicPlayer = AVAudioPlayer()
    
    func playBackgroundMusic() {
        if let musicPath = Bundle.main.path(forResource: "BackgroundMusic.m4a", ofType: nil) {
            let url = URL(fileURLWithPath: musicPath)
            
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer.numberOfLoops = -1
                musicPlayer.prepareToPlay()
                musicPlayer.play()
            } catch {
                print("Error loading sound file \(musicPath.description)")
            }
            
            if isMuted() { pauseMusic() }
        }
    }
    
    func pauseMusic() {
        UserDefaults.standard.set(true, forKey: "BackgroundMusicMuteState")
        musicPlayer.pause()
    }
    
    func playMusic() {
        UserDefaults.standard.set(false, forKey: "BackgroundMusicMuteState")
        musicPlayer.play()
    }
    
    func isMuted() -> Bool {
        if UserDefaults.standard.bool(forKey: "BackgroundMusicMuteState") {
            return true
        } else {
            return false
        }
    }
    
    func setVolume(to volume: Float) {
        musicPlayer.volume = volume
    }
}
