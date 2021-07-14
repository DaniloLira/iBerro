//
//  Player.swift
//  iBerro
//
//  Created by Danilo Araújo on 09/07/21.
//

import Foundation
import UIKit
import GameKit

struct Player: Codable, Comparable {
    var status: PlayerStatus = .waiting
    var score: Int = 0
    var displayName: String
    var isHost: Bool
    var photo: ImageWrapper
    
    static func < (lhs: Player, rhs: Player) -> Bool {
        lhs.score < rhs.score
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.displayName == rhs.displayName
    }
    
}

enum PlayerStatus: String, Codable {
    case singing
    case watching
    case evaluating
    case waiting
    case ready
}

public struct ImageWrapper: Codable {

    public let image: Data
    
    public init(photo: UIImage) {
        self.image = photo.pngData()!
    }
}