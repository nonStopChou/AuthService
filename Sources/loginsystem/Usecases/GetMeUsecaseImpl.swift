//
//  GetMeUsecaseImpl.swift
//  loginsystem
//
//  Created by prchou on 2025/9/14.
//
import Vapor
import FluentKit

struct GetMeUsecaseImpl: GetMeUsecase {
    
    let tokenService: any TokenService
    let userQueryRepository: any UserQueryRepository
    
    func execute(input: GetMeUsecaseInput, database: any Database) async throws -> GetMeUsecaseOutput {
        
        let accessTokenPayload : AccessTokenPayload = try tokenService.verifyAccessToken(accessToken: input.accessToken)
        
        let accessToken: AccessToken = DomainMapper.toDomain(payload: accessTokenPayload)
        
        if(try await tokenService.isKeyExist(key: AccessTokenKV.toKey(jti: accessToken.jti)) == false) {
            throw DomainError.expiredTokenError
        }
        
        let userID = accessTokenPayload.getUserID()
        
        guard let user : UserEntity = try await userQueryRepository.findUser(userID: userID, on: database) else {
            throw DomainError.userNotFoundError
        }
        
        return GetMeUsecaseOutput(userProfile: DomainMapper.toDomain(user: user))
        
    }
    
}





extension Application {
    
    var getMeUsecase: any GetMeUsecase {
        GetMeUsecaseImpl(
            tokenService: self.tokenService,
            userQueryRepository: self.userQueryRepository
        )
    }
    
}
