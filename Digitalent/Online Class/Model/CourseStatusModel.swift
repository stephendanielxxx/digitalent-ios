//
//  CourseStatusModel.swift
//  Digitalent
//
//  Created by Teke on 27/10/20.
//

import Foundation

// MARK: - TopicDetailAction
struct CourseStatusModel: Decodable {
    let status: String
    let data: [CourseDataModel]?
}

// MARK: - Datum
struct CourseDataModel: Decodable {
    let transactionStatus, courseID, userID, transactionID: String

    enum CodingKeys: String, CodingKey {
        case transactionStatus = "transaction_status"
        case courseID = "course_id"
        case userID = "user_id"
        case transactionID = "transaction_id"
    }
}
