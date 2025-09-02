//
//  LoginUsecaseImpl.swift
//  loginsystem
//
//  Created by prchou on 2025/8/31.
//
import Vapor
import FluentKit

struct UserLoginUsecaseImpl: LoginUsecase {
    
    let userCrudRepository: any UserCrudRepository
    let userRepository: any UserQueryRepository
    let refreshTokenRepository: any RefreshTokenService
    let jwtAccessTokenService: any JwtAccessTokenService

    init(userCrudRepository: any UserCrudRepository,  userRepository: any UserQueryRepository, refreshTokenRepository: any RefreshTokenService, jwtAccessTokenService: any JwtAccessTokenService) {
        self.userCrudRepository = userCrudRepository
        self.userRepository = userRepository
        self.refreshTokenRepository = refreshTokenRepository
        self.jwtAccessTokenService = jwtAccessTokenService
    }
    
    func execute(_ input: LoginInput, database: any Database) async throws -> LoginOutput {
        
        let authPricipal = input.authPricipal;
        let deviceID : String = input.deviceID
        
        var user: UserEntity? = try await userRepository.findUser(authPricipal.provider.rawValue, authPricipal.providerID, on: database)
        
        if user == nil {
            user = try await userCrudRepository.createUser(email: authPricipal.email,
                                                           username: authPricipal.username,
                                                           provider: authPricipal.provider.rawValue,
                                                           providerID: authPricipal.providerID ,
                                                           avatarURL: authPricipal.avatarURL,
                                                           database: database)
        }
        
        guard let user else {
            throw DomainError.userNotFoundError
        }
        
        let userProfile : UserProfile = DomainMapper.toDomain(user: user)
        
        let accessToken = try jwtAccessTokenService.issueAccessToken(
            userID: userProfile.id,
            provider: userProfile.provider,
            providerID: userProfile.providerID
        )
        
        let refreshToken = try await refreshTokenRepository.issueRefreshToken(
            userID: userProfile.id,
            provider: userProfile.provider,
            providerID: userProfile.providerID,
            with: deviceID,
            database: database
        )
        
        return LoginOutput(
            userProfile: userProfile,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
        
    }
    
    
}

extension Application {
    
    var userLoginUsecase: any LoginUsecase {
        UserLoginUsecaseImpl(
            userCrudRepository: self.userCrudRepository,
            userRepository: self.userQueryRepository, refreshTokenRepository: self.refreshTokenService, jwtAccessTokenService: self.jwtService
        )
    }
    
    
}
