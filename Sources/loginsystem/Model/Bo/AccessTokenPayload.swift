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
    var exp: ExpirationClaim
    var iat: IssuedAtClaim
    var iss: IssuerClaim
    var aud: AudienceClaim
    var jti: IDClaim
    
    // customize Claims
    var userID: String
    var provider: Provider
    var providerID: String
    var tokenType: String
    
    
    
    enum ClaimEnum: String, CodingKey {
        case sub, exp, iat, iss, jti, aud
        case userID = "user_id"
        case email
        case provider
        case providerID = "provider_id"
        case tokenType = "token_type"
    }
    
    func verify(using signer: JWTKit.JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
    
    init(
        userID: String,
        provider: Provider,
        providerID: String,
        issuer: String,
        audience: String,
        expirationTime: Double = 15 * 60 // 15 mins
    ) {
        let now = Date()
        self.sub = SubjectClaim(value: userID)
        self.exp = ExpirationClaim(value: now.addingTimeInterval(expirationTime))
        self.iat = IssuedAtClaim(value: now)
        self.iss = IssuerClaim(value: issuer)
        self.jti = IDClaim(value: UUID().uuidString)
        self.aud = AudienceClaim(value: audience)
        self.userID = userID
        self.provider = provider
        self.providerID = providerID
        self.tokenType = "access"
    }
    
    
}
