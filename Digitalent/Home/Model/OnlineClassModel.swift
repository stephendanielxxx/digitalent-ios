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
    let totalQuiz: String
    let totalVideo: String
    let totalPdf: String

    enum CodingKeys: String, CodingKey {
        case id, title, price
        case specialPrice = "special_price"
        case image, vid, desc
        case courseTypeID = "course_type_id"
        case totalQuiz = "total_quiz"
        case totalVideo = "total_video"
        case totalPdf = "total_pdf"
    }
}
