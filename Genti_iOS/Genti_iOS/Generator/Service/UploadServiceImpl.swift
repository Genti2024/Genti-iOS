//
//  UploadServiceImpl.swift
//  Genti_iOS
//
//  Created by uiskim on 6/22/24.
//

import Foundation

import Alamofire

final class UploadServiceImpl: UploadService {
    func upload(s3Key: String?, imageData: Data, presignedURLString: String?) async throws -> String? {
        guard let urlString = presignedURLString, let presignedURL = URL(string: urlString) else { throw GentiError.clientError(code: "Unwrapping", message: "URL변환 실패")}
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(imageData, to: presignedURL, method: .put)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success:
                        continuation.resume(returning: s3Key)
                    case .failure(let error):
                        continuation.resume(throwing: GentiError.uploadFail(code: "AWS", message: "AWS에 업로드 실패"))
                    }
                }
        }
    }
}
