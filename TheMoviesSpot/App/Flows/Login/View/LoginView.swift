//
//  LoginView.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-02-28.
//

import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var viewModel = ViewModel()
    @ObservedObject var validationViewModel = LoginValidationForm()

    var body: some View {
        NavigationStack() {
            ZStack {
                VStack(alignment: .center) {
                    Text("Movie Reviewer App")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Find your favourite movies!")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    if viewModel.isStarted && viewModel.isTokenReceived == false {
                        Button("Sign in") {
                            viewModel.getToken()
                        }
                        .buttonStyle(.borderedProminent)


                        Button("Log in as a guest") {
                        }
                        .buttonStyle(.bordered)
                        Button("First time here? Sign up!") {

                        }
                        .buttonStyle(.borderless)
                    } else if viewModel.isStarted && viewModel.isTokenReceived {
                        Text("Enter your login & password to proceed")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                        TextField("Login", text: $validationViewModel.login)
                            .multilineTextAlignment(.center)
                        SecureField("Password", text: $validationViewModel.password)
                            .multilineTextAlignment(.center)
                    }
                    else {
                        Button("Get started!", systemImage: "popcorn") {
                            viewModel.isStarted.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
