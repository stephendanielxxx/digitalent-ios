//
//  GetCheckPointModel.swift
//  Digitalent
//
//  Created by Teke on 11/11/20.
//

import Foundation

struct GetCheckPointModel: Codable {
    let data: [CheckPointModel]?
    let status: String
}

struct CheckPointModel: Codable {
    let userID, materialID, lastPosition, lastScore: String
    let duration: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case materialID = "material_id"
        case lastPosition = "last_position"
        case lastScore = "last_score"
        case duration
    }
}
