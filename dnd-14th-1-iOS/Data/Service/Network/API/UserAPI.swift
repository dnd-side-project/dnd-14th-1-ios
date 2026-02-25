//
//  UserAPI.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation
import Alamofire

enum UserAPI: Router {
    case fetchLogin(LoginRequest)
    case fetchUserProfile
}

extension UserAPI {
    
    var baseURL: String {
        return AppConfig.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchLogin: "/open-api/v1/auth/apple"
        case .fetchUserProfile: "/api/v1/users/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchLogin: .post
        case .fetchUserProfile: .get
        }
    }
    
    var headers: [String : String] { // MARK: - Access token은 이곳에서 넣지 않습니다!
        switch self {
        case .fetchLogin:
            return [:]
        case .fetchUserProfile:
            var baseDictionary: [String: String] = [:]
            if let accessToken = KeychainWorker.shared.read(key: .access) {
                baseDictionary["Authorization"] = "Bearer \(accessToken)"
            }
            return baseDictionary
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchLogin(let request):
            return request.toDictionary()
        case .fetchUserProfile:
            return nil
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .fetchLogin:
            return JSONEncoding.default
        case .fetchUserProfile:
            return nil
        }
    }
}
