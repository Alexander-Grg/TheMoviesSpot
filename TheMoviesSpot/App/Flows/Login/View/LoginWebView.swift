//
//  LoginWebView.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-03-04.
//

import SwiftUI
import WebKit
import KeychainAccess
import Combine

struct LoginWebView: View {
    let keychain = Keychain()
    @State private var webViewURL: URL?

    var body: some View {
        WebView(url: webViewURL)
            .onAppear {
                loadWebView()
            }
    }

    func loadWebView() {
        var components = URLComponents()
        let token = try? keychain.get("requestToken")
        components.scheme = "https"
        components.host = "www.themoviedb.org"
        components.path = "/authenticate/" + (token ?? "")

        webViewURL = components.url
    }
}

struct WebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        @Injected (\.sessionService) var sessionService: SessionServiceProtocol
        private var cancellable = Set<AnyCancellable>()
        let keychain = Keychain()
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationResponse: WKNavigationResponse,
                     decisionHandler: @escaping (WKNavigationResponsePolicy)
                     -> Void) {
            if let response = navigationResponse.response as? HTTPURLResponse {
                let headers = response.allHeaderFields
                let token = try? keychain.get("requestToken")
                let desiredHeaderKey = "authentication-callback"
                if let authCallbackHeader = headers[desiredHeaderKey] as? String {
                    if !authCallbackHeader.isEmpty {
//                        MARK: CALL here the request for Session
                        sessionService.requestSession(token: token ?? "")
                            .decode(type: Session.self, decoder: JSONDecoder())
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { error in
                                print(error)
                            },
                                  receiveValue: { [weak self] value in
                                guard let self = self else { return }
                                do {
                                    try keychain.set(value.session_id, key: "sessionID")
                                } catch {
                                    print("Saving the sessionID to the keychain has failed")
                                }
                            }).store(in: &cancellable)
                        }
                              }
                              }
            decisionHandler(.allow)
                              }
    }
}
