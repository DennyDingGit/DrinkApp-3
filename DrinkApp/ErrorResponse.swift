//
//  ErrorResponse.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/6/8.
//

import Foundation

struct ErrorResponse: Decodable {
    let errorCode: Int
    let message: String
}
