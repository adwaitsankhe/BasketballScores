//
//  SportsData.swift
//  FD_iOS_takehome
//
//  Created by Adwait Y Sankhé on 2/7/20.
//  Copyright © 2020 FanDuel. All rights reserved.
//

import Foundation

struct SportsData: Decodable {
    let teams: [Teams]
    let players: [Players]
    let games: [Games]
    let player_stats: [PlayerStats]
    let game_states: [GameStates]
}
