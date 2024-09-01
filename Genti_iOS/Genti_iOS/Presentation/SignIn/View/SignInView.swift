//
//  CollectUserInfomationView.swift
//  Genti_iOS
//
//  Created by uiskim on 7/24/24.
//

import SwiftUI

struct SignInView: View {
    
    @State var viewModel: SignInViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            headerView()
            
            VStack(spacing: 59) {
                genderSelectView()
                birthYearSelectView()
            }
            .padding(.top, 62)

            Spacer()
            GentiPrimaryButton(title: "입력 완료", isActive: viewModel.isActive) {
                viewModel.sendAction(.completeButtonTap)
            }
            .padding(.bottom, 18)
        } //:VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            backgroundView()
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
            Image(.gentiLOGO)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 113, height: 38)
            
            Text("사진을 더 나처럼 표현하기 위해\n아래의 정보가 더 필요해요!")
                .multilineTextAlignment(.center)
                .pretendard(.small)
                .foregroundStyle(.black)
        } //:VSTACK
        .padding(.top, 41)
    }
    
    func genderSelectView() -> some View {
        VStack(spacing: 18) {
            Text("성별을 알려주세요!")
                .pretendard(.normal)
                .foregroundStyle(.black)
            
            HStack(spacing: 23) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    GentiBorderButton(title: gender.rawValue, isActive: gender == viewModel.state.gender) {
                        viewModel.sendAction(.genderSelect(gender))
                    }
                }
            }
        } //:VSTACK
    }
    
    func birthYearSelectView() -> some View {
        VStack(spacing: 18) {
            Text("태어난 연도를 알려주세요!")
                .pretendard(.normal)
                .foregroundStyle(.black)
            
            birthYearContent()
                .onTapGesture {
                    viewModel.sendAction(.birthYearSelect)
                }

            if self.viewModel.state.showPicker {
                birthYearPicker()
            }
        } //:VSTACK
    }
    
    func backgroundView() -> some View {
        Image(.getInfoBackground)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
            .onTapGesture {
                viewModel.sendAction(.backgroundTap)
            }
    }
    
    @ViewBuilder
    private func birthYearContent() -> some View {
        if !viewModel.state.firstTap {
            birthYearInitalView()
        } else {
            birthYearSelectedView()
        }
    }
    
    private func birthYearSelectedView() -> some View {
        Text("\(viewModel.birthYear)년")
            .pretendard(.headline2)
            .foregroundStyle(.green1)
            .frame(width: 297, height: 39)
            .cornerRadiusWithBorder(style: .green1, radius: 8, lineWidth: 1)
            .background(.black.opacity(0.01))
    }
    
    private func birthYearInitalView() -> some View {
        Text("눌러서 태어난 년도 선택하기")
            .pretendard(.small)
            .foregroundStyle(.gray4)
            .frame(width: 297, height: 39)
            .cornerRadiusWithBorder(style: .gray2, radius: 8, lineWidth: 1)
            .background(.black.opacity(0.001))
    }
    
    private func birthYearPicker() -> some View {
        Picker("BirthYearPicker", selection: $viewModel.state.birthYear) {
            ForEach(viewModel.state.years, id: \.self) { i in
                Text("\(i.formatterStyle(.none))")
                    .foregroundStyle(.black)
            }
        }
        .pickerStyle(.wheel)
        .background(.gray6)
        .clipShape(.rect(cornerRadius: 13))
        .padding(.horizontal, 86)
    }
}

#Preview {
    SignInView(viewModel: SignInViewModel(signInUseCase: SignInUseCaseImpl(authRepository: AuthRepositoryImpl(requestService: RequestServiceImpl()), userdefaultRepository: UserDefaultsRepositoryImpl()), router: .init()))
}
