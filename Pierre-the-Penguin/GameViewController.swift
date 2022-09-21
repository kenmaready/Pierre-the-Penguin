//
//  GameViewController.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/18/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let view = self.view as! SKView? {
            
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                scene.size = view.bounds.size
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
