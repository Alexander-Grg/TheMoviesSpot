//
//  TheRequestToken.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-02-28.
//

import Foundation

struct RequestToken: Codable {

    let token: String
    let expirationDate: String

    enum CodingKeys: String, CodingKey {
        case token = "request_token"
        case expirationDate = "expires_at"
    }
}
