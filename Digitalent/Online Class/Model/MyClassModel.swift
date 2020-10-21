//
//  MyClassModel.swift
//  Digitalent
//
//  Created by Teke on 21/10/20.
//

import Foundation

// MARK: - TopicDetailAction
struct MyClassModel: Decodable {
    let success: Bool
    let code: Int
    let message: String
    let data: [ClassDataModel]
    let request: MyClassRequest
}

// MARK: - Datum
struct ClassDataModel: Decodable {
    let transactionID, scheduleID, quantity, certificateName: String?
    let voucID: String?
    let userID, totalPayment, transactionStatus, createdAt: String?
    let expiredAt: String?
    let updateAt: String?
    let courseTitle, courseDesc, courseContent, coursePrice: String?
    let courseSpecialPrice: String?
    let cityID, provinceID, courseCatID, courseID: String?
    let courseCatSlug, courseSubCatID, courseTypeID, courseStatus: String?
    let courseSlug, courseImage: String?
    let courseVid, courseVenue: String?
    let courseDate, courseStart, courseEnd, timeStart: String?
    let timeEnd, statusevent, courseVoucher, materialID: String?
    let subMaterialID, subMaterialSectionName, subMaterialAttachment, subMaterialFile: String?
    let subMaterialDuration, videosu, totalQuiz, totalVideo: String?
    let totalPDF: String?

    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case scheduleID = "schedule_id"
        case quantity
        case certificateName = "certificate_name"
        case voucID = "vouc_id"
        case userID = "user_id"
        case totalPayment = "total_payment"
        case transactionStatus = "transaction_status"
        case createdAt = "created_at"
        case expiredAt = "expired_at"
        case updateAt = "update_at"
        case courseTitle = "course_title"
        case courseDesc = "course_desc"
        case courseContent = "course_content"
        case coursePrice = "course_price"
        case courseSpecialPrice = "course_special_price"
        case cityID = "city_id"
        case provinceID = "province_id"
        case courseCatID = "course_cat_id"
        case courseID = "course_id"
        case courseCatSlug = "course_cat_slug"
        case courseSubCatID = "course_sub_cat_id"
        case courseTypeID = "course_type_id"
        case courseStatus = "course_status"
        case courseSlug = "course_slug"
        case courseImage = "course_image"
        case courseVid = "course_vid"
        case courseVenue = "course_venue"
        case courseDate = "course_date"
        case courseStart = "course_start"
        case courseEnd = "course_end"
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case statusevent
        case courseVoucher = "course_voucher"
        case materialID = "material_id"
        case subMaterialID = "sub_material_id"
        case subMaterialSectionName = "sub_material_section_name"
        case subMaterialAttachment = "sub_material_attachment"
        case subMaterialFile = "sub_material_file"
        case subMaterialDuration = "sub_material_duration"
        case videosu
        case totalQuiz = "total_quiz"
        case totalVideo = "total_video"
        case totalPDF = "total_pdf"
    }
}

// MARK: - Request
struct MyClassRequest: Decodable {
    let uid: String
}
