//
//  LoginUsecaseImpl.swift
//  loginsystem
//
//  Created by prchou on 2025/8/31.
//
import Vapor
import FluentKit

struct LoginUsecaseImpl: LoginUsecase {
    
    let userCrudRepository: any UserCrudRepository
    let userRepository: any UserQueryRepository
    let tokenService: any TokenService

    init(userCrudRepository: any UserCrudRepository,  userRepository: any UserQueryRepository, tokenService: any TokenService) {
        self.userCrudRepository = userCrudRepository
        self.userRepository = userRepository
        self.tokenService = tokenService
    }
    
    func execute(_ input: LoginUsecaseInput, database: any Database) async throws -> LoginUsecaseOutput {
        
        let authPricipal = input.authPricipal;
        let deviceID : String = input.deviceID
        
        var user: UserEntity? = try await userRepository.findUser(authPricipal.provider.rawValue, authPricipal.providerID, on: database)
        
        if user == nil {
            print("No User found. Create new one.")
            user = try await userCrudRepository.createUser(
                email: authPricipal.email,
                username: authPricipal.username,
                provider: authPricipal.provider.rawValue,
                providerID: authPricipal.providerID ,
                avatarURL: authPricipal.avatarURL,
                database: database
            )
        }
        
        guard let user else {
            throw DomainError.userNotFoundError
        }
        user.updateAt = Date()
        try await user.save(on: database)
        
        let userProfile : UserProfile = DomainMapper.toDomain(user: user)
        
        let authCodePayload: AuthCodeTokenPayload = AuthCodeTokenPayload(userID: userProfile.id, deviceID: deviceID)
        
        let code = try tokenService.issueToken(payload: authCodePayload)
        
        let authCode = DomainMapper.toDomain(payload: authCodePayload)
        
        try await tokenService.saveToken(kvEntity: KvEntityMapper.toKvEntity(domain: authCode))
        
        return LoginUsecaseOutput(code: code)
        
    }
    
    
}

extension Application {
    
    var userLoginUsecase: any LoginUsecase {
        LoginUsecaseImpl(
            userCrudRepository: self.userCrudRepository,
            userRepository: self.userQueryRepository,
            tokenService: self.tokenService
        )
    }
    
    
}
