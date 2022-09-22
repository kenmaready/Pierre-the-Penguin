//
//  EncounterManager.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/22/22.
//

import SpriteKit

class EncounterManager {
    let encounterNames: [String] = [
        "EncounterA"
    ]
    var encounters: [SKNode] = []
    
    init() {
        for encounterFileName in encounterNames {
            let encounterNode = SKNode()
            if let encounterScene = SKScene(fileNamed: encounterFileName) {
                for child in encounterScene.children {
                    let copyOfNode = type(of: child).init()
                    copyOfNode.position = child.position
                    copyOfNode.name = child.name
                    encounterNode.addChild(copyOfNode)
                }
            }
            encounters.append(encounterNode)
        }
    }
    
    func addEncountersToScene(gameScene: SKNode) {
        var encounterPosY = 1000
        for encounterNode in encounters {
            encounterNode.position = CGPoint(x: -2000, y: encounterPosY)
            gameScene.addChild(encounterNode)
            encounterPosY *= 2
        }
    }
}
