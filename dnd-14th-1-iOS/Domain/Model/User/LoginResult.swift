//
//  LoginResult.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation

struct LoginResult {
    let status: Int
    let data: LoginData
    let message: String
}

struct LoginData {
    let accessToken: String
    let refreshToken: String
    let userID: String

    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken
        case userID = "userId"
    }
}
