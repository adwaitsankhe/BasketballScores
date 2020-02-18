//
//  JSONExtractorFromFile.swift
//  FD_iOS_takehome
//
//  Created by Adwait Y Sankhé on 2/8/20.
//  Copyright © 2020 FanDuel. All rights reserved.
//

import Foundation

class JSONExtractorFromFile {
    private let decoder = JSONDecoder()
    
    public func loadJSON<T>(fromFile fileName: String, as object: Any) -> T? where T: Decodable {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
                print("error: \(error)")
            }
        }
        
        return nil
    }
}
