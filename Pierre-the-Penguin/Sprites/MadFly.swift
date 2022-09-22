//
//  MadFly.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/22/22.
//

import SpriteKit

class MadFly: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var initialSize: CGSize = CGSize(width: 61, height: 29)
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        
        self.physicsBody = SKPhysicsBody.init(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        
        createAnimations()
        self.run(flyAnimation)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createAnimations() {
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("madfly"),
            textureAtlas.textureNamed("madfly-fly")
        ]
        
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    
    func onTap() {
        // not yet implemented
    }
}
