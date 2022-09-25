//
//  PhysicsMasks.swift
//  Pierre-the-Penguin
//
//  Created by Ken Maready on 9/23/22.
//

import Foundation

enum PhysicsCategory: UInt32 {
    case penguin = 1
    case damagedPenguin = 2
    case ground = 4
    case enemy = 8
    case coin = 16
    case powerup = 32
    case crate = 64
}
