//
//  HomeProfileModel.swift
//  Digitalent
//
//  Created by Teke on 20/10/20.
//

import Foundation


// MARK: - TopicDetailAction
struct HomeProfileModel: Decodable {
    let profil: [HomeProfile]
}

// MARK: - Profil
struct HomeProfile: Decodable {
    let firstName, lastName, email, username: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email, username
    }
}
