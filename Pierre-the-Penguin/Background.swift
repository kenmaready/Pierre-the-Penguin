//
//  Background.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/22/22.
//

import SpriteKit

class Background: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "background")
    var initialSize: CGSize = .zero
    var jumpWidth = CGFloat()
    var jumpCount = CGFloat(0)
    
    func createChildren() {
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        let texture = textureAtlas.textureNamed("background-menu")
        var tileCount: CGFloat = 0
        let tileSize = CGSize(width: 800, height: 600)
        
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            self.addChild(tileNode)
            
            tileCount += 1
        }
        
        jumpWidth = tileSize.width * floor(tileCount / 4)
    }
    
    func checkForReposition(playerProgress: CGFloat) {
        let backgroundJumpPosition = jumpWidth * jumpCount
        if playerProgress >= backgroundJumpPosition {
            self.position.x += jumpWidth
            jumpCount += 1
        }
    }
    
    func onTap() {
        
    }
    
}

