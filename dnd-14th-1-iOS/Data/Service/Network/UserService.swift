//
//  UserService.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation
import Combine

protocol UserService {
    func fetchLogin(request: LoginRequest) -> AnyPublisher<LoginResultDto, ErrorResponse>
}

final class DefaultUserService: UserService {
    
    private let networkService = NetworkService()
    
    func fetchLogin(request: LoginRequest) -> AnyPublisher<LoginResultDto, ErrorResponse> {
        networkService.request(api: UserAPI.fetchLogin(request))
    }
}
