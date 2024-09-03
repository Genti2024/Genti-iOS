//
//  APIService.swift
//  Genti
//
//  Created by uiskim on 6/2/24.
//

import Alamofire
import Foundation
import Photos

protocol RequestService {
    
    /// API요청 메서드(반환값이 필요할때)
    /// - Parameter endpoint: endpoint
    /// - Returns: APIResponse의 내부 response를 반환
    func fetchResponse<T: Decodable>(for endpoint: URLRequestConvertible) async throws -> T
    
    /// API요청 메서드(반환값이 필요없을때)
    /// - Parameter endpoint: endpoint
    func fetchResponse(for endpoint: URLRequestConvertible) async throws
    
    func fetchResponseNonRetry<T: Decodable>(for endpoint: URLRequestConvertible) async throws -> T
}

final class RequestServiceImpl: RequestService {
    func fetchResponseNonRetry<T: Decodable>(for endpoint: URLRequestConvertible) async throws -> T  {
        return try await withCheckedThrowingContinuation { continuation in
            API.retrySession.request(endpoint)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: APIResponse<T>.self) { res in
                    switch res.result {
                    case .success(let apiResponse):
                        if apiResponse.success {
                            guard let response = apiResponse.response else {
                                continuation.resume(throwing: GentiError.serverError(code: "SERVER", message: "Success인데 response가 null입니다"))
                                return
                            }
                            continuation.resume(returning: response)
                        } else {
                            continuation.resume(throwing: GentiError.serverError(code: "SERVER", message: "API가 200번대인데 내부 response의 success가 false입니다"))
                        }
                    case .failure(let error):
                        if let data = res.data, let serverError = try? JSONDecoder().decode(APIResponse<Bool>.self, from: data), !serverError.success {
                            continuation.resume(throwing: GentiError.serverError(code: serverError.errorCode, message: serverError.errorMessage))
                        } else {
                            continuation.resume(throwing: GentiError.clientError(code: "REQUESTERROR", message: "\(res.response?.statusCode ?? 0)\n\(error.localizedDescription)"))
                        }
                    }
                }
        }
    }
    
    func fetchResponse<T: Decodable>(for endpoint: URLRequestConvertible) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            API.session.request(endpoint)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: APIResponse<T>.self) { res in
                    switch res.result {
                    case .success(let apiResponse):
                        if apiResponse.success {
                            guard let response = apiResponse.response else {
                                continuation.resume(throwing: GentiError.serverError(code: "SERVER", message: "Success인데 response가 null입니다"))
                                return
                            }
                            continuation.resume(returning: response)
                        } else {
                            continuation.resume(throwing: GentiError.serverError(code: "SERVER", message: "API가 200번대인데 내부 response의 success가 false입니다"))
                        }
                    case .failure(let error):
                        if let data = res.data, let serverError = try? JSONDecoder().decode(APIResponse<Bool>.self, from: data), !serverError.success {
                            continuation.resume(throwing: GentiError.serverError(code: serverError.errorCode, message: serverError.errorMessage))
                        } else {
                            continuation.resume(throwing: GentiError.clientError(code: "REQUESTERROR", message: "\(res.response?.statusCode ?? 0)\n\(error.localizedDescription)"))
                        }
                    }
                }
        }
    }
    
    
    func fetchResponse(for endpoint: URLRequestConvertible) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            API.session.request(endpoint)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: APIResponse<Bool>.self) { res in
                    switch res.result {
                    case .success(let apiResponse):
                        if !apiResponse.success {
                            continuation.resume(throwing: GentiError.serverError(code: "SERVER", message: "API가 200번대인데 내부 response의 success가 false입니다"))
                        }
                        continuation.resume(returning: ())
                    case .failure(let error):
                        if let data = res.data, let serverError = try? JSONDecoder().decode(APIResponse<Bool>.self, from: data), !serverError.success {
                            continuation.resume(throwing: GentiError.serverError(code: serverError.errorCode, message: serverError.errorMessage))
                        } else {
                            continuation.resume(throwing: GentiError.clientError(code: "REQUESTERROR", message: "\(res.response?.statusCode ?? 0)\n\(error.localizedDescription)"))
                        }
                    }
                }
        }
    }
}
