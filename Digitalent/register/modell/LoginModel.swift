// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct LoginModel: Decodable {
    let user: [User]?
    let message: String
}

// MARK: - User
struct User: Decodable {
    let id, firstName, lastName, address: String
    let province, city, poscode, kelas: String
    let lastEducation, selectJob, institution, email: String
    let gender, birthDate, phone, tempatlahir: String
    let userPhoto, userPhotoStatus, userProfile, about: String
    let isTeacher: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case address, province, city, poscode, kelas
        case lastEducation = "last_education"
        case selectJob = "select_job"
        case institution, email, gender
        case birthDate = "birth_date"
        case phone, tempatlahir
        case userPhoto = "user_photo"
        case userPhotoStatus = "user_photo_status"
        case userProfile = "user_profile"
        case about, isTeacher
    }
}

