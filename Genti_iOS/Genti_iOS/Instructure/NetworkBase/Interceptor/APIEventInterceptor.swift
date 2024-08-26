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
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(Constants.baseURL) == true,
              let accessToken = userdefaultRepository.get(forKey: .accessToken) as? String else {
                  completion(.success(urlRequest))
                  return
              }

        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let tokens = userdefaultRepository.getToken()
        guard let accessToken = tokens.accessToken, let refreshToken = tokens.refreshToken else {
            completion(.doNotRetryWithError(GentiError.tokenError(code: "로컬db토큰오류", message: "토큰이 없습니다")))
            return
        }

        API.retrySession.request(AuthRouter.reissueToken(token: .init(accessToken: accessToken, refreshToken: refreshToken)))
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let result = try JSONDecoder().decode(APIResponse<ReissueTokenDTO>.self, from: data)
                        if !result.success {
                            completion(.doNotRetryWithError(GentiError.tokenError(code: result.errorCode, message: result.errorMessage)))
                            return
                        }
                        guard let accessToken = result.response?.accessToken, let refreshToken = result.response?.refreshToken else {
                            completion(.doNotRetryWithError(GentiError.tokenError(code: "TOKEN", message: "성공했는데토큰이 안담겨옴, 서버오류")))
                            return
                        }
                        self.userdefaultRepository.setAccessToken(token: accessToken)
                        self.userdefaultRepository.setRefreshToken(token: refreshToken)
                        print(#fileID, #function, #line, "- 새로 받은 토큰으로 교체")
                        completion(.retry)
                        return
                    } catch {
                        completion(.doNotRetryWithError(error))
                        return
                    }
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                    return
                }
            }
    }
}
