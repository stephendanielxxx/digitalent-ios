// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct DeleteModel: Decodable {
    let info, message: String

    enum CodingKeys: String, CodingKey {
        case info = "Info"
        case message = "Message:"
    }
}

