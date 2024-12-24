//
//  WebView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 24/12/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  @State var text: String
   
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
   
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(text, baseURL: nil)
  }
}
