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
}
