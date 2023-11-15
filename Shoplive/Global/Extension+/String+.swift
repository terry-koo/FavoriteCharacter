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
}
