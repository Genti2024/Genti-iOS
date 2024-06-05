//
//  RatingAlertView.swift
//  Genti
//
//  Created by uiskim on 6/5/24.
//

import SwiftUI

struct RatingAlertView: View {
    @State private var rating: Int = 0
    @State private var isLoading: Bool = false
    @State private var showErrorText: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ratingContentView()

                Rectangle()
                    .frame(height: 1)
                
                acceptButton()
                cancelButton()
            }
            .background(.gray4)
            .clipShape(.rect(cornerRadius: 14))
            .padding(.horizontal, 50)
            
            if isLoading {
                LoadingView()
            }
        }
        .presentationBackground {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
        }
    }
    
    private func ratingContentView() -> some View {
        VStack(spacing: 12) {
            titleView()
            ratingStarView()
        } //:VSTACK
        .padding(.top, 19)
        .padding(.bottom, 15)
    }
    private func cancelButton() -> some View {
        Text("건너뛰기")
            .pretendard(.description)
            .foregroundStyle(.black)
            .underline()
            .padding(.bottom, 13)
            .frame(maxWidth: .infinity)
            .background(.black.opacity(0.001))
            .onTapGesture {
                self.dismiss()
            }
    }
    private func acceptButton() -> some View {
        Text("별점 남기기")
            .pretendard(.headline4)
            .foregroundStyle(.black)
            .padding(.top, 7)
            .padding(.bottom, 13)
            .frame(maxWidth: .infinity)
            .background(.black.opacity(0.001))
            .onTapGesture {
                
                if rating == 0 {
                    self.showErrorText = true
                } else {
                    Task {
                        self.showErrorText = false
                        self.isLoading = true
                        try await Task.sleep(nanoseconds: 2000000000)
                        self.isLoading = false
                        print("별점 : \(self.rating)점")
                        self.dismiss()
                    }
                }
            }
    }
    private func ratingStarView() -> some View {
        HStack(spacing: 0) {
            ForEach(1..<6) { index in
                Image(index > rating ? "Star_empty" : "Star_fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
    private func titleView() -> some View {
        VStack(spacing: 12) {
            Text("사진은 어떠셨나요?")
                .pretendard(.headline4)
                .foregroundStyle(.black)
            
            if showErrorText {
                if rating == 0 {
                    Text("별점은 1점부터 줄 수 있어요!")
                        .pretendard(.description)
                        .foregroundStyle(.red)
                }
            }
            
            Text("별점을 남겨주시면 앞으로 더 마음에 드는\n사진을 만들어 드릴 수 있어요!")
                .pretendard(.description)
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
        } //:VSTACK
    }
}

#Preview {
    RatingAlertView()
}
