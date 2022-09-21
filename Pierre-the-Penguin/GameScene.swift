//
//  GameScene.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/18/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private let cam = SKCameraNode()
    private let bee = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero // lower left corner
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        self.camera = cam
        self.addTheFlyingBee()
        self.addBackground()
    }
    
    override func didSimulatePhysics() {
        self.camera!.position = bee.position
    }
    
    func addBackground() {
        let bg = SKSpriteNode(imageNamed: "background-menu")
        bg.position = CGPoint(x: 250, y:250)
        bg.zPosition = -1.0
        self.addChild(bg)
    }
    
    func addTheFlyingBee() {
        bee.position = CGPoint(x: 250, y: 250)
        bee.size = CGSize(width: 28, height: 24)
        self.addChild(bee)
        
        let beeAtlas = SKTextureAtlas(named: "Enemies")
        let beeFrames:[SKTexture] = [
            beeAtlas.textureNamed("bee"),
            beeAtlas.textureNamed("bee-fly")
        ]
        
        // flap wings forever
        let flyAction = SKAction.animate(with: beeFrames, timePerFrame: 0.14)
        let beeAction = SKAction.repeatForever(flyAction)
        bee.run(beeAction)
        
        let pathLeft = SKAction.moveBy(x: -200, y: -40, duration: 1.5)
        let pathRight = SKAction.moveBy(x: 200, y: 40, duration: 1.5)
        let flipBeeRight = SKAction.scaleX(to: -1, duration: 0.2)
        let flipBeeLeft = SKAction.scaleX(to: 1, duration: 0.2)
        
        let flightOfTheBee = SKAction.sequence([
            pathLeft, flipBeeRight, pathRight, flipBeeLeft
        ])
        let neverEndingFlight = SKAction.repeatForever(flightOfTheBee)
        
        bee.run(neverEndingFlight)
        
    }
}
