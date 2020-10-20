//
//  BannerModel.swift
//  Digitalent
//
//  Created by Teke on 16/10/20.
//

import Foundation

struct BannerModel: Decodable {
    let banner: [Banner]
}

struct Banner: Decodable {
    let id, name, image, status: String
    let url: String
}
