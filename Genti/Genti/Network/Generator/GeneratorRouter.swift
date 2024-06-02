//
//  GeneratorRouter.swift
//  Genti
//
//  Created by uiskim on 6/2/24.
//

import Foundation

import Alamofire

enum GeneratorRouter: URLRequestConvertible {
    
    case getPresignedUrl(fileName: String)
    case getPresignedUrls(fileNames: [String])
    
    var method: HTTPMethod {
        switch self {
        case .getPresignedUrl, .getPresignedUrls:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getPresignedUrl, .getPresignedUrls:
            return ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwiYXV0aCI6IlJPTEVfVVNFUiIsImlhdCI6MTcxNzI4MzA4OCwiZXhwIjoxNzc3MjgzMDg4fQ.rP2zPOLydDxUXvKqqNsfXSCxO6q8_O2NxhnE6pcP1WQwQqhouoR4UnVgJAiSxs47VCI7thlzbNvGo9mm-qFNig"]
        }
    }
    
    var baseURL: String {
        return "https://genti.kr"
    }
    
    var path: String {
        switch self {
        case .getPresignedUrl:
            return "/api/presigned-url"
        case .getPresignedUrls:
            return "/api/presigned-url/many"
        }
    }
    
//    var parameters: [String: Any]? {
//        switch self {
//        case .getPresignedUrl(let fileName):
//            return ["fileName": fileName, "fileType": "CREATED_IMAGE"]
//        case .getPresignedUrls(let fileNames):
//
//        }
//    }
    
//    var encoding: ParameterEncoding {
//        switch self {
//        case .getPresignedUrl:
//            return JSONEncoding.default
//        }
//    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        
        
        switch self {
        case .getPresignedUrl(let fileName):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: ["fileName": fileName, "fileType": "CREATED_IMAGE"])
        case .getPresignedUrls(let fileNames):
            var body: [[String: Any]] = []
            for fileName in fileNames {
                body.append(["fileName": fileName, "fileType": "CREATED_IMAGE"])
            }
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        return urlRequest
    }
    
}
