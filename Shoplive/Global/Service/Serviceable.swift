//
//  Serviceable.swift
//  Shoplive
//
//  Created by Terry Koo on 11/15/23.
//

import Foundation

protocol Serviceable { }

extension Serviceable {
    func makeRequest<T: Decodable>(with request: URLRequest, completion: @escaping (T?, APIError?) -> Void) {
        var attempts = 0
        let maxAttempts = 3
        let retryInterval: TimeInterval = 2.0

        func performRequest() {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    retryOrComplete(with: .urlSessionError(error.localizedDescription))
                    return
                }

                if let resp = response as? HTTPURLResponse, resp.statusCode > 299 {
                    print("Server Error: \(resp.statusCode)")
                    retryOrComplete(with: .serverError())
                    return
                }

                guard let data = data else {
                    print("Invalid Response")
                    retryOrComplete(with: .invalidResponse())
                    return
                }

                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(result, nil)
                } catch let err {
                    print("Decoding Error: \(err)")
                    retryOrComplete(with: .decodingError())
                }
            }.resume()
        }

        func retryOrComplete(with error: APIError) {
            attempts += 1
            if attempts < maxAttempts {
                retryAfterInterval(retryInterval, action: performRequest)
            } else {
                completion(nil, error)
            }
        }

        func retryAfterInterval(_ interval: TimeInterval, action: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: action)
        }

        // 초기 요청 수행
        performRequest()
    }
}
