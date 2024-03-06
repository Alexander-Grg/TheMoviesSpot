//
//  SessionEnpoint.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-03-06.
//

import Foundation

enum SessionEnpoint: EndpointProtocol {
    case getToken
    case getSession(token: String)

    var absoluteURL: String {
        switch self {
        case .getToken:
            return baseURL + "/3/authentication/token/new"
        case .getSession:
            return baseURL + "/3/authentication/session/new"
        }
    }

    var parameters: [String : String] {

        switch self {
        case .getToken:
            return [:]
        case let .getSession(token):
            return ["request_token": token]
        }
    }
}
