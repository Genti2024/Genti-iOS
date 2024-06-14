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
    case requestImage(prompt: String, poseURL: String?, faceURLs: [String], angle: PhotoAngle, coverage: PhotoFrame, ratio: PhotoRatio)
    
    var method: HTTPMethod {
        switch self {
        case .getPresignedUrl, .getPresignedUrls, .requestImage:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getPresignedUrl, .getPresignedUrls, .requestImage:
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
        case .requestImage:
            return "/api/users/picture-generate-requests"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        switch self {
        case .getPresignedUrl(let fileName):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: ["fileName": fileName, "fileType": "USER_UPLOADED_IMAGE"])
            
        case .getPresignedUrls(let fileNames):
            var body: [[String: Any]] = []
            for fileName in fileNames {
                body.append(["fileName": fileName, "fileType": "USER_UPLOADED_IMAGE"])
            }
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            
        case .requestImage(prompt: let prompt, poseURL: let poseURL, faceURLs: let faceURLs, angle: let angle, coverage: let coverage, ratio: let ratio):
            var parameters: [String: Any] = ["prompt": prompt,
                              "facePictureKeyList": faceURLs,
                              "cameraAngle": angle.requsetString,
                              "shotCoverage": coverage.requsetString,
                              "pictureRatio": ratio.requsetString
                             ]
            if let poseURL = poseURL {
                parameters["posePictureKey"] = poseURL
            }
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
    
}
