//
//  Star.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/22/22.
//

import SpriteKit

class Star: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var initialSize: CGSize = CGSize(width: 40, height: 38)
    var pulseAnimation = SKAction()
    
    init() {
        let starTexture = textureAtlas.textureNamed("star")
        super.init(texture: starTexture, color: .clear, size: initialSize)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        createAnimations()
        self.run(pulseAnimation, withKey: "pulseAnimation")
        self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createAnimations() {
        let pulseOutGroup = SKAction.group([
            SKAction.fadeAlpha(to: 0.85, duration: 0.8),
            SKAction.scale(to: 0.6, duration: 0.8),
            SKAction.rotate(byAngle: -0.3, duration: 0.8)
        ])
        let pulseInGroup = SKAction.group([
            SKAction.fadeAlpha(to: 0.1, duration: 1.5),
            SKAction.scale(to: 1, duration: 1.5),
            SKAction.rotate(byAngle: 3.5, duration: 1.5)
        ])
        let pulseSequence = SKAction.sequence([pulseOutGroup, pulseInGroup])
        pulseAnimation = SKAction.repeatForever(pulseSequence)
    }
    
    func collect() {
        self.physicsBody?.categoryBitMask = 0
        let collectAnimation = SKAction.group([
            SKAction.run {
                self.removeAction(forKey: "pulseAnimation")
            },
            SKAction.scale(by: 1.6, duration: 0.2),
            SKAction.fadeAlpha(to: 1, duration: 0.05),
            SKAction.move(by: CGVector(dx: 0.0, dy: 200.0), duration: 0.4),
            SKAction.rotate(byAngle: 6, duration: 0.4),
            SKAction.colorize(with: .yellow, colorBlendFactor: 1.0, duration: 0.4)
        ])
        let resetAfterCollected = SKAction.run {
            self.position.y = 5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
            self.run(self.pulseAnimation, withKey: "pulseAnimation")
        }
        
        let collectSequence = SKAction.sequence([
            collectAnimation,
            resetAfterCollected
        ])
        
        self.run(collectSequence)
    }
    
    func onTap() {
        // not implemented
    }
    
    
}
