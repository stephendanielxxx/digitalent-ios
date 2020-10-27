//
//  JoinClassModel.swift
//  Digitalent
//
//  Created by Teke on 27/10/20.
//

import Foundation

// MARK: - TopicDetailAction
struct JoinClassModel: Decodable {
    let success: Bool
    let code: Int
    let message: String
    let data: Bool
    let request: Request
}

// MARK: - Request
struct Request: Decodable {
    let transID, uid, namaRek, courID: String
    let status, total, slug: String

    enum CodingKeys: String, CodingKey {
        case transID = "trans_id"
        case uid
        case namaRek = "nama_rek"
        case courID = "cour_id"
        case status, total, slug
    }
}
