//
//  APIEventInterceptor.swift
//  Genti_iOS
//
//  Created by uiskim on 7/30/24.
//

import Foundation

import Alamofire

final class APIEventInterceptor: RequestInterceptor {
    let userdefaultRepository: UserDefaultsRepository = UserDefaultsRepositoryImpl()
    let authRepository: AuthRepository = AuthRepositoryImpl(requestService: RequestServiceImpl())
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix("https://genti.kr") == true,
              let accessToken = userdefaultRepository.get(forKey: .accessToken) as? String else {
                  completion(.success(urlRequest))
                  return
              }

        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
        print("토큰이 자동으로 갱신되었습니다")
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
        Task {
            do {
                let tokens = userdefaultRepository.getToken()
                let result = try await authRepository.reissueToken(token: tokens)
                userdefaultRepository.setToken(token: result)
                completion(.retry)
                
            } catch(let error) {
                completion(.doNotRetryWithError(error))
            }
        }
    }
}

