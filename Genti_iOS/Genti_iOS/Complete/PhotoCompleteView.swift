//
//  PhotoCompleteView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

struct PhotoCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPhotoDetail: Bool = false
    @State private var showReportAlert: Bool = false
    @State private var showCompleteAlert: Bool = false
    @State private var showRatingAlert: Bool = false
    
    @State private var reportContent: String = ""
    @State private var isLoading: Bool = false
    
    var imageName: String = "SampleImage23"
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                
                // Content
                VStack(spacing: 0) {
                    // MARK: - 만약에 가로로 긴사진이오면
//                    HorizontalImageContentView()
                    // MARK: - 만약에 세로로 긴사진이오면
                    VerticalImageContentView()
                    Spacer()
                    
                    Button {
                        // Action
                    } label: {
                        Text("공유하기")
                            .pretendard(.headline1)
                            .foregroundStyle(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(.gentiGreen)
                            .overlay(alignment: .leading) {
                                Image("Share")
                                    .resizable()
                                    .frame(width: 29, height: 29)
                                    .padding(.leading, 20)
                            }
                            .clipShape(.rect(cornerRadius: 10))
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                        .frame(height: 18)
                    
                    Text("메인으로 이동하기")
                        .pretendard(.small)
                        .foregroundStyle(.gray3)
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.001))
                        .onTapGesture {
                            self.showRatingAlert = true
                        }
                    
                    Spacer()
                        
                    
                    Text("혹시 만들려고 했던 사진과 전혀 다른 사진이 나왔나요?")
                        .pretendard(.small)
                        .foregroundStyle(.error)
                        .underline()
                        .onTapGesture {
                            self.showReportAlert = true
                        }
                    Spacer()
                }
                
                if isLoading {
                    LoadingView()
                }
                
            } //:ZSTACK
            
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
        .fullScreenCover(isPresented: $showPhotoDetail) {
            PhotoDetailView(imageName: self.imageName)
        }
        .alert("어떤 오류사항이 있었나요?", isPresented: $showReportAlert) {
            TextField("", text: $reportContent)
            Button("제출하기", role: .none) {
                Task {
                    self.isLoading = true
                    print("신고내역 : \(self.reportContent)")
                    try await Task.sleep(nanoseconds: 2000000000)
                    print("신고완료")
                    self.reportContent = ""
                    self.isLoading = false
                    self.showCompleteAlert = true
                }
            }
            Button("취소", role: .cancel, action: {})
        } message: {
            Text("구체적으로 작성해 주실수록 오류 확인이\n빠르게 진행됩니다!")
        }
        .alert("의견 감사합니다!", isPresented: $showCompleteAlert) {
            Button("확인했습니다", action: {})
        } message: {
            Text("작성해주신 내용 잘 확인하여 더 좋은\n서비스를 제공하는 젠티가 되겠습니다")
        }
        .fullScreenCover(isPresented: $showRatingAlert, onDismiss: self.onDismiss) {
            RatingAlertView()
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
    var onDismiss: (()->Void)? {
        return {
            Task {
                try await Task.sleep(nanoseconds:200000000)
                self.dismiss()
            }
            
        }
    }
}

#Preview {
    PhotoCompleteView(imageName: "SampleImage32")
}
