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
    private var backgrounds: [Background] = []
    private let ground = Ground()
    private let player = Player()
    private let hud = HUD()
    
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
        self.addChild(self.camera!)
        self.camera!.zPosition = 50
        hud.createHudNodes(screensize: self.size)
        self.camera!.addChild(hud)
        
        self.addBackgrounds()
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
        ground.checkForReposition(playerProgress: playerProgress)
        for background in self.backgrounds {
            background.updatePosition(playerProgress: playerProgress)
        }
        
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
            
            if nodeTouched.name == "restartGame" {
                self.view?.presentScene(GameScene(size: self.size), transition: .crossFade(withDuration: 0.6))
            } else if nodeTouched.name == "returnToMenu" {
                self.view?.presentScene(MenuScene(size: self.size), transition: .crossFade(withDuration: 0.6))
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
    
    func addBackgrounds() {
        let backgroundImageNames = [
            "background-front",
            "background-middle",
            "background-back"
        ]
        let backgroundZPositions: [CGFloat] = [-5, -10, -15]
        let backgroundMovementMultipliers = [0.75, 0.5, 0.2]
        
        for i in 0..<3 {
            backgrounds.append(Background())
            backgrounds[i].spawn(parentNode: self, imageName: backgroundImageNames[i], zPosition: backgroundZPositions[i], movementMultiplier: backgroundMovementMultipliers[i])
        }
        
    }
    
    func addGround() {
        ground.position = CGPoint(x: -self.size.width * 2, y: 30)
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        ground.createChildren()
        self.addChild(ground)
    }
    
    func addPlayer() {
        player.position = initialPlayerPosition
        player.zPosition = 10
        
        if let dotEmitter = SKEmitterNode(fileNamed: "PierrePath") {
            dotEmitter.particleZPosition = -1
            player.addChild(dotEmitter)
            dotEmitter.targetNode = self
            }
        
        self.addChild(player)
    }
    
    func gameOver() {
        hud.showButtons()
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
            hud.setHealthDisplay(newHealth: player.health)
        case PhysicsCategory.coin.rawValue:
            if let coin = otherBody.node as? Coin {
                coin.collect()
                self.coinsCollected += coin.value
                hud.setCoinDisplay(newCoinCount: self.coinsCollected)
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
