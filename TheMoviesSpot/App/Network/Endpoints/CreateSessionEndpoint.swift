//
//  CreateSessionEndpoint.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-02-28.
//

import Foundation
import KeychainAccess

enum CreateSessionEndpoint: EndpointProtocol {
    case createSession(login: String,
                       password: String,
                       token: String)

    var absoluteURL: String {
        return baseURL + "3/authentication/token/validate_with_login?"
    }

    var parameters: [String : String] {

        switch self {
        case let .createSession(login, password, token):
            return [
                "username" : login,
                "password" : password,
                "request_token" : token
            ]
        }
    }
}
