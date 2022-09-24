//
//  Player.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/21/22.
//

import SpriteKit

class Player: SKSpriteNode, GameSprite {
    var textureAtlas = SKTextureAtlas(named: "Pierre")
    var initialSize = CGSize(width: 64, height: 64)
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    var flapping = false
    let maxFlappingForce: CGFloat = 32000
    var forwardVelocity: CGFloat = 4000
    let maxHeight: CGFloat = 1000
    let deathSound = SKAudioNode(fileNamed: "pierre-dies.mp3")
    
    var health: Int = 3
    var invulnerable = false
    var damaged = false
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        createAnimations()
        self.run(soarAnimation, withKey: "soarAnimation")
        
        let bodyTexture = textureAtlas.textureNamed("pierre-flying-3")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: self.size)
        self.physicsBody?.linearDamping = 0.7
        self.physicsBody?.mass = 12
        self.physicsBody?.allowsRotation = false
        
        // assign the physics categories:
        self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.ground.rawValue | PhysicsCategory.powerup.rawValue | PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createAnimations() {
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.8)
        rotateDownAction.timingMode = .easeIn
        
        
        // flyAnimation
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("pierre-flying-1"),
            textureAtlas.textureNamed("pierre-flying-2"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-4"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-2"),
        ]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.03)
        flyAnimation = SKAction.group([
            SKAction.repeatForever(flyAction),
            rotateUpAction
        ])
        
        // soarAnimation
        let soarFrames: [SKTexture] = [textureAtlas.textureNamed("pierre-flying-1")]
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
        soarAnimation = SKAction.group([SKAction.repeatForever(soarAction), rotateDownAction])
        
        // damageAnimation
        let damageStart = SKAction.run {
            self.physicsBody?.categoryBitMask = PhysicsCategory.damagedPenguin.rawValue
        }
        let slowFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.25, duration: 0.35),
            SKAction.fadeAlpha(to: 0.25, duration: 0.35)
        ])
        let fastFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.2),
            SKAction.fadeAlpha(to: 0.95, duration: 0.2)
        ])
        let fadeOutAndIn = SKAction.sequence([
            SKAction.repeat(slowFade, count: 2),
            SKAction.repeat(fastFade, count: 5),
            SKAction.fadeAlpha(to: 1, duration: 0.15)
        ])
        let damageEnd = SKAction.run {
            self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
            self.damaged = false
        }
        
        self.damageAnimation = SKAction.sequence([
            damageStart, fadeOutAndIn, damageEnd
        ])
        
        // die Animation
        
        let startDie = SKAction.run {
            self.texture = self.textureAtlas.textureNamed("pierre-dead")
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        let endDie = SKAction.run {
            self.physicsBody?.affectedByGravity = true
        }
        
        self.dieAnimation = SKAction.sequence([
            startDie,
            SKAction.scale(to: 1.3, duration: 0.5),
            SKAction.wait(forDuration: 0.5),
            SKAction.rotate(toAngle: 3, duration: 1.5),
            SKAction.wait(forDuration: 0.5),
            endDie
        ])
    }
    
    func onTap() {
        self.physicsBody?.applyForce(CGVector(dx: 20.0, dy: -250.0))
    }
    
    func update() {
        if self.flapping {
            var forceToApply = maxFlappingForce
            
            if position.y > 600 {
                let percentageOfMaxHeight = position.y / maxHeight
                let flappingForceDampening = percentageOfMaxHeight * maxFlappingForce
                forceToApply -= flappingForceDampening
            }
            
            self.physicsBody?.applyForce(CGVector(dx: forwardVelocity, dy: forceToApply))
        }
        
        if self.physicsBody!.velocity.dy > 300 {
            self.physicsBody!.velocity.dy = 300
        }
    }
    
    func startFlapping() {
        if self.health <= 0 { return }
        self.removeAction(forKey: "soarAnimation")
        self.run(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    func stopFlapping() {
        if self.health <= 0 { return }
        self.removeAction(forKey: "flapAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
    func die() {
        self.alpha = 1
        self.removeAllActions()
        deathSound.autoplayLooped = false
        self.addChild(deathSound)
        deathSound.run(SKAction.changeVolume(to: Float(4), duration: 0))
        deathSound.run(SKAction.play())
        self.run(self.dieAnimation)
        self.flapping = false
    }
    
    func takeDamage() {
        if self.invulnerable || self.damaged { return }
        
        self.damaged = true
        self.health -= 1
        
        if self.health <= 0 {
            die()
        } else {
            self.run(self.damageAnimation)
        }
    }
    
    func starPower() {
        self.removeAction(forKey: "starPower")
        self.forwardVelocity = 6000
        self.invulnerable = true
        print("now invulnerable")
        
        let starSequence = SKAction.sequence([
            SKAction.scale(to: 1.5, duration: 0.3),
            SKAction.wait(forDuration: 8),
            SKAction.scale(to: 1, duration: 1),
            SKAction.run {
                self.forwardVelocity = 4000
                self.invulnerable = false
                print("no longer invulnerable")
            }
        ])
        
        let playerPulse = SKAction.sequence([
            SKAction.colorize(with: .gray, colorBlendFactor: 1.0, duration: 0.1),
            SKAction.wait(forDuration: 0.05),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)
        ])
        
        let starGroup = SKAction.group([
            starSequence,
            SKAction.repeat(playerPulse, count: 37)
        ])
        
        print("running starSequence....")
        self.run(starGroup, withKey: "starPower")
        print("starSequence started...")
    }
}

