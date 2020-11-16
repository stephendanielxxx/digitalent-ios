//
//  NotificationModel.swift
//  Digitalent
//
//  Created by Teke on 20/10/20.
//

import Foundation

struct NotificationModel: Decodable {
    let notif: [NotifModel]
}

// MARK: - Notif
struct NotifModel: Decodable {
    let id, notifName, notifDescription, notifImage: String

    enum CodingKeys: String, CodingKey {
        case id
        case notifName = "notif_name"
        case notifDescription = "notif_description"
        case notifImage = "notif_image"
    }
}
