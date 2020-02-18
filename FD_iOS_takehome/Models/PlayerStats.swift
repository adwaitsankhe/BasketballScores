//
//  PlayerStats.swift
//  FD_iOS_takehome
//
//  Created by Adwait Y Sankhé on 2/7/20.
//  Copyright © 2020 FanDuel. All rights reserved.
//

import Foundation

struct PlayerStats: Decodable {
    let id: Int
    let game_id: Int
    let player_id: Int
    let team_id: Int
    let points: Int
    let assists: Int
    let rebounds: Int?
    let nerd: Double
}
