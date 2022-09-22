//
//  Blade.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/22/22.
//

import SpriteKit

class Blade: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var initialSize: CGSize = CGSize(width: 185, height: 92)
    var spinAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        
        let startTexture = textureAtlas.textureNamed("blade")
        self.physicsBody = SKPhysicsBody(texture: startTexture, size: initialSize)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        createAnimations()
        self.run(spinAnimation)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createAnimations() {
        let spinFrames: [SKTexture] = [
            textureAtlas.textureNamed("blade"),
            textureAtlas.textureNamed("blade-2")
        ]
        let spinAction = SKAction.animate(with: spinFrames, timePerFrame: 0.07)
        spinAnimation = SKAction.repeatForever(spinAction)
    }
    
    func onTap() {
        // not yet implemented
    }
    
    
}
