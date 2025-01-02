//
//  APIError.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 30/12/2024.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown(Error)
    
    var localizedDescription: String {
        // user feedback
        switch self {
        case .badURL, .parsing, .unknown:
            return "Sorry, something went wrong."
        case .badResponse(_):
            return "Sorry, the connection to our server failed."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
        }
    }
    
    var description: String {
        //info for debugging
        switch self {
        case .unknown(let error): return "unknown error: \(error)"
        case .badURL: return "invalid URL"
        case .url(let error):
            return "\(error )"
        case .parsing(let error):
            return "parsing error \(error)"
        case .badResponse(statusCode: let statusCode):
            return "bad response with status code \(statusCode)"
        }
    }
}
