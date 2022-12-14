//
//  Coin.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/22/22.
//

import SpriteKit

class Coin: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var initialSize: CGSize = CGSize(width: 26, height: 26)
    var value = 1
    let coinSound = SKAction.playSoundFileNamed("Coin.aif", waitForCompletion: false)
    
    init() {
        let bronzeTexture = textureAtlas.textureNamed("coin-bronze")
        super.init(texture: bronzeTexture, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func turnToGold() {
        self.texture = textureAtlas.textureNamed("coin-gold")
        self.value = 5
    }
    
    func collect() {
        self.physicsBody?.categoryBitMask = 0
        
        let coinBounce = SKAction.sequence([
            SKAction.move(by: CGVector(dx: 0.0, dy: 100), duration: 0.2),
            SKAction.move(by:CGVector(dx: 0.0, dy: -100), duration: 0.2),
            SKAction.move(by: CGVector(dx: 0.0, dy: 50), duration: 0.1),
            SKAction.move(by:CGVector(dx: 0.0, dy: -50), duration: 0.1),
            SKAction.move(by: CGVector(dx: 0.0, dy: 25), duration: 0.1),
            SKAction.move(by:CGVector(dx: 0.0, dy: -25), duration: 0.1),
        ])
        
        let collectAnimation = SKAction.group([
            SKAction.scale(to: 1.5, duration: 0.2),
            SKAction.fadeAlpha(to: 0.0, duration: 1.0),
            coinBounce
        ])
        let resetAfterCollected = SKAction.run {
            self.position.y = 5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        }
        
        let collectSequence = SKAction.sequence([
            collectAnimation,
            resetAfterCollected
        ])
        
        self.run(coinSound)
        self.run(collectSequence)
    }
    
    func onTap() {
        // not yet implemented
    }
}
