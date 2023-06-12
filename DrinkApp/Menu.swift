//
//  Menu.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/2.
//

import Foundation

struct Menu: Codable {
    let category: String
    let drinks: [Drink]
}

struct Drink: Codable {
    let name: String
    let info: DrinkInfo
}

struct DrinkInfo: Codable {
    let m: Int
    let l: Int?

    enum CodingKeys: String, CodingKey {
        case m = "M"
        case l = "L"
    }
}
