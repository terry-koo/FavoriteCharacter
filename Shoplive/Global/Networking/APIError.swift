//
//  APIError.swift
//  Jobplanet
//
//  Created by Terry Koo on 10/28/23.
//

import Foundation

enum APIError: Error {
    case urlSessionError(String = "URLSession error")
    case serverError(String = "Server error")
    case invalidResponse(String = "Invalid response from server")
    case decodingError(String = "Error parsing server response")
}
