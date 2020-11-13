//
//  UpdateProfileModel.swift
//  Digitalent
//
//  Created by Teke on 13/11/20.
//

import Foundation

struct UpdateProfileModel: Decodable {
    let code: String
    let newImage: String?
    let message: String

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case newImage = "new_image"
        case message = "message"
    }
}
