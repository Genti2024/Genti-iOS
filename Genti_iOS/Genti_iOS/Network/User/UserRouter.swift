//
//  UserRouter.swift
//  Genti_iOS
//
//  Created by uiskim on 7/1/24.
//

import Foundation

import Alamofire

enum UserRouter: URLRequestConvertible {
    
    case fetchMyPictures(page: Int)
    case reportPicture(id: Int, content: String)
    case ratePicture(id: Int, rate: Int)
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyPictures:
            return .get
        case .reportPicture:
            return .post
        case .ratePicture:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fetchMyPictures, .reportPicture, .ratePicture:
            return []
        }
    }

    
    var baseURL: String {
        return "https://genti.kr"
    }
    
    var path: String {
        switch self {
        case .fetchMyPictures:
            return "/api/v1/users/pictures/my"
        case .reportPicture:
            return "/api/v1/users/reports"
        case .ratePicture(let id, _):
            return "/api/v1/users/picture-generate-responses/\(id)/rate"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        switch self {
        case .fetchMyPictures(let page):
            var parameters: [String: Any] = [:]
            parameters["page"] = page
            parameters["size"] = 4
            parameters["sortBy"] = "createdAt"
            parameters["direction"] = "desc"
            urlRequest = try URLEncoding(destination: .queryString).encode(urlRequest, with: parameters)
        case .reportPicture(id: let id, content: let content):
            var parameters: [String: Any] = [:]
            parameters["pictureGenerateResponseId"] = id
            parameters["content"] = content
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            
        case .ratePicture(_, let rate):
             var parameters: [String: Any] = [:]
             parameters["star"] = rate
             urlRequest = try URLEncoding(destination: .queryString).encode(urlRequest, with: parameters)
         }
        
        return urlRequest
    }
    
}
