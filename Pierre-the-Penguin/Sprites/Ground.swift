//
//  Ground.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/21/22.
//

import SpriteKit

class Ground: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var initialSize = CGSize.zero
    var jumpWidth = CGFloat()
    var jumpCount = CGFloat(1)
    
    func onTap() {
        
    }
    
    func createChildren() {
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        let texture = textureAtlas.textureNamed("ground")
        var tileCount: CGFloat = 0
        let tileSize = CGSize(width: 35, height: 300)
        
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            self.addChild(tileNode)
            
            tileCount += 1
        }
        
        jumpWidth = tileSize.width * floor(tileCount / 3)
        
        let pointTopLeft = CGPoint(x: 0, y:0)
        let pointTopRight = CGPoint(x: size.width, y:0)
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
    }
    
    func checkForReposition(playerProgress: CGFloat) {
        let groundJumpPosition = jumpWidth * jumpCount
        if playerProgress >= groundJumpPosition {
            self.position.x += jumpWidth
            jumpCount += 1
        }
    }
}
