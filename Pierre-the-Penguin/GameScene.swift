//
//  GameScene.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/18/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let cam = SKCameraNode()
    private let background = Background()
    private let ground = Ground()
    private let player = Player()
    
    var screenCenterY: CGFloat = 0
    
    let initialPlayerPosition = CGPoint(x: 150, y:250)
    var playerProgress = CGFloat()
    var coinsCollected = 0
    
    let initialBackgroundPosition = CGPoint(x: 250, y: 250)
    let currentBackgroundPosition = CGPoint()
    
    let backgroundMusic = SKAudioNode(fileNamed: "background-music.mp3")
    var musicPlaying: Bool = false
    
    let encounterManager = EncounterManager()
    var nextEncounterSpawnPosition = CGFloat(150)
    let powerUpStar = Star()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero // lower left corner
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        screenCenterY = self.size.height / 2
        self.camera = cam
        self.addBackground()
        self.addGround()
        self.addPlayer()
        self.physicsWorld.contactDelegate = self
        
        
        self.addChild(backgroundMusic)
        backgroundMusic.run(SKAction.stop())
        backgroundMusic.run(SKAction.changeVolume(to: Float(0.8), duration: 0))
            
        encounterManager.addEncountersToScene(gameScene: self)
        encounterManager.encounters[0].position = CGPoint(x: 400, y: 330)
        
        self.addChild(powerUpStar)
        powerUpStar.position = CGPoint(x: -2000, y: -2000)
    }
        
    override func update(_ currentTime: TimeInterval) {
        player.update()
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
        background.checkForReposition(playerProgress: playerProgress)
        ground.checkForReposition(playerProgress: playerProgress)
        
        if player.physicsBody?.velocity.dx ?? 0 <= 0 && player.physicsBody?.velocity.dy ?? 0 == 0 {
            backgroundMusic.run(SKAction.stop())
            musicPlaying = false
        }
        
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(currentXPos: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 1200
            
            let starRoll = Int(arc4random_uniform(10))
            if starRoll == 0 {
                if abs(player.position.x - powerUpStar.position.x) > 1200 {
                    let randomYPos = 50 + CGFloat(arc4random_uniform(550))
                    powerUpStar.position = CGPoint(x: nextEncounterSpawnPosition, y: randomYPos)
                    powerUpStar.physicsBody?.angularVelocity = 0
                    powerUpStar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
            }
        }
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
        
        if !musicPlaying {
            backgroundMusic.run(SKAction.play())
            musicPlaying = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    func addBackground() {
        background.position = CGPoint(x: -self.size.width * 2, y: 600)
        background.zPosition = -1.0
        background.size = CGSize(width: self.size.width * 6, height: 0)
        background.createChildren()
        self.addChild(background)
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

// MARK: - SKPhysicsContactDelegage

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        let otherBody: SKPhysicsBody
        let penguinMask = PhysicsCategory.penguin.rawValue | PhysicsCategory.damagedPenguin.rawValue
        
        if (contact.bodyA.categoryBitMask & penguinMask) > 0 {
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case PhysicsCategory.ground.rawValue:
            print("hit the ground")
        case PhysicsCategory.enemy.rawValue:
            print("hit enemy - take damage")
            player.takeDamage()
        case PhysicsCategory.coin.rawValue:
            if let coin = otherBody.node as? Coin {
                coin.collect()
                self.coinsCollected += coin.value
                print("Coin collected!")
            }
        case PhysicsCategory.powerup.rawValue:
            if let star = otherBody.node as? Star {
                star.collect()
                player.starPower()
                print("Start powerup!")
            }
        default:
            print("Contact with no game logic")
        }
    }
}
