//
//  LoginWebView.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-03-04.
//

import SwiftUI
import WebKit
import KeychainAccess

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
//        components.queryItems = [
//            URLQueryItem(name: "redirect_to", value: "https://www.themoviedb.org/authenticate/\(token ?? "")?redirect_to=http://www.MovieObserver.com/approved)")
//        ]

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
        let keychain = Keychain()
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        // Implement any necessary WKNavigationDelegate methods here

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationResponse: WKNavigationResponse,
                     decisionHandler: @escaping (WKNavigationResponsePolicy)
                     -> Void) {
            if let response = navigationResponse.response as? HTTPURLResponse {
                  let headers = response.allHeaderFields
                let desiredHeaderKey = "authentication-callback"
                if let authCallbackHeader = headers[desiredHeaderKey] as? String {
                    do {
                        try keychain.set(authCallbackHeader, key: "SessionID")
                    } catch {
                        print("The session has not been saved")
                    }
                }
              }
              decisionHandler(.allow)
           }
    }
}
