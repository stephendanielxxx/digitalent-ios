//
//  GetQuizModel.swift
//  Digitalent
//
//  Created by Teke on 06/11/20.
//

import Foundation

struct GetQuizModel: Decodable {
    let assessmentQuiz: [AssessmentQuiz]

    enum CodingKeys: String, CodingKey {
        case assessmentQuiz = "assessment_quiz"
    }
}

// MARK: - AssessmentQuiz
struct AssessmentQuiz: Decodable {
    let materialID, quizID: String
    let quizImage, quizAudio: String
    let question, pil1, pil2, pil3: String
    let pil4: String
    let pil5: String?
    let gfStatus: String
    let answer: String

    enum CodingKeys: String, CodingKey {
        case materialID = "material_id"
        case quizID = "quiz_id"
        case quizImage = "quiz_image"
        case quizAudio = "quiz_audio"
        case question, pil1, pil2, pil3, pil4, pil5
        case gfStatus = "gf_status"
        case answer
    }
}
