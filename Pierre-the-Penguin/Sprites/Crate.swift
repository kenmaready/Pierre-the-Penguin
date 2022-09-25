//
//  Crate.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/25/22.
//

import SpriteKit

class Crate: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var initialSize: CGSize = CGSize(width: 40, height: 40)
    let coinSound = SKAction.playSoundFileNamed("Coin.aif", waitForCompletion: false)
    var givesHeart = false
    var exploded = false
    
    init() {
        super.init(texture: nil, color: UIColor.clear, size: initialSize)
        self.texture = textureAtlas.textureNamed("crate")
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
        self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue | PhysicsCategory.crate.rawValue
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    func turnToHeartCrate() {
        self.physicsBody?.affectedByGravity = false
        self.texture = textureAtlas.textureNamed("crate-power-up")
        givesHeart = true
    }
    
    func explode(gameScene: GameScene) {
        if exploded { return }
        exploded = true
        
        gameScene.particlePool.placeEmitter(node: self, type: EmitterType.crate)
        self.run(SKAction.fadeAlpha(to: 0.0, duration: 0.1))
        
        if (givesHeart) {
            let newHealth = gameScene.player.health + 1
            let maxHealth = gameScene.player.maxHealth
            gameScene.player.health = newHealth > maxHealth ? maxHealth : newHealth
            gameScene.hud.setHealthDisplay(newHealth: gameScene.player.health)
            gameScene.particlePool.placeEmitter(node: self, type: EmitterType.heart)
        } else {
            gameScene.coinsCollected += 5
            gameScene.hud.setCoinDisplay(newCoinCount: gameScene.coinsCollected)
            gameScene.particlePool.placeEmitter(node: self, type: EmitterType.coinFountain)
            for _ in 1...5 {
                self.run(coinSound)
            }
        }
        
        self.physicsBody?.categoryBitMask = 0
    }
    
    func reset() {
        self.alpha = 1
        self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
        exploded = false
    }
    
    func onTap() {}
    
    
}
