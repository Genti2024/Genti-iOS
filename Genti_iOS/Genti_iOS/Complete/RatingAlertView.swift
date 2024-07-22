//
//  RatingAlertView.swift
//  Genti
//
//  Created by uiskim on 6/5/24.
//

import SwiftUI

@Observable
final class RatingAlertViewModel: ViewModel {
    
    var userRepository: UserRepository
    
    struct State {
        var rating: Int = 0
        var isLoading: Bool = false
    }
    
    enum Input {
        case ratingViewSkipButtonTap
        case ratingViewSubmitButtonTap
        case ratingViewStarTap(rating: Int)
    }
    
    var state: State
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.state = .init()
    }
    
    func sendAction(_ input: Input) {
        switch input {
        case .ratingViewSkipButtonTap:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ratingCompleted"), object: nil)
        case .ratingViewSubmitButtonTap:
            Task {
                do {
                    await MainActor.run {
                        self.state.isLoading = true
                    }
                    try await Task.sleep(nanoseconds: 1000000000)
                    try await userRepository.ratePhoto(rate: state.rating)
                    
                    await MainActor.run {
                        self.state.isLoading = false
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "ratingCompleted"), object: nil)
                    }
                }
            }
        case .ratingViewStarTap(let rating):
            self.state.rating = rating
        }
    }
}

struct RatingAlertView: View {
    @State var viewModel: RatingAlertViewModel
    
    var body: some View {
        Image("Rating_backgroundImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 270, height: 250)
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    ratingContentView()
                    acceptButton()
                    cancelButton()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .overlay(alignment: .center) {
                if viewModel.state.isLoading {
                    LoadingView()
                }
            }
    }
    
    private func ratingContentView() -> some View {
        VStack(spacing: 12) {
            titleView()
            ratingStarView()
        } //:VSTACK
    }
    private func cancelButton() -> some View {
        Text("건너뛰기")
            .pretendard(.description)
            .foregroundStyle(.gray2)
            .underline()
            .padding(.bottom, 13)
            .frame(maxWidth: .infinity)
            .background(.black.opacity(0.001))
            .onTapGesture {
                print(#fileID, #function, #line, "- 1")
                self.viewModel.sendAction(.ratingViewSkipButtonTap)
            }
            .padding(.top, 12)
    }
    private func acceptButton() -> some View {
        Text("제출하기")
            .pretendard(.headline4)
            .foregroundStyle(viewModel.state.rating == 0 ? .gray2 : .white)
            .frame(width: 221, height: 34)
            .background(viewModel.state.rating == 0 ? .clear : .gentiGreen)
            .clipShape(.rect(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.gray2, lineWidth: viewModel.state.rating == 0 ? 1 : 0)
            )
            
            .background(.black.opacity(0.001))
            .asButton(.press, action: {
                print(#fileID, #function, #line, "- 2")
                self.viewModel.sendAction(.ratingViewSubmitButtonTap)
            })
            .disabled(viewModel.state.rating == 0)
            .padding(.top, 19)
    }
    private func ratingStarView() -> some View {
        HStack(spacing: 0) {
            ForEach(1..<6) { index in
                Image(index > viewModel.state.rating ? "Star_empty" : "Star_fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        print(#fileID, #function, #line, "- 3")
                        viewModel.sendAction(.ratingViewStarTap(rating: index))
                    }
            }
        }
        .frame(height: 25)
    }
    private func titleView() -> some View {
        VStack(spacing: 21) {
            Text("사진은 어떠셨나요?")
                .pretendard(.headline4)
                .foregroundStyle(.black)
                .frame(height: 22)
            
            Text("별점을 남겨주시면 앞으로 더 마음에 드는\n사진을 만들어 드릴 수 있어요!")
                .pretendard(.description)
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .frame(height: 32)
        } //:VSTACK
        .padding(.top, 43)
    }
}

//#Preview {
//    RatingAlertView()
//}
