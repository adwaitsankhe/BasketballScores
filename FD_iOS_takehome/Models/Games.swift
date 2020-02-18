//
//  Games.swift
//  FD_iOS_takehome
//
//  Created by Adwait Y Sankhé on 2/7/20.
//  Copyright © 2020 FanDuel. All rights reserved.
//

import Foundation

struct Games: Decodable {
    let id: Int
    let home_team_id: Int
    let away_team_id: Int
    let date: String
}
