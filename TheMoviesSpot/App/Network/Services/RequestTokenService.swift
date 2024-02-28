//
//  RequestTokenService.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-02-28.
//

import Foundation
import Combine

struct RequestTokenServiceKey: InjectionKey {
   static var currentValue: RequestTokenProtocol = RequestTokenService()
}

protocol RequestTokenProtocol: AnyObject {
    func requestToken() -> AnyPublisher<Data, Error>
}

final class RequestTokenService: RequestTokenProtocol {

    private let apiProvider = APIProvider<RequestTokenEndpoint>()

    func requestToken() -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getToken)
            .eraseToAnyPublisher()
    }
}
