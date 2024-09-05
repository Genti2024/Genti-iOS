//
//  API.swift
//  Genti
//
//  Created by uiskim on 6/3/24.
//

import Foundation

import Alamofire

final class API {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, interceptor: APIEventInterceptor(), eventMonitors: [apiLogger])
    }()
    
    static let nonRetrySession: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, interceptor: nil, eventMonitors: [apiLogger])
    }()
}
