//
//  UserRouter.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

import Alamofire

enum UserState {
    case inProgress
    case canMake
    case awaitUserVerification(CompletedPhotoEntity)
    case canceled(requestId: Int)
    case error
}

enum UserRouter: URLRequestConvertible {
    
    case fetchMyPictures
    case reportPicture(responseId: Int, content: String)
    case ratePicture(responseId: Int, rate: Int)
    case getUserState
    case checkCompletedImage(responeId: Int)
    case checkCanceledImage(requestId: Int)
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyPictures, .getUserState, .checkCanceledImage:
            return .get
        case .reportPicture, .ratePicture, .checkCompletedImage:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fetchMyPictures, .reportPicture, .ratePicture, .getUserState, .checkCompletedImage, .checkCanceledImage:
            return []
        }
    }

    
    var baseURL: String {
        return "https://dev.genti.kr"
    }
    
    var path: String {
        switch self {
        case .fetchMyPictures:
            return "/api/v1/users/pictures"
        case .reportPicture:
            return "/api/v1/users/reports"
        case .ratePicture(let responseId, _):
            return "/api/v1/users/picture-generate-responses/\(responseId)/rate"
        case .getUserState:
            return "/api/v1/users/picture-generate-requests/pending"
        case .checkCompletedImage(let responseId):
            return "/api/v1/users/picture-generate-responses/\(responseId)/verify"
        case .checkCanceledImage(let requestId):
            return "/api/v1/users/picture-generate-requests/\(requestId)/confirm-cancel-status"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        switch self {
        case .reportPicture(let responseId, content: let content):
            var parameters: [String: Any] = [:]
            parameters["pictureGenerateResponseId"] = responseId
            parameters["content"] = content
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            
        case .ratePicture(_, let rate):
            var parameters: [String: Any] = [:]
            parameters["star"] = rate
            urlRequest = try URLEncoding(destination: .queryString).encode(urlRequest, with: parameters)
        case .getUserState, .checkCompletedImage, .checkCanceledImage, .fetchMyPictures:
            return urlRequest
        }
        return urlRequest
    }
    
}
