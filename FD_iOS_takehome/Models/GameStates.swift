//
//  GameStates.swift
//  FD_iOS_takehome
//
//  Created by Adwait Y Sankhé on 2/7/20.
//  Copyright © 2020 FanDuel. All rights reserved.
//

import Foundation

enum GameStatus: String, Decodable {
    case final = "FINAL"
    case scheduled = "SCHEDULED"
    case inProgress = "IN_PROGRESS"
}

struct GameStates: Decodable {
    let id: Int
    let game_id: Int
    let home_team_score: Int?
    let away_team_score: Int?
    let broadcast: String
    let quarter: Int?
    let time_left_in_quarter: String?
    let game_start: String?
    let game_status: GameStatus
}
