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
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyPictures:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fetchMyPictures:
            return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwiYXV0aCI6IlJPTEVfVVNFUiIsImlhdCI6MTcxNzI4MzA4OCwiZXhwIjoxNzc3MjgzMDg4fQ.rP2zPOLydDxUXvKqqNsfXSCxO6q8_O2NxhnE6pcP1WQwQqhouoR4UnVgJAiSxs47VCI7thlzbNvGo9mm-qFNig"]
        }
    }
    
    var baseURL: String {
        return "https://genti.kr"
    }
    
    var path: String {
        switch self {
        case .fetchMyPictures:
            return "/api/users/pictures/my"
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
            parameters["size"] = 10
            parameters["sortBy"] = "createdAt"
            parameters["direction"] = "desc"
            
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        }
        
        return urlRequest
    }
    
}
