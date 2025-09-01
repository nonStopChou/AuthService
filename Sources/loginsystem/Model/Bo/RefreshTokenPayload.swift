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
    var exp: ExpirationClaim
    var iat: IssuedAtClaim
    var iss: IssuerClaim
    var aud: AudienceClaim
    var jti: IDClaim
    
    var userID: String
    var provider: Provider
    var providerID: String
    var deviceID: String
    var tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case sub, exp, iat, iss, jti, aud
        case userID = "user_id"
        case deviceID = "device_id"
        case provider
        case providerID = "provider_id"
        case tokenType = "token_type"
    }
    
    
    func verify(using signer: JWTKit.JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
    
    init(
        jti: String,
        userID: String,
        provider: Provider,
        providerID: String,
        deviceID: String,
        issuer: String,
        audience: String,
        expirationTime: Double = 5 * 24 * 60 * 60 // 5 days
    ) {
        let now = Date()
        self.sub = SubjectClaim(value: userID)
        self.exp = ExpirationClaim(value: now.addingTimeInterval(expirationTime))
        self.iat = IssuedAtClaim(value: now)
        self.iss = IssuerClaim(value: issuer)
        self.jti = IDClaim(value: jti)
        self.aud = AudienceClaim(value: audience)
        self.userID = userID
        self.provider = provider
        self.providerID = providerID
        self.deviceID = deviceID
        self.tokenType = "Bearer"
    }
}
