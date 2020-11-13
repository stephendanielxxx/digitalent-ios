//
//  GetCityModel.swift
//  Digitalent
//
//  Created by Teke on 13/11/20.
//

import Foundation

struct GetCityModel: Decodable {
    let city: [CityModel]

    enum CodingKeys: String, CodingKey {
        case city = "City"
    }
}

struct CityModel: Codable {
    let cityID, provinceID, cityName: String
    let cityStatus: String

    enum CodingKeys: String, CodingKey {
        case cityID = "city_id"
        case provinceID = "province_id"
        case cityName = "city_name"
        case cityStatus = "city_status"
    }
}
