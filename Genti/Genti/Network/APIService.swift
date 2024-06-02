//
//  APIService.swift
//  Genti
//
//  Created by uiskim on 6/2/24.
//

import Alamofire
import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchResponse<T: Decodable>(for endpoint: URLRequestConvertible) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint)
                .responseDecodable(of: APIResponse<T>.self) { response in
                    switch response.result {
                    case .success(let apiResponse):
                        if apiResponse.success {
                            if let response = apiResponse.response {
                                continuation.resume(returning: response)
                                return
                            }
                            continuation.resume(throwing: GentiError.emptyResponse(code: "SERVER", message: "response가 비어있습니다"))
                        } else {
                            continuation.resume(throwing: GentiError.serverError(code: apiResponse.errorCode, message: apiResponse.errorMessage))
                        }
                    case .failure:
                        continuation.resume(throwing: GentiError.clientError(code: "CLIENT", message: "StatusCode : \(String(describing: response.response?.statusCode))"))
                    }
                }
        }
    }
    
    
//    func uploadFileToS3(fileURL: URL, presignedURL: String) async throws -> Bool {
//        try await withCheckedThrowingContinuation { continuation in
//            AF.upload(multipartFormData: { multipartFormData in
//                multipartFormData.append(fileURL, withName: "file")
//            }, with: GeneratorRouter.uploadFile(url: presignedURL, fileURL: fileURL))
//            .response { response in
//                if let error = response.error {
//                    continuation.resume(throwing: error)
//                } else {
//                    continuation.resume(returning: true)
//                }
//            }
//        }
//    }
}
