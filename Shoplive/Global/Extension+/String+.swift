//
//  String+.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation
import CryptoKit

extension String {
    func md5() -> String {
        if let data = self.data(using: .utf8) {
            let digest = Insecure.MD5.hash(data: data)
            return digest.map { String(format: "%02hhx", $0) }.joined()
        }
        return ""
    }
    
    func convertToHTTPS() -> String {
        // HTTP 문자열을 URL 객체로 변환
        if var urlComponents = URLComponents(string: self) {
            urlComponents.scheme = "https"
            
            // HTTPS로 변환된 URL 문자열 반환
            if let httpsURLString = urlComponents.url?.absoluteString {
                return httpsURLString
            }
        }
        return self
    }
}
