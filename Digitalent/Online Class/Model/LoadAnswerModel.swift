//
//  LoadAnswerModel.swift
//  Digitalent
//
//  Created by Teke on 11/11/20.
//

import Foundation

struct LoadAnswerModel: Decodable {
    let data: [AnswerModel]?
    let status: String
}

// MARK: - Datum
struct AnswerModel: Decodable {
    let userID, quizID, subMaterialID, quizAnswerID: String?
    let userAnswer, courseID, transactionID, point: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case quizID = "quiz_id"
        case subMaterialID = "sub_material_id"
        case quizAnswerID = "quiz_answer_id"
        case userAnswer = "user_answer"
        case courseID = "course_id"
        case transactionID = "transaction_id"
        case point
    }
}
