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
    private let ground = Ground()
    private let bee = Bee()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero // lower left corner
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        self.camera = cam
        self.addBackground()
        self.addGround()
        self.addTheFlyingBee()
    
        // add other bees with new Bee() class
        for x in 0...2 {
            for y in 0...2 {
                let newBee = Bee()
                newBee.position = CGPoint(x: 300 - (50 * x), y: 300 - (50 * y))
                newBee.zPosition = 1.0
                let flightX = CGFloat(Int.random(in: -300...300))
                let flightY = CGFloat(Int.random(in: -800...800))
                let flightD = 0.03 * CGFloat(sqrt(abs(flightX) * abs(flightY)))
                let flightPath1 = SKAction.moveBy(x: flightX, y: flightY, duration: flightD)
                let flightPath2 = SKAction.moveBy(x: -flightX, y: -flightY, duration: flightD)
                let flight = SKAction.sequence([flightPath1, flightPath2])
                let flyForever = SKAction.repeatForever(flight)
                newBee.run(flyForever)
                
                self.addChild(newBee)
            }
        }
        
        
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
    
    func addGround() {
        ground.position = CGPoint(x: -self.size.width * 2, y: 150)
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        ground.createChildren()
        self.addChild(ground)
    }
    
    func addTheFlyingBee() {
        bee.position = CGPoint(x: 250, y: 250)
        self.addChild(bee)
        
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
