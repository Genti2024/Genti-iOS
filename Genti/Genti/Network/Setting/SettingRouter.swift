//
//  SettingRouter.swift
//  Genti
//
//  Created by uiskim on 6/5/24.
//

//import Foundation
//
//import Alamofire
//
//enum SettingRouter: URLRequestConvertible {
//    
//    
//    var method: HTTPMethod {
//
//    }
//    
//    var headers: HTTPHeaders {
//
//    }
//    
//    var baseURL: String {
//        return "https://genti.kr"
//    }
//    
//    var path: String {
//
//    }
//    
//    func asURLRequest() throws -> URLRequest {
//        let url = try baseURL.asURL().appendingPathComponent(path)
//        var urlRequest = URLRequest(url: url)
//        urlRequest.method = method
//        urlRequest.headers = headers
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        
//        switch self {
//        case .getPresignedUrl(let fileName):
//            urlRequest = try JSONEncoding.default.encode(urlRequest, with: ["fileName": fileName, "fileType": "USER_UPLOADED_IMAGE"])
//            
//        case .getPresignedUrls(let fileNames):
//            var body: [[String: Any]] = []
//            for fileName in fileNames {
//                body.append(["fileName": fileName, "fileType": "CREATED_IMAGE"])
//            }
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
//            
//        case .requestImage(prompt: let prompt, poseURL: let poseURL, faceURLs: let faceURLs, angle: let angle, coverage: let coverage):
//            urlRequest = try JSONEncoding.default.encode(urlRequest, with: ["prompt": prompt,
//                                                                            "posePictureKey": poseURL,
//                                                                            "facePictureKeyList": faceURLs,
//                                                                            "cameraAngle": "위에서 촬영",
//                                                                            "shotCoverage": "얼굴만 클로즈업"
//                                                                           ])
//        }
//        
//        return urlRequest
//    }
//    
//}
