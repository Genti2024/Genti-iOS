//
//  FaceCertificationView.swift
//  Genti_iOS
//
//  Created by uiskim on 9/28/24.
//

import SwiftUI

@Observable
final class FaceCertificationViewModel: ViewModel {
    
    var router: Router<MainRoute>
    var verificationUseCase: VerificationUseCase
    var state: State
    
    struct State {
        var showAlert: AlertType? = nil
        var showCamera = false
        var image: UIImage? = nil
    }
    
    enum Input {
        case takePictureTap
        case completeCertificationButtonTap
        case xmarkTap
    }
    
    init(router: Router<MainRoute>, verificationUseCase: VerificationUseCase) {
        self.router = router
        self.verificationUseCase = verificationUseCase
        self.state = .init()
    }

    func sendAction(_ input: Input) {
        switch input {
        case .takePictureTap:
            self.state.showCamera = true
        case .completeCertificationButtonTap:
            Task { await handleCertification() }
        case .xmarkTap:
            self.state.showAlert = .verifyCanced(action: {self.router.dismissSheet()})
        }
    }
    
    @MainActor
    private func handleCertification() async {
        do {
            guard let image = self.state.image else { return }
            try await verificationUseCase.verification(from: image)
            EventLogManager.shared.addUserProperty(to: .verify(isDone: true))
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "PushNotificationReceived"),
                object: nil,
                userInfo: nil
            )
        } catch(let error) {
            self.handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        guard let error = error as? GentiError else {
            EventLogManager.shared.logEvent(.error(errorCode: "Unknowned", errorMessage: error.localizedDescription))
            state.showAlert = .reportError(action: {self.router.popToRoot()})
            return
        }
        EventLogManager.shared.logEvent(.error(errorCode: error.code, errorMessage: error.message))
        state.showAlert = .reportError(action: {self.router.popToRoot()})
    }
    
}

struct FaceCertificationView: View {
    @State var viewModel: FaceCertificationViewModel
    
    var body: some View {
        ZStack {
            if let image = viewModel.state.image {
                VStack {
                    HStack(alignment: .center) {
                        Spacer()
                        Image(.xmarkGray2)
                            .frame(width: 24, height: 24)
                            .background(.black.opacity(0.001))
                            .onTapGesture {
                                EventLogManager.shared.logEvent(.clickButton(page: .verify2, buttonName: "exit"))
                                self.viewModel.sendAction(.xmarkTap)
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .padding(.horizontal, 16)
                    
                    Text("촬영이 완료되었습니다.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .pretendard(.openChatHeadline)
                        .padding(.top, 16)
                    
                    Text("AI가 얼굴을 인식하지 못하면 사진 생성이 제한될 수 있어요.\n얼굴이 가려지지 않도록 주의해주세요.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)
                        .pretendard(.openChatSubtitle)
                        .padding(.top, 16)
                    
                    Spacer()
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.isWiderThan375pt ? 400 : 330)
                        .frame(width: Constants.screenWidth - 60)
                        .clipped()
                        .overlay {
                            ZStack {
                                Rectangle()
                                    .stroke(Color.gentiGreen, lineWidth: 2)
                                
                                VStack {
                                    Spacer()
                                    Text("해당 사진은 본인 인증에만 활용되며\n사진을 만들 때는 앨범에서 선택할 수 있어요!")
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(.gentiGreen)
                                        .pretendard(.small)
                                        .padding(.bottom, 16)
                                }
                            }
                        }
                        
                    Spacer()
                    
                    Text("다시 촬영하기")
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .pretendard(.openChatTitle1)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .asButton {
                            EventLogManager.shared.logEvent(.clickButton(page: .verify2, buttonName: "photoretake"))
                            self.viewModel.sendAction(.takePictureTap)
                        }
                    
                    
                    Text("본인 인증 완료하기")
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .pretendard(.openChatTitle1)
                        .background(Color.buttonGreen3)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .asButton {
                            EventLogManager.shared.logEvent(.clickButton(page: .verify2, buttonName: "verifymedone"))
                            self.viewModel.sendAction(.completeCertificationButtonTap)
                        }
                        .padding(.top, 11)
                }
                .frame(maxWidth: .infinity)
                .background {
                    Color.black
                        .ignoresSafeArea()
                }
            } else {
                VStack {
                    HStack(alignment: .center) {
                        Spacer()
                        Image(.xmarkGray2)
                            .frame(width: 24, height: 24)
                            .background(.black.opacity(0.001))
                            .onTapGesture {
                                EventLogManager.shared.logEvent(.clickButton(page: .verify1, buttonName: "exit"))
                                self.viewModel.sendAction(.xmarkTap)
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .padding(.horizontal, 16)
                    Text("사진을 만들기 전에\n본인 인증을 진행해주세요.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .pretendard(.openChatHeadline)
                        .padding(.top, 16)
                    
                    Text("사진 도용 없는 젠티를 위해 본인 촬영을 진행합니다.\n본인 인증은 1회만 진행되니 얼굴을 명확하게 촬영해주세요.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .pretendard(.openChatSubtitle)
                        .padding(.top, 16)
                    
                    Text("(자녀의 사진을 만드는 경우, 자녀의 얼굴을 촬영해주세요.)")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)
                        .pretendard(.openChatSubtitle)
                        .padding(.top, 0)
                    
                    Spacer()
                    
                    Image(.tooltipVerify)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 49)
                    
                    
                    Text("본인 인증하기")
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .pretendard(.openChatTitle1)
                        .background(LinearGradient.buttonGreen)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .asButton {
                            EventLogManager.shared.logEvent(.clickButton(page: .verify1, buttonName: "verifyme"))
                            self.viewModel.sendAction(.takePictureTap)
                        }
                        .padding(.top, 16)
                    
                    Text("타인의 얼굴을 도용하는 것은 명백한 범죄행위에 해당하며\n시도만으로도 법적인 제재를 받을 수 있습니다.")
                        .foregroundStyle(.white.opacity(0.3))
                        .multilineTextAlignment(.center)
                        .pretendard(.certificationDescription)
                        .padding(.top, 16)
                }
                .background {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                        Image(.verifyBG)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .ignoresSafeArea()
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .onFirstAppear {
            EventLogManager.shared.logEvent(.verifyAppear)
        }
        .fullScreenCover(isPresented: $viewModel.state.showCamera, content: {
            CameraView(image: $viewModel.state.image)
        })
        .customAlert(alertType: $viewModel.state.showAlert)
    }
}

#Preview {
//    FaceCertificationView(router: .init())
}

