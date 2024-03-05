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
                    } else {
                        Button("Get started!", systemImage: "popcorn") {
                            viewModel.isStarted.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                Spacer()
            }
        }.navigationDestination(isPresented: $viewModel.goLoginWebView) {
            LoginWebView()
        }
    }
}

#Preview {
    LoginView()
}
