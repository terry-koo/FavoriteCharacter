//
//  APIRouter.swift
//  FavoriteCharacter
//
//  Created by Terry Koo on 10/28/23.
//

import Foundation

protocol APIRouter {
    var baseURL: URL { get }
    var path: String { get }
    var method: String { get }
    var parameters: [String: Any] { get }
}

extension APIRouter {
    func asURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }

        guard let finalURL = components?.url else {
            fatalError("Failed to construct URL")
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method
        return request
    }
}
