//
//  Session.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-03-06.
//

import Foundation

struct Session: Codable {
    let success: Bool
    let session_id: String

    enum CodingKeys: String, CodingKey {
        case success
        case session_id
    }
}
