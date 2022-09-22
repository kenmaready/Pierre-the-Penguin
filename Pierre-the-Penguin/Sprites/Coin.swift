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
    
    init() {
        let bronzeTexture = textureAtlas.textureNamed("coin-bronze")
        super.init(texture: bronzeTexture, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func turnToGold() {
        self.texture = textureAtlas.textureNamed("coin-gold")
        self.value = 5
    }
    
    func onTap() {
        // not yet implemented
    }
}
