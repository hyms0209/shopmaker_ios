//
//  MainVC+WKWebViewDelegate.swift
//  2023/05/18
//
//  Created by MYONHYUP LIM on 2022/09/04.
//

import Foundation
import UIKit
import WebKit

var lotteAutoLeaseIf = ["lotteautoleaseif"]

extension MainVC : WKUIDelegate, WKNavigationDelegate {
    
    /**
     *  웹뷰의 URL이 거쳐가는 경로 이곳에서 URL을 이동 시킬지 네이티브 처리를 할지 결정
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { decisionHandler(.cancel); return }
        if url.scheme == "http" || url.scheme ==  "https"{
            let fileName = url.lastPathComponent
            if fileName.hasSuffix(Constants.FileType.PDF) {
                fileDownload(url: url)
                decisionHandler(.cancel)
                return
            } else {
                // url이 네이티브에서 여는작업이 아닌 경우, webView에서 열리도록 .allow
                decisionHandler(.allow)
            }
        } else {
            // 웹뷰 인터페이스인 경우
            if let scheme = url.scheme, lotteAutoLeaseIf.contains(scheme) {
                processInterface(url:url)
            } else {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            decisionHandler(.cancel)
            return
        }
    }
    
    func processInterface(url: URL) {
        guard let interface = WebAppInterfaceEnum(rawValue: url.host ?? "") else {
            return
        }
        
        let components = URLComponents(string: url.absoluteString)
        var items = [String: String]()
        components?.queryItems?.forEach { items[$0.name] = $0.value }
        
        switch interface {
            // 로그인 정보 요청
        case .fileDownload: fileDownload(url: url)
        case .bioauth: bioAuth()
        default: break
        }
    }
}

extension MainVC : WebAppInterface {
    
    func bioAuth() {
        viewModel?.input.bioAuth()
    }
    
    func fileDownload(url: URL) {
        viewModel?.input.downloadFile(url: url)
    }
}

protocol WebAppInterface {
    /// 로그인 정보 요청
    func fileDownload(url: URL)
    /// 생체인증
    func bioAuth()
}



enum WebAppInterfaceEnum: String {
    /// 파일 다운로드
    case fileDownload
    /// 생체인증
    case bioauth
}
