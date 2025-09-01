//
//  HttpError.swift
//  loginsystem
//
//  Created by prchou on 2025/8/16.
//

import Vapor

enum HttpError: Error {
    
    case badRequest
    case unauthorized
    case internalServerError
    case headerNotFoundError(header: String)
}

extension HttpError: AbortError {
    
    var status: HTTPStatus {
        switch self {
        case .badRequest: return .badRequest
        case .unauthorized: return .unauthorized
        case .internalServerError: return .internalServerError
        case .headerNotFoundError: return .badRequest
        }
    }
        
    var reason: String {
        switch self {
        case .badRequest: return "Bad Request."
        case .unauthorized: return "Unauthorized."
        case .internalServerError: return "Internal Server Error."
        case .headerNotFoundError(let header): return "No \(header) header found."
        }
    }

}


