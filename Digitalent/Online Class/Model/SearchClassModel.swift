//
//  SearchClassModel.swift
//  Digitalent
//
//  Created by Teke on 21/10/20.
//

import Foundation

// MARK: - TopicDetailAction
struct SearchClassModel: Decodable {
    let success: Bool
    let code: Int
    let message: String
    let data: [SearchDataModel]
    let request: RequestModel
}

// MARK: - Datum
struct SearchDataModel: Decodable {
    let courseID: String
    let courseTitle: String
    let courseTypeID: String
    let courseImage: String
    let coursePrice: String
    let courseVid: String?
    let courseSpecialPrice: String?
    let userID: String
    let courseDesc: String

    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case courseTitle = "course_title"
        case courseTypeID = "course_type_id"
        case courseImage = "course_image"
        case coursePrice = "course_price"
        case courseVid = "course_vid"
        case courseSpecialPrice = "course_special_price"
        case userID = "user_id"
        case courseDesc = "course_desc"
    }
}

// MARK: - Request
struct RequestModel: Decodable {
    let courseTitle: String

    enum CodingKeys: String, CodingKey {
        case courseTitle = "course_title"
    }
}
