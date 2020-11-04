//
//  GetOnlineClassDetailModel.swift
//  Digitalent
//
//  Created by Teke on 26/10/20.
//

import Foundation

// MARK: - TopicDetailAction
struct GetOnlineClassDetailModel: Decodable {
    let code: Int
    let courseTypeID: String
    let courseID: String
    let title: String
    let author: String
    let price: String?
    let specialPrice: String?
    let desc: String?
    let img: String?
    let slug: String?
    let vid: String?
    let vidPre: String?
    let totalQuiz: String?
    let totalPdf: String?
    let materi: [Materi]

    enum CodingKeys: String, CodingKey {
        case code
        case courseTypeID = "course_type_id"
        case courseID = "course_id"
        case title, author, price
        case specialPrice = "special_price"
        case desc, img, slug, vid
        case totalQuiz = "total_quiz"
        case totalPdf = "total_pdf"
        case vidPre = "vid_pre"
        case materi
    }
}

// MARK: - Materi
struct Materi: Decodable {
    let material: String?
    let submaterial: String?
    let video: String?
    let pdf: String?
    let materialID: String?
    let quizDuration: String

    enum CodingKeys: String, CodingKey {
        case material, submaterial, video, pdf
        case materialID = "material_id"
        case quizDuration = "quiz_duration"
    }
}
