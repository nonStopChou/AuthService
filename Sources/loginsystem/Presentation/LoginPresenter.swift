//
//  LoginPresenter.swift
//  hello
//
//  Created by prchou on 2025/7/26.
//
import Vapor

struct LoginPresenter: Sendable {
    
    func present(_ responseDto: LoginOutput) -> LoginViewModel {
        let userProfile: UserProfile = responseDto.userProfile
        let daySinceLastLogin: Double = Date().timeIntervalSince(userProfile.lastLoginDate) / 86400
        let avatarURL: String = userProfile.avatarURL ?? ""
        return LoginViewModel(
            username: userProfile.username,
            email: userProfile.email,
            avartarURL: avatarURL,
            accessToken: responseDto.accessToken,
            refreshToken: responseDto.refreshToken
        )
    }
}


extension Application {
    
    var loginPresenter: LoginPresenter {
        LoginPresenter()
    }
}
