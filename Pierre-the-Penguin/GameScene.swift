//
//  GameScene.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/18/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private let cam = SKCameraNode()
    private var bg = SKSpriteNode()
    private var bg2 = SKSpriteNode()
    private let ground = Ground()
    private let player = Player()
    
    var screenCenterY: CGFloat = 0
    
    let initialPlayerPosition = CGPoint(x: 150, y:250)
    var playerProgress = CGFloat()
    
    let initialBackgroundPosition = CGPoint(x: 250, y: 250)
    let currentBackgroundPosition = CGPoint()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero // lower left corner
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        
        screenCenterY = self.size.height / 2
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
        
    }
        
    override func update(_ currentTime: TimeInterval) {
        player.update()
        bg.position.x = initialBackgroundPosition.x + (playerProgress * 0.05)
        bg2.position.x = initialBackgroundPosition.x + bg2.size.width + (playerProgress * 0.05)
    }
    
    override func didSimulatePhysics() {
        playerProgress = player.position.x - initialPlayerPosition.x
        
        // keep camera locked at midscreen by default:
        var cameraYPos = screenCenterY
        cam.yScale = 1
        cam.xScale = 1
        
        // if player higher than half screen, follow player up:
        if player.position.y > screenCenterY {
            cameraYPos = player.position.y
            let percentageOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight - screenCenterY)
            let newScale = 1 + percentageOfMaxHeight
            cam.yScale = newScale
            cam.xScale = newScale
        }
        
        self.camera!.position = CGPoint(x: player.position.x, y: cameraYPos)
        ground.checkForReposition(playerProgress: playerProgress)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self)
            let nodeTouched = atPoint(location)
            if let gameSprite = nodeTouched as? GameSprite {
                gameSprite.onTap()
            }
        }
        
        player.startFlapping()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    func addBackground() {
        bg = SKSpriteNode(imageNamed: "background-menu")
        bg.position = initialBackgroundPosition
        bg.zPosition = -1.0
        self.addChild(bg)
        
        bg2 = SKSpriteNode(imageNamed: "background-menu")
        bg2.position = CGPoint(x: initialBackgroundPosition.x + bg2.size.width, y: initialBackgroundPosition.y)
        bg2.zPosition = -1.0
        self.addChild(bg2)
    }
    
    func addGround() {
        ground.position = CGPoint(x: -self.size.width * 2, y: 30)
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        ground.createChildren()
        self.addChild(ground)
    }
    
    func addPlayer() {
        player.position = initialPlayerPosition
        self.addChild(player)
    }
}
