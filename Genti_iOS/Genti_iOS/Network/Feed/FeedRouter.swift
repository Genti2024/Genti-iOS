//
//  FeedRouter.swift
//  Genti_iOS
//
//  Created by uiskim on 6/30/24.
//

import Foundation

import Alamofire

enum FeedRouter: URLRequestConvertible {
    
    case requestFeed
    
    var method: HTTPMethod {
        switch self {
        case .requestFeed:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .requestFeed:
            return []
        }
    }
    
    var baseURL: String {
        return "http://ec2-15-165-111-211.ap-northeast-2.compute.amazonaws.com"
    }
    
    var path: String {
        switch self {
        case .requestFeed:
            return "/api/v1/users/examples/with-picture"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
}
