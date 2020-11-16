//
//  GetProvinceModel.swift
//  Digitalent
//
//  Created by Teke on 13/11/20.
//

import Foundation

struct GetProvinceModel: Decodable {
    let province: [ProvinceModel]

    enum CodingKeys: String, CodingKey {
        case province = "Province"
    }
}

struct ProvinceModel: Decodable {
    let provinceID, provinceName: String
    let provinceStatus: String

    enum CodingKeys: String, CodingKey {
        case provinceID = "province_id"
        case provinceName = "province_name"
        case provinceStatus = "province_status"
    }
}
