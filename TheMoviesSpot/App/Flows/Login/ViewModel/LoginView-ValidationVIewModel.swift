//
//  LoginView-ValidationVIewModel.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-02-28.
//

import SwiftUI
import Combine

enum PasswordValidation {
    case valid
    case invalidLength
    case weakPassword
}

extension LoginView {

    final class LoginValidationForm: ObservableObject {
        @Published var login = ""
        @Published var password = ""
        @Published var passwordConfirmation = ""

        @Published var isValid = false
        @Published var loginError = ""
        @Published var passwordError = ""
        @Published var passwordConfirmationError = ""

        private var cancellable: Set<AnyCancellable> = []

        private var validUsernamePublisher: AnyPublisher<Bool, Never> {
            $login
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .map { $0.count >= 8 }
                .eraseToAnyPublisher()
        }

        private var passwordLengthPublisher: AnyPublisher<Bool, Never> {
            $password
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .map { $0.count >= 12 }
                .eraseToAnyPublisher()
        }

        private var passwordStrengthPublisher: AnyPublisher<Bool, Never> {
            $password
                .debounce(for: 0.2, scheduler: RunLoop.main)
                .removeDuplicates()
                .map {password in password.isPasswordStrong }
                .eraseToAnyPublisher()
        }

        private var validPasswordPublisher: AnyPublisher<PasswordValidation, Never> {
            Publishers
                .CombineLatest(passwordLengthPublisher, passwordStrengthPublisher)
                .map { validLength, validStrength in
                    if !validLength {
                        return .invalidLength
                    }
                    if !validStrength {
                        return .weakPassword
                    }

                    return .valid
                }
                .eraseToAnyPublisher()
        }

        private var validConfirmPasswordPublisher: AnyPublisher<Bool, Never> {
            Publishers
                .CombineLatest($password, $passwordConfirmation)
                .debounce(for: 0.2, scheduler: RunLoop.main)
                .map { pass, confirmPass in
                    pass == confirmPass
                }
                .eraseToAnyPublisher()
        }

        private var validFormPublisher: AnyPublisher<Bool, Never> {
            Publishers
                .CombineLatest3(validUsernamePublisher, validPasswordPublisher, validConfirmPasswordPublisher)
                .map { usernameValid, passwordValid, confirmPassValid in
                    usernameValid && (passwordValid == .valid) && confirmPassValid
                }
                .eraseToAnyPublisher()
        }

        init() {
            validUsernamePublisher
                .receive(on: RunLoop.main)
                .map { $0 ? "" : "Username must be 8 or more characters long."}
                .assign(to: \.loginError, on: self)
                .store(in: &cancellable)

            validPasswordPublisher
                .receive(on: RunLoop.main)
                .map { passValidation in
                    switch passValidation {
                    case .invalidLength:
                        return "Password must be 12 or more characters long."
                    case .weakPassword:
                        return "Password is weak."
                    default:
                        return ""
                    }
                }
                .assign(to: \.passwordError, on: self)
                .store(in: &cancellable)

            validConfirmPasswordPublisher
                .receive(on: RunLoop.main)
                .map { $0 ? "" : "Passwords must be equal."}
                .assign(to: \.passwordConfirmationError, on: self)
                .store(in: &cancellable)

            validFormPublisher
                .receive(on: RunLoop.main)
                .assign(to: \.isValid, on: self)
                .store(in: &cancellable)
        }
    }
}

    extension String {
        var isPasswordStrong: Bool {
            containsCharSet(set: .uppercaseLetters) &&
            containsCharSet(set: .lowercaseLetters) &&
            containsCharSet(set: .decimalDigits) &&
            containsCharSet(set: .alphanumerics.inverted)
        }

        private func containsCharSet(set: CharacterSet) -> Bool {
            rangeOfCharacter(from: set) != nil
        }
    }
