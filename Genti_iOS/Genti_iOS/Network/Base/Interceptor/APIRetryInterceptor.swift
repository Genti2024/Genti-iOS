//
//  APIRetryInterceptor.swift
//  Genti_iOS
//
//  Created by uiskim on 8/4/24.
//

import Foundation

import Alamofire

final class APIRetryInterceptor: RequestInterceptor {
    let userdefaultRepository: UserDefaultsRepository = UserDefaultsRepositoryImpl()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix("http://ec2-15-165-111-211.ap-northeast-2.compute.amazonaws.com") == true,
              let accessToken = userdefaultRepository.get(forKey: .accessToken) as? String else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
}
