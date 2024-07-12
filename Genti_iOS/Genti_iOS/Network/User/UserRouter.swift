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
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyPictures:
            return .get
        case .reportPicture:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fetchMyPictures, .reportPicture:
            return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE3MjA2ODE1NTEsImV4cCI6MTIxNzIwNjgxNTUxLCJ1c2VySWQiOiIyIiwicm9sZSI6IlJPTEVfVVNFUiIsInR5cGUiOiJhY2Nlc3MifQ.B2v5nNx_wIpWOeKMWR_OBQbg-5v9i0YnCQxrv3O9ydAG7ldJugvH56VnFuisZt9lpaUfNsKRpOOIMpw4oIzPgw"]
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
            return "/api/v1/users/reports/"
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
            
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .reportPicture(id: let id, content: let content):
            var parameters: [String: Any] = [:]
            parameters["pictureGenerateResponseId"] = id
            parameters["content"] = content
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        
        return urlRequest
    }
    
}
