//
//  HUD.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/24/22.
//

import SpriteKit

class HUD: SKNode {
    var textureAtlas = SKTextureAtlas(named: "HUD")
    var coinAtlas = SKTextureAtlas(named: "Environment")
    var heartNodes: [SKSpriteNode] = []
    let coinCountText = SKLabelNode(text: "000000")
    
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()
    
    func createHudNodes(screensize: CGSize) {
        let cameraOrigin = CGPoint(
            x: screensize.width / 2,
            y: screensize.height / 2
        )
        
        let coinIcon = SKSpriteNode(texture: coinAtlas.textureNamed("coin-bronze"))
        let coinPosition = CGPoint(x: -cameraOrigin.x + 23, y: cameraOrigin.y - 23)
        coinIcon.size = CGSize(width: 20, height: 20)
        coinIcon.position = coinPosition
        self.addChild(coinIcon)
        
        coinCountText.fontName = "AvenirNext-HeavyItalic"
        coinCountText.fontSize = 20
        let coinTextPosition = CGPoint(x: -cameraOrigin.x + 41, y: coinPosition.y)
        coinCountText.position = coinTextPosition
        coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(coinCountText)
        
        for index in 0 ..< 3 {
            let newHeartNode = SKSpriteNode(texture: textureAtlas.textureNamed("heart-full"))
            newHeartNode.size = CGSize(width: 23, height: 20)
            let xPos = -cameraOrigin.x + CGFloat(index * 29) + 50
            let yPos = cameraOrigin.y - 48
            newHeartNode.position = CGPoint(x: xPos, y: yPos)
            heartNodes.append(newHeartNode)
            self.addChild(newHeartNode)
        }
        
        restartButton.texture = textureAtlas.textureNamed("button-restart")
        menuButton.texture = textureAtlas.textureNamed("button-menu")
        restartButton.name = "restartGame"
        menuButton.name = "returnToMenu"
        menuButton.position = CGPoint(x: -140, y: 0)
        restartButton.size = CGSize(width: 140, height: 140)
        menuButton.size = CGSize(width: 70, height: 70)
    }
    
    func setCoinDisplay(newCoinCount: Int) {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 6

        let number = NSNumber(value: newCoinCount)
        
        if let coinStr = formatter.string(from: number) {
            coinCountText.text = coinStr
        }
    }
    
    func setHealthDisplay(newHealth: Int) {
        let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
        for index in 0 ..< heartNodes.count {
            if index < newHealth {
                heartNodes[index].alpha = 1
            } else {
                heartNodes[index].run(fadeAction)
            }
        }
    }
    
    func showButtons() {
        restartButton.alpha = 0
        menuButton.alpha = 0
        
        self.addChild(restartButton)
        self.addChild(menuButton)
        
        let fadeAnimation = SKAction.sequence([
            SKAction.wait(forDuration: 1.8),
            SKAction.fadeAlpha(to: 1, duration: 0.4)
        ])
        restartButton.run(fadeAnimation)
        menuButton.run(fadeAnimation)
    }
}
