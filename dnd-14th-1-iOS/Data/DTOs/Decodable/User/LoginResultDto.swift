//
//  LoginResultDto.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation

struct LoginResultDto: Decodable {
    let status: Int
    let data: LoginDataDto
    let message: String
    
    func toDomain() -> LoginResult {
        return LoginResult(
            status: status,
            data: data.toDomain(),
            message: message
        )
    }
}

struct LoginDataDto: Decodable {
    let accessToken: String
    let refreshToken: String
    let userID: String
    let isNewUser: Bool

    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken
        case userID = "userId"
        case isNewUser
    }
    
    func toDomain() -> LoginData {
        return LoginData(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userID: userID
        )
    }
}
