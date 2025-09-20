//
//  RefreshTokenPayload.swift
//  hello
//
//  Created by prchou on 2025/8/9.
//

import Vapor
import JWT
import Foundation


struct RefreshTokenPayload: JWTPayload {
    
    var sub: SubjectClaim
    var jti: IDClaim
    var exp: ExpirationClaim
    var deviceID: String
    var tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case sub, exp, jti
        case deviceID = "device_id"
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
        deviceID: String,
        expirationTime: Double = 5 * 24 * 60 * 60 // 5 days
    ) {
        self.sub = SubjectClaim(value: userID)
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
        self.jti = IDClaim(value: UUID().uuidString)
        self.deviceID = deviceID
        self.tokenType = "refresh_token"
    }
}


extension RefreshTokenPayload {
    
    static func of(userID: String, deviceID: String) -> RefreshTokenPayload {
        return RefreshTokenPayload(
            userID: userID, deviceID: deviceID
        )
    }
    
}
