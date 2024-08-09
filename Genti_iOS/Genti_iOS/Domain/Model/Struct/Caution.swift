//
//  Caution.swift
//  Genti
//
//  Created by uiskim on 4/30/24.
//

import Foundation

struct Caution {
    
    struct BeforeAfter: Hashable {
        var before: String
        var after: String
    }
    
    static var texts: [String] {
        return [
            "모자, 악세사리 등으로 얼굴이 잘 안보이는 사진을 사용하면 얼굴이 잘 안나올 수 있어요",
            "사진은 정면사진을 포함하여 오른쪽, 왼쪽 등 다양한 각도일수록 얼굴 생성에 도움이 되요",
            "만들고자 하는 사진의 포즈와 비슷한 각도의 얼굴 사진을 사용하면 얼굴이 더욱 정확하게 반영되요",
            "본인의 사진만 업로드해주세요. 타인의 사진을 이용할 경우 서비스 이용이 차단되며 법적인 제재 받을 수도 있어요!"
        ]
    }
    
    static var exampleImages: [String] {
        return [
            "FaceExample1",
            "FaceExample2",
            "FaceExample3"
        ]
    }
    
    static var beforeAfterImages: [BeforeAfter] {
        return [
            .init(before: "BeforeImage1", after: "AfterImage1"),
            .init(before: "BeforeImage2", after: "AfterImage2")
        ]
    }
}
