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
    
    func explode() {
        if exploded { return }
        exploded = true
        
        self.physicsBody?.categoryBitMask = 0
    }
    
    func reset() {
        self.alpha = 1
        self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
        exploded = false
    }
    
    func onTap() {}
    
    
}
