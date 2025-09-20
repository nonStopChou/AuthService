//
//  AuthCodeExchangeusecaseImpl.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import Vapor
import FluentKit

struct AuthCodeExchangeusecaseImpl: AuthCodeExchangeUsecase {
    
    let tokenService: any TokenService
    let userQueryRepository: any UserQueryRepository
    
    func execute(input: AuthCodeExchangeUsecaseInput, database: any Database) async throws -> AuthCodeExchangeUsecaseOutput {
        
        let authCodePayload: AuthCodeTokenPayload = try tokenService.verifyAuthCode(authCode: input.authCode)
        
        let authCode = DomainMapper.toDomain(payload: authCodePayload)
        
        
        if(try await tokenService.isKeyExist(key: AuthCodeKV.toKey(jti: authCode.jti)) == false) {
            throw DomainError.expiredTokenError
        }
        
        let userID = authCodePayload.getUserID()
        
        guard let user : UserEntity = try await userQueryRepository.findUser(userID: userID, on: database) else {
            throw DomainError.userNotFoundError
        }
        
        let newAccessTokenPayload = AccessTokenPayload.of(userID: authCodePayload.getUserID())
        let newRefreshTokenPayload = RefreshTokenPayload.of(userID: authCodePayload.getUserID(), deviceID: authCodePayload.deviceID)
        
        let newAccessToken = DomainMapper.toDomain(payload: newAccessTokenPayload)
        let newRefreshToken = DomainMapper.toDomain(payload: newRefreshTokenPayload)
        
        try await tokenService.saveToken(kvEntity: KvEntityMapper.toKvEntity(domain: newAccessToken, refreshJti: newRefreshToken.jti))
        try await tokenService.saveToken(kvEntity: KvEntityMapper.toKvEntity(domain: newRefreshToken))
        try await tokenService.saveSession(kvEntity: KvEntityMapper.toSessionKvEntity(domain: newRefreshToken))
        try await tokenService.deleteAuthCode(kvEntity: KvEntityMapper.toKvEntity(domain: authCode))
        
        let newAccessTokenStr: String = try tokenService.issueToken(payload: newAccessTokenPayload)
        let newRefreshTokenStr: String = try tokenService.issueToken(payload: newRefreshTokenPayload)
        
        return AuthCodeExchangeUsecaseOutput(userProfile: DomainMapper.toDomain(user: user), accessToken: newAccessTokenStr, refreshToken: newRefreshTokenStr)
        
    }
    
    
}



extension Application {
    
    var authCodeExchangeUsercase: any AuthCodeExchangeUsecase {
        AuthCodeExchangeusecaseImpl(
            tokenService: self.tokenService,
            userQueryRepository: self.userQueryRepository
        )
    }
    
}
