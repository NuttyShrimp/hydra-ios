//
//  APIService.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 30/12/2024.
//

import Foundation

struct APIService {
    static func fetch<T: Decodable>(_ type: T.Type, url: URL?, decoder: JSONDecoder = CustomDecoder()) async throws -> T {
        guard let url = url else {
            throw APIError.badURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode)
            {
                throw APIError.badResponse(statusCode: response.statusCode)
            }

            do {
                let result = try decoder.decode(type, from: data)
                return result
            } catch {
                throw APIError.parsing(error as? DecodingError)
            }

        } catch {
            if let error = error as? URLError {
                throw APIError.url(error)
            } else {
                throw APIError.unknown(error)
            }
        }
    }
    
    /// Send a post request without any data & expects nothing in return
    static func execute(url: URL?) async throws {
        guard let url = url else {
            throw APIError.badURL
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode)
            {
                throw APIError.badResponse(statusCode: response.statusCode)
            }
        } catch {
            if let error = error as? URLError {
                throw APIError.url(error)
            } else {
                throw APIError.unknown(error)
            }
        }
    }
    
    /// Send a post request with any data & expects nothing in return
    static func execute(url: URL?, body: String, headers: [String : String] = [:]) async throws {
        guard let url = url else {
            throw APIError.badURL
        }
        do {
            var request = URLRequest(url: url)
            request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = body.data(using: .utf8)
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode)
            {
                throw APIError.badResponse(statusCode: response.statusCode)
            }
        } catch {
            if let error = error as? URLError {
                throw APIError.url(error)
            } else {
                throw APIError.unknown(error)
            }
        }
    }
}
