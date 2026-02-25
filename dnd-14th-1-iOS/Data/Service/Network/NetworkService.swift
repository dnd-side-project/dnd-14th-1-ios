//
//  NetworkService.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/25/26.
//

import Foundation
import Combine
import Alamofire

final class NetworkService {
    
    func request<T: Decodable>(api: Router) -> AnyPublisher<T, ErrorResponse> {
        AF.request(api)
            .publishData()
            .tryMap { response in
                guard let httpResponse = response.response else {
                    throw ErrorResponse(customStatusCode: 000, data: [], message: "unexpected network error", status: 000)
                }
                if 200..<300 ~= httpResponse.statusCode {
                    if let data = response.data {
                        if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                            return decodedResponse  
                        } else {
                            throw ErrorResponse(customStatusCode: 000, data: [], message: "failed to decode response", status: httpResponse.statusCode)
                        }
                    } else {
                        throw ErrorResponse(customStatusCode: 000, data: [], message: "null response", status: httpResponse.statusCode)
                    }
                } else {
                    if let data = response.data {
                        if let decodedErrorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            throw decodedErrorResponse
                        } else {
                            throw ErrorResponse(customStatusCode: 000, data: [], message: "failed to decode response", status: httpResponse.statusCode)
                        }
                    } else {
                        throw ErrorResponse(customStatusCode: 000, data: [], message: "failed to decode ErrorResponse", status: httpResponse.statusCode)
                    }
                }
            }
            .mapError { error -> ErrorResponse in
                if let errorResponse = error as? ErrorResponse {
                    return errorResponse
                } else {
                    return ErrorResponse(customStatusCode: 000, data: [], message: "unexpected internal error", status: 000)
                }
            }
            .eraseToAnyPublisher()
    }
}
