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
    
    var baseURL: String {
        return "https://genti.kr"
    }
    
    var path: String {
        switch self {
        case .getPresignedUrl:
            return "/api/v1/presigned-url"
        case .getPresignedUrls:
            return "/api/v1/presigned-url/many"
        case .requestImage:
            return "/api/v1/users/picture-generate-requests"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        switch self {
        case .getPresignedUrl(let fileName):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: ["fileName": fileName, "fileType": "USER_UPLOADED_IMAGE"])
            
        case .getPresignedUrls(let fileNames):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: fileNames.reduce(into: [Parameters](), {$0.append(["fileName": $1, "fileType": "USER_UPLOADED_IMAGE"])}))
            
        case .requestImage(prompt: let prompt, poseURL: let poseURL, faceURLs: let faceURLs, angle: let angle, coverage: let coverage, ratio: let ratio):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: [
                "prompt": prompt,
                "facePictureList": faceURLs.reduce(into: [Parameters](), {$0.append(["key":$1])}),
                "cameraAngle": angle.requsetString,
                "shotCoverage": coverage.requsetString,
                "pictureRatio": ratio.requsetString,
                "posePicture": ["key": poseURL]
            ])
        }
        
        return urlRequest
    }
    
}
