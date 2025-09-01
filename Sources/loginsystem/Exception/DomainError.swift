//
//  DomainError.swift
//  loginsystem
//
//  Created by prchou on 2025/8/16.
//

import Vapor

enum DomainError: Error {
    
    case userNotFoundError
    case expiredTokenError
    case tokenRevokedError
    case registerFailedError
    case userAlreadyExistedError
    case validationFailedError
    case invalidProviderError
}


extension DomainError: AbortError {
    
    var status: HTTPStatus {
        switch self {
        case .userNotFoundError: return .notFound
        case .expiredTokenError: return .unauthorized
        case .tokenRevokedError: return .unauthorized
        case .registerFailedError: return .badRequest
        case .userAlreadyExistedError: return .badRequest
        case .validationFailedError: return .unauthorized
        case .invalidProviderError: return .badRequest
            
        }
    }
        
    var reason: String {
        switch self {
            case .userNotFoundError: return "User not found."
            case .expiredTokenError: return "Token Expired. Please login again."
            case .tokenRevokedError: return "Token is revoked. Please login again."
            case .registerFailedError: return "Register Fail. Please try again later."
            case .userAlreadyExistedError: return "User already existed. Please login."
            case .validationFailedError: return "Validation Failed."
            case .invalidProviderError: return "Invalid Provider. Please login with correct way."
        }
    }
}
