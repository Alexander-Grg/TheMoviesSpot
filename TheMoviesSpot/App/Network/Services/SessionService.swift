//
//  SessionService.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-02-28.
//

import Foundation
import Combine

struct SessionServiceKey: InjectionKey {
   static var currentValue: SessionServiceProtocol = SessionService()
}

protocol SessionServiceProtocol: AnyObject {
    func requestToken() -> AnyPublisher<Data, Error>
    func requestSession(token: String) -> AnyPublisher<Data, Error>
}

final class SessionService: SessionServiceProtocol {

    private let apiProvider = APIProvider<SessionEnpoint>()

    func requestToken() -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getToken)
            .eraseToAnyPublisher()
    }

    func requestSession(token: String) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getSession(token: token))
            .eraseToAnyPublisher()
    }
}
