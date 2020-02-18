//
//  Teams.swift
//  FD_iOS_takehome
//
//  Created by Adwait Y Sankhé on 2/7/20.
//  Copyright © 2020 FanDuel. All rights reserved.
//

import Foundation

struct Teams: Decodable {
    let id: Int
    let name: String
    let city: String
    let record: String
    let full_name: String
    let abbrev: String
    let color: String
}
