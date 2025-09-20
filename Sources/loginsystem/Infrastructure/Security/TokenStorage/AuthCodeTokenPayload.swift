//
//  AuthCodeTokenPayload.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//

import Vapor
import JWT
import Foundation

struct AuthCodeTokenPayload : JWTPayload {
    
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
        expirationTime: Double = 5 * 60 // 5 mins
    ) {
        self.sub = SubjectClaim(value: userID)
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
        self.jti = IDClaim(value: UUID().uuidString)
        self.deviceID = deviceID
        self.tokenType = "auth_code"
    }
}




extension AuthCodeTokenPayload {
    
    static func of(userID: String, deviceID: String) -> AuthCodeTokenPayload {
        return AuthCodeTokenPayload(
            userID: userID, deviceID: deviceID
        )
    }
    
}
