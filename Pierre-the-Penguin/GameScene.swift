//
//  GameScene.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/18/22.
//

import SpriteKit
import CoreMotion
import GameplayKit

class GameScene: SKScene {
    private let cam = SKCameraNode()
    private let ground = Ground()
    private let player = Player()
    private let motionManager = CMMotionManager()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero // lower left corner
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        self.camera = cam
        self.addBackground()
        self.addGround()
        self.addPlayer()
    
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
                newBee.physicsBody?.mass = 0.2
                newBee.physicsBody?.applyImpulse(CGVector(dx: CGFloat(Int.random(in: -90...90)) , dy:CGFloat(Int.random(in: -90...90))))
                self.addChild(newBee)
            }
        }
        
        self.motionManager.startAccelerometerUpdates()
    }
        
    override func update(_ currentTime: TimeInterval) {
        player.update()
        
        if let accelData = self.motionManager.accelerometerData {
            var forceAmount: CGFloat
            var movement = CGVector()
            
            switch UIApplication.shared.windows.first?.windowScene?.interfaceOrientation {
            case .landscapeLeft:
                forceAmount = 8000
            case .landscapeRight:
                forceAmount = -8000
            default:
                forceAmount = 0
            }
            
            if accelData.acceleration.y > 0.15 {
                movement.dx = forceAmount
            } else if accelData.acceleration.y < -0.15 {
                movement.dx = -forceAmount
            }
            
            player.physicsBody?.applyForce(movement)
        } else {
            let fakeAccelData = CGFloat.random(in: -0.50...0.50)
            var forceAmount: CGFloat = 16000
            var movement = CGVector()
            
            if fakeAccelData > 0.15 {
                movement.dx = forceAmount
            } else if fakeAccelData < -0.15 {
                movement.dx = -forceAmount
            }
            
            player.physicsBody?.applyForce(movement)
        }
    }
    
    override func didSimulatePhysics() {
        self.camera!.position = player.position
    }
    
    func addBackground() {
        let bg = SKSpriteNode(imageNamed: "background-menu")
        bg.position = CGPoint(x: 250, y:250)
        bg.zPosition = -1.0
        self.addChild(bg)
    }
    
    func addGround() {
        ground.position = CGPoint(x: -self.size.width * 2, y: 30)
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        ground.createChildren()
        self.addChild(ground)
    }
    
    func addPlayer() {
        player.position = CGPoint(x: 150, y: 250)
        self.addChild(player)
    }
}
