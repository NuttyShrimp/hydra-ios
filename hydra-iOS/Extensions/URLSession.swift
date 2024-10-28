//
//  URLSession.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 22/10/2024.
//

import Foundation

extension URLSession {
    func fetchData<T: Decodable>(at url: String) async throws -> T {
            guard let url = URL(string: url) else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]) }

            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server error"])
            }

            let users = try JSONDecoder().decode(T.self, from: data)
            return users
    }
}
