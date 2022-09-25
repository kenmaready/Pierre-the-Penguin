//
//  OptionsScene.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/25/22.
//

import SpriteKit

class OptionsScene: SKScene {
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "HUD")
    
    let muteButton = SKSpriteNode()
    let sliderBase = SKSpriteNode()
    let sliderKnob = SKSpriteNode()
    let menuButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let backgroundImage = SKSpriteNode(imageNamed: "background-menu")
        backgroundImage.size = CGSize(width: 1024, height: 768)
        backgroundImage.zPosition = -1
        self.addChild(backgroundImage)
        
        let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoText.text = "Options:"
        logoText.position = CGPoint(x: 0, y: 100)
        logoText.fontSize = 60
        self.addChild(logoText)
        
        if BackgroundMusic.instance.isMuted() {
            muteButton.texture = textureAtlas.textureNamed("button-mute")
        } else {
            muteButton.texture = textureAtlas.textureNamed("button-unmute")
        }
        
        muteButton.name = "muteBtn"
        muteButton.position = CGPoint(x: -100, y: 0)
        muteButton.size = CGSize(width: 75, height: 75)
        self.addChild(muteButton)
        
        sliderBase.texture = textureAtlas.textureNamed("slider-base")
        sliderBase.position = CGPoint(x: 50, y: 0)
        sliderBase.size = CGSize(width: 200, height: 20)
        sliderBase.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.addChild(sliderBase)
        
        let volume = BackgroundMusic.instance.musicPlayer.volume
        let pos = (Float)(sliderBase.position.x + sliderBase.frame.size.width) * volume
        
        sliderKnob.texture = textureAtlas.textureNamed("slider-knob")
        sliderKnob.position = CGPoint(x: CGFloat(pos), y: sliderBase.position.y)
        sliderKnob.size = CGSize(width: 25, height: 25)
        self.addChild(sliderKnob)
        sliderKnob.zPosition = 1.0
        
        menuButton.texture = textureAtlas.textureNamed("button-menu")
        menuButton.name = "returnToMenu"
        menuButton.position = CGPoint(x: 0, y: -120)
        menuButton.size = CGSize(width: 70, height: 70)
        self.addChild(menuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodeTouched = atPoint(location)
            if nodeTouched.name == "muteBtn" {
                if BackgroundMusic.instance.isMuted() {
                    BackgroundMusic.instance.playMusic()
                    muteButton.texture = textureAtlas.textureNamed("button-unmute")
                } else {
                    BackgroundMusic.instance.pauseMusic()
                    muteButton.texture = textureAtlas.textureNamed("button-mute")
                }
            } else if (nodeTouched.name == "returnToMenu") {
                self.view?.presentScene(MenuScene(size: self.size), transition: .crossFade(withDuration: 0.6))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            var xpos = location.x
            
            if (xpos <= sliderBase.position.x) {
                xpos = sliderBase.position.x
            } else if (xpos >= sliderBase.position.x + sliderBase.frame.width) {
                xpos = sliderBase.position.x + sliderBase.frame.width
            }
            
            sliderKnob.position = CGPoint(x: xpos, y: sliderKnob.position.y)
            let volume = (sliderKnob.position.x - sliderBase.position.x)/sliderBase.frame.width
            
            BackgroundMusic.instance.setVolume(to: Float(volume))
        }
    }
}
