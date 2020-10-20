//
//  OnlineClassModel.swift
//  Digitalent
//
//  Created by Teke on 20/10/20.
//

import Foundation

struct OnlineClassModel: Decodable {
    let online: [OnlineModel]
}

struct OnlineModel: Decodable {
    let id: String
    let title: String
    let price: String
    let specialPrice: String?
    let image: String
    let vid: String?
    let desc: String
    let courseTypeID: String

    enum CodingKeys: String, CodingKey {
        case id, title, price
        case specialPrice = "special_price"
        case image, vid, desc
        case courseTypeID = "course_type_id"
    }
}
