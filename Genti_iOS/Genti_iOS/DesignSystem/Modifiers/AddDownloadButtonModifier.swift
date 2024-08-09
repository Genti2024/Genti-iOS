//
//  AddDownloadButtonModifier.swift
//  Genti_iOS
//
//  Created by uiskim on 7/8/24.
//

import SwiftUI

struct AddDownloadButtonModifier: ViewModifier {
    var downLoadTapAction: (()->Void)?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                Image("Download")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .padding(.bottom, 6)
                    .padding(.trailing, 18)
                    .onTapGesture {
                        print(#fileID, #function, #line, "- downloadtap")
                        downLoadTapAction?()
                    }
            }
    }
}

extension View {
    func addDownloadButton(downLoadTapAction: (()->Void)? = nil) -> some View {
        return modifier(AddDownloadButtonModifier(downLoadTapAction: downLoadTapAction))
    }
}
