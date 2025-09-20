//
//  JWTProfile.swift
//  hello
//
//  Created by prchou on 2025/8/9.
//

import Vapor
import JWT
import Foundation

struct AccessTokenPayload: JWTPayload {
    
    // Statndard JWT Claims
    var sub: SubjectClaim
    var jti: IDClaim
    var exp: ExpirationClaim
    
    // customize
    var tokenType: String
    
    
    enum ClaimEnum: String, CodingKey {
        case sub, exp, jti
        case tokenType = "token_type"
    }
    
    func verify(using signer: JWTKit.JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
    
    func getUserID() -> String {
        return sub.value
    }
    
    
    init(
        userID: String,
        expirationTime: Double = 15 * 60 // 15 mins
    ) {
        self.sub = SubjectClaim(value: userID)
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
        self.jti = IDClaim(value: UUID().uuidString)
        self.tokenType = "access_token"
    }
    
    
}



extension AccessTokenPayload {
    
    static func of(userID: String) -> AccessTokenPayload {
        return AccessTokenPayload(
            userID: userID
        )
    }
    
}
