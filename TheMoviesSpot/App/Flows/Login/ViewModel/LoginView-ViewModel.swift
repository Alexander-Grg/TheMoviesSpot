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
        private var cancellable = Set<AnyCancellable>()
        @Published var isStarted = false
        @Published var isSignInStarted = false
        @Published var isValid = false
        @Published var loginText = ""
        @Published var password = ""
        @Published var validationMessage = ""

    }
}
