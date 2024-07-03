//
//  PhotoCompleteView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI
import Combine

struct Alert {
    let title: String
    let message: String?
    let actions: [AlertButton]
    let textFieldPlaceholder: String?
    var textFieldText: Binding<String>?
    
    init(title: String, message: String?, actions: [AlertButton], textFieldPlaceholder: String? = nil, textFieldText: Binding<String>? = nil) {
        self.title = title
        self.message = message
        self.actions = actions
        self.textFieldPlaceholder = textFieldPlaceholder
        self.textFieldText = textFieldText
    }
    
    struct AlertButton: Identifiable {
        var id: String { title }
        
        let title: String
        let style: ButtonRole?
        let action: (() -> Void)?
        
        init(title: String, style: ButtonRole? = nil, action: (() -> Void)? = nil) {
            self.title = title
            self.style = style
            self.action = action
        }
    }

}

enum AlertType {
    
    typealias AlertAction = (()->Void)
    
    case report(action: AlertAction, placeholder: String, text: Binding<String>)
    case reportComplete
    case logout(action: AlertAction)
    case resign(action: AlertAction)
    
    var data: Alert {
        switch self {
        case .report(let action, let placeholder, let text):
            return .init(title: "어떤 오류사항이 있었나요?",
                         message: "구체적으로 작성해주실수록 오류 확인이\n빠르게 진행됩니다!",
                         actions: [.init(title: "취소", style: .cancel),.init(title: "제출하기", action: action)],
                         textFieldPlaceholder: placeholder,
                         textFieldText: text)
        case .reportComplete:
            return .init(title: "의견 감사합니다!",
                         message: "작성해주신 내용 잘 확인하여 더 좋은\n서비스를 제공하는 젠티가 되겠습니다",
                         actions: [.init(title: "확인했습니다")])
        case .logout(let action):
            return .init(title: "정말 로그아웃 하시겠어요?",
                         message: "사진 생성중에 로그아웃 하시면\n오류가 발생할 수 있습니다. 주의해주세요!",
                         actions: [.init(title: "취소하기", style: .cancel), .init(title: "로그아웃", action: action)])
        case .resign(let action):
            return .init(title: "정말 탈퇴 하시겠어요?",
                         message: "생성한 사진 내역이 모두 사라집니다.\n주의해주세요!",
                         actions: [.init(title: "취소하기", style: .cancel), .init(title: "탈퇴하기", action: action)])
        }
    }
}




@Observable
final class PhotoCompleteViewViewModel: ViewModel {

    var router: Router<MainRoute>
    var state: State

    init(router: Router<MainRoute>) {
        self.router = router
        self.state = .init()
    }

    struct State {
        var rating: Int = 0
        var reportContent: String = ""
        var isLoading: Bool = false
        var showRatingView: Bool = false {
            didSet {
                self.rating = 0
            }
        }
        var showAlert: AlertType? = nil {
            didSet {
                self.reportContent = ""
            }
        }
    }

    enum Input {
        case goToMainButtonTap
        case reportButtonTap
        case imageTap
        case ratingViewSkipButtonTap
        case ratingViewSubmitButtonTap
        case ratingViewStarTap(rating: Int)
    }

    func sendAction(_ input: Input) {
        switch input {
        case .goToMainButtonTap:
            showRatingView()
        case .reportButtonTap:
            presentReportAlert()
        case .imageTap:
            navigateToPhotoExpandView()
        case .ratingViewSkipButtonTap:
            dismissRatingView()
        case .ratingViewSubmitButtonTap:
            submitRating()
        case .ratingViewStarTap(let rating):
            updateRating(rating)
        }
    }

    private func showRatingView() {
        state.showRatingView = true
    }

    private func presentReportAlert() {
        state.showAlert = .report(
            action: { [weak self] in
                self?.submitReport()
            },
            placeholder: "",
            text: .init(
                get: { [weak self] in self?.state.reportContent ?? "" },
                set: { [weak self] newText in self?.state.reportContent = newText }
            )
        )
    }

    private func submitReport() {
        Task {
            state.isLoading = true
            try await Task.sleep(nanoseconds: 1_000_000_000)
            state.isLoading = false
            state.showAlert = .reportComplete
        }
    }

    private func navigateToPhotoExpandView() {
        router.routeTo(.photoExpandView)
    }

    private func dismissRatingView() {
        router.dismissSheet()
    }

    private func submitRating() {
        Task {
            state.isLoading = true
            try await Task.sleep(nanoseconds: 1_000_000_000)
            state.isLoading = false
            router.dismissSheet()
        }
    }

    private func updateRating(_ rating: Int) {
        state.rating = rating
    }
}

struct PhotoCompleteView: View {

    @Bindable var viewModel: PhotoCompleteViewViewModel
    
    init(viewModel: PhotoCompleteViewViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - initalize
    var imageName: String = "SampleImage23"
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                // Background Color
                Color.backgroundWhite
                    .ignoresSafeArea()
                
                // Content
                VStack(spacing: 0) {
                    // HorizontalImageContentView()
//                    HorizontalImageContentView(viewModel: viewModel)
                    VerticalImageContentView(viewModel: viewModel)
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
                            self.viewModel.sendAction(.goToMainButtonTap)
                        }
                    
                    Spacer()
                    
                    
                    Text("혹시 만들려고 했던 사진과 전혀 다른 사진이 나왔나요?")
                        .pretendard(.small)
                        .foregroundStyle(.error)
                        .underline()
                        .onTapGesture {
                            self.viewModel.sendAction(.reportButtonTap)
                        }
                    Spacer()
                }
                
                if viewModel.state.showRatingView {
                    RatingAlertView(viewModel: viewModel)
                }

                if viewModel.state.isLoading {
                    LoadingView()
                }
                
            } //:ZSTACK
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
        .customAlert(alertType: $viewModel.state.showAlert)
    }
}
