//
//  LoginView-ViewModel.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-02-28.
//

import Foundation
import KeychainAccess
import Combine

extension LoginView {
    final class ViewModel: ObservableObject {
        let keychain = Keychain()
        private var cancellable = Set<AnyCancellable>()
        @Injected (\.sessionService) var sessionService: SessionServiceProtocol
        @Published var isStarted = false
        @Published var isSignInStarted = false
        @Published var isTokenReceived = false
        @Published var goLoginWebView = false
        @Published var sessionAndtokenAreSaved = false
        @Published var loginText = ""
        @Published var password = ""
        @Published var validationMessage = ""

        func getToken() {
                sessionService.requestToken()
                    .decode(type: RequestToken.self, decoder: JSONDecoder())
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { error in
    //                    MARK: Add alert here and logout in case of fail
                        print(error)
                    },
                          receiveValue: { [weak self] value in
                        guard let self = self else { return }
                        do {
                            try keychain.set(value.token, key: "requestToken")
                            self.isTokenReceived = true
                            self.goLoginWebView = true
                        } catch {
                            print("Saving to the keychain is failed")
                        }
                    }).store(in: &cancellable)
            }

        func checkOnTokenAndSession() {
            guard let token = try? Keychain().get("requestToken"),
                  let session = try? Keychain().get("sessionID"),
                  !token.isEmpty,
                  !session.isEmpty
            else { return }
            self.sessionAndtokenAreSaved = true
        }

        func removeTokenAndSession() {
            try? keychain.removeAll()
        }
    }
}
