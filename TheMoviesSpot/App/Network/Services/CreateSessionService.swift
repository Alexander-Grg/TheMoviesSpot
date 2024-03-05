//
//  CreateSessionService.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-03-01.
//

import Foundation
import Combine

struct CreateSessionServiceKey: InjectionKey {
   static var currentValue: CreateSessionProtocol = CreateSessionService()
}

protocol CreateSessionProtocol: AnyObject {
    func createSession(login: String, password: String, token: String) -> AnyPublisher<Data, Error>
}

final class CreateSessionService: CreateSessionProtocol {

    private let apiProvider = APIProvider<CreateSessionEndpoint>()

    func createSession(login: String, password: String, token: String) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .createSession(login: login, password: password, token: token))
            .eraseToAnyPublisher()
    }
}
