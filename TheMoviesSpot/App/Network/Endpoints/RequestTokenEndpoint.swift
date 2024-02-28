//
//  RequestTokenEndpoint.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-02-28.
//

import Foundation

enum RequestTokenEndpoint: EndpointProtocol {
    case getToken

    var absoluteURL: String {
        return baseURL + "/3/authentication/token/new"
    }

    var parameters: [String : String] {
        return [:]
    }
}
