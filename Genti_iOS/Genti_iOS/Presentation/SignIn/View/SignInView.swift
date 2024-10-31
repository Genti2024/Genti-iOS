//
//  CollectUserInfomationView.swift
//  Genti_iOS
//
//  Created by uiskim on 7/24/24.
//

import SwiftUI

struct SignInView: View {
    
    @State var viewModel: SignInViewModel
    @FocusState var isFocused: Bool
    var body: some View {
        VStack(spacing: 0) {
            headerView()
            
            VStack(spacing: 59) {
                genderSelectView()
                birthYearSelectView()
            }
            .padding(.top, 62)

            Spacer()
            GentiPrimaryButton(title: "완료", isActive: viewModel.isActive) {
                viewModel.sendAction(.completeButtonTap)
            }
            .padding(.bottom, 18)
        } //:VSTACK
        .focused($isFocused)
        .ignoresSafeArea(.keyboard)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color.geintiBackground
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }
        )
        .overlay(alignment: .center) {
            if viewModel.state.isLoading {
                LoadingView()
            }
        }
        .onAppear {
            self.viewModel.sendAction(.viewWillAppear)
        }
        .toolbar(.hidden, for: .navigationBar)
        .customAlert(alertType: $viewModel.state.showAlert)
    }
    
    func headerView() -> some View {
        VStack(spacing: 8) {
            Text("성별과 나이를 알려주세요.")
                .pretendard(.title1_24_bold)
                .foregroundStyle(.white)
            
            Text("사진을 더 잘 표현하기 위해 활용됩니다.")
                .pretendard(.body_14_medium)
                .foregroundStyle(.white.opacity(0.6))
        } //:VSTACK
        .padding(.top, 76)
    }
    
    func genderSelectView() -> some View {
        VStack(spacing: 18) {
            Text("성별")
                .pretendard(.body_14_bold)
                .foregroundStyle(.gentiGreenNew)
            
            HStack(spacing: 8) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    GentiBorderButton(title: gender.rawValue, isActive: gender == viewModel.state.gender, imageAssetName: gender.image, subtitle: nil) {
                        viewModel.sendAction(.genderSelect(gender))
                    }
                }
            }
        } //:VSTACK
    }
    
    func birthYearSelectView() -> some View {
        VStack(spacing: 18) {
            Text("출생년도")
                .pretendard(.body_14_bold)
                .foregroundStyle(.gentiGreenNew)
            TextField("YYYY", text: .init(get: {
                return viewModel.state.birthYear ?? ""
            }, set: { year in
                viewModel.state.birthYear = year
            }))
            .pretendard(.subtitle2_16_medium)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .frame(width: 100)
            .keyboardType(.numberPad)
            
            Rectangle()
                .fill(viewModel.state.birthYear?.count == 4 ? LinearGradient.gentiGradation : LinearGradient(colors: [.white.opacity(0.2)], startPoint: .bottom, endPoint: .top))
                .cornerRadius(2, corners: .allCorners)
                .frame(height: 4)
                .frame(width: 308)
                
        } //:VSTACK
    }
}

#Preview {
    SignInView(viewModel: SignInViewModel(signInUseCase: SignInUseCaseImpl(authRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl()), router: .init()))
}
