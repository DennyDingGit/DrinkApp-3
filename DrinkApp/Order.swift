//
//  Order.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/2.
//

import Foundation

struct OrderBody: Codable {
    let data: [Order]
}

struct Order: Codable {
    let name: String
    let drink: String
    var size: String
    var iceLevel: String
    var sugarLevel: String
    var price: Int 
}
