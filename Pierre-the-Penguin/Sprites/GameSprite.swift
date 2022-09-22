//
//  GameSprite.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/21/22.
//

import Foundation
import SpriteKit

protocol GameSprite {
    var textureAtlas: SKTextureAtlas { get set }
    var initialSize: CGSize { get set }
    func onTap()
}
