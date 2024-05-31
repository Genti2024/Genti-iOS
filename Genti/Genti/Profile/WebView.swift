//
//  WebView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.addSubview(activityIndicator)
        activityIndicator.color = .gentiGreen
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.parent.activityIndicator.startAnimating()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.parent.activityIndicator.stopAnimating()
        }
    }
}

#Preview {
    WebView(urlString: "https://stealth-goose-156.notion.site/5e84488cbf874b8f91e779ea4dc8f08a")
}
