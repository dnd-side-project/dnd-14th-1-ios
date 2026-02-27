//
//  UpdateImageToKakaoServerUseCase.swift
//  dnd-14th-1-iOS
//
//  Created by 홍기정 on 2/28/26.
//

import UIKit
import Combine
import KakaoSDKShare


enum KakaoTemplate: Int64 {
    case tier = 130045
    case badge = 130046
}

protocol KakaoShareUseCase {
    func execute(image: UIImage, template: KakaoTemplate) -> AnyPublisher<Bool, ErrorResponse>
}

final class DefaultKakaoShareUseCase: KakaoShareUseCase {
    
    func execute(image: UIImage, template: KakaoTemplate) -> AnyPublisher<Bool, ErrorResponse> {

        return uploadImageToKakaoServer(image: image)
            .flatMap { [weak self] imageUrl -> AnyPublisher<Void, ErrorResponse> in
                guard let self else {
                    return Fail(error: ErrorResponse(customStatusCode: 0, data: nil, message: "weak self is nil", status: 0))
                        .eraseToAnyPublisher()
                }
                return self.launchKakaoAndShare(imageUrl: imageUrl, template: template)
            }
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
}

extension DefaultKakaoShareUseCase {
    
    private func uploadImageToKakaoServer(image: UIImage) -> AnyPublisher<String, ErrorResponse> {
        return Future { promise in
            //해당 이미지를 카카오 공유 서버에 업로드
            ShareApi.shared.imageUpload(image: image) { (imageUploadResult, error ) in
                if let error = error { //업로드 실패
                    print(error)
                    let errorResponse = ErrorResponse(customStatusCode: 0, data: nil, message: "카카오서버에 이미지 업로드 실패", status: 0)
                    promise(.failure(errorResponse))
                } else if let url = imageUploadResult?.infos.original.url { //업로드 성공
                    print("imageUpload() success.")
                    promise(.success(url.absoluteString))
                } else {
                    let errorResponse = ErrorResponse(customStatusCode: 0, data: nil, message: "카카오서버에서 URL 생성 실패", status: 0)
                    promise(.failure(errorResponse))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func launchKakaoAndShare(imageUrl: String, template: KakaoTemplate) -> AnyPublisher<Void, ErrorResponse> {
        return Future { promise in
            KakaoSDKShare.ShareApi.shared.shareCustom(
                templateId: template.rawValue,
                templateArgs: ["THU" : imageUrl],
                completion: { (result, error) in
                    if let result {
                        DispatchQueue.main.async {
                            UIApplication.shared.open(result.url) { success in
                                if success {
                                    promise(.success(()))
                                } else {
                                    let errorResponse = ErrorResponse(customStatusCode: 0, data: nil, message: "카카오톡 실행 실패", status: 0)
                                    promise(.failure(errorResponse))
                                }
                            }
                        }
                    } else {
                        let errorResponse = ErrorResponse(customStatusCode: 0, data: nil, message: "카카오톡 공유 실패", status: 0)
                        promise(.failure(errorResponse))
                    }
                }
            )
        }
        .eraseToAnyPublisher()
    }
}
