//
//  EndpointProtocol.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-02-28.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var absoluteURL: String { get }
    var parameters: [String : String] { get }
}

extension EndpointProtocol {
    var baseURL: String {
        return "https://api.themoviedb.org"
    }
}
