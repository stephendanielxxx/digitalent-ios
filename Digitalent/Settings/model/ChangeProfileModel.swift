//
//  ChangeProfileModel.swift
//  Digitalent
//
//  Created by Teke on 12/11/20.
//

import Foundation

class ChangeProfileModel: Decodable {
    let code: String
    let newImage: String?
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case newImage = "new_image"
        case message = "message"
    }
}
