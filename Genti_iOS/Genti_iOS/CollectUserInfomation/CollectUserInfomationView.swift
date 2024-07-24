//
//  CollectUserInfomationView.swift
//  Genti_iOS
//
//  Created by uiskim on 7/24/24.
//

import SwiftUI

struct CollectUserInfomationView: View {
    
    @State private var viewModel: CollectUserInfomationViewModel = .init()
    
    var body: some View {
        VStack(spacing: 62) {
            headerView()
            
            VStack(spacing: 59) {
                genderSelectView()
                birthYearSelectView()
            }
        } //:VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            backgroundView()
        )
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
                    genderSelectButton(gender)
                        .onTapGesture {
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
            
            Spacer(minLength: 10)
            
            completeButton()
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
    
    private func genderSelectButton(_ gender: Gender) -> some View {
        Text("\(gender.description)")
            .pretendard(viewModel.genderFont(gender))
            .frame(width: 137, height: 39)
            .foregroundStyle(viewModel.genderForegoundStyle(gender))
            .cornerRadiusWithBorder(style: viewModel.genderForegoundStyle(gender), radius: 8, lineWidth: 1)
            .background(.black.opacity(0.001))
    }
    
    private func birthYearSelectedView() -> some View {
        Text("\(viewModel.birthYear)년")
            .pretendard(.headline2)
            .foregroundStyle(.gentiGreen)
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
    
    private func completeButton() -> some View {
        Text("입력 완료")
            .pretendard(viewModel.completeButtonFont)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(viewModel.completeButtonBackground)
            .foregroundStyle(viewModel.completeButtonForeground)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.horizontal, 28)
            .padding(.bottom, 18)
            .asButton {
                viewModel.sendAction(.completeButtonTap)
            }
            .disabled(!viewModel.isComplete)
    }
    
    private func birthYearPicker() -> some View {
        Picker("BirthYearPicker", selection: $viewModel.state.birthYear) {
            ForEach(viewModel.state.years, id: \.self) { i in
                Text("\(i.formatterStyle(.none))")
            }
        }
        .pickerStyle(.wheel)
        .background(.gray6)
        .clipShape(.rect(cornerRadius: 13))
        .padding(.horizontal, 86)
    }
}

#Preview {
    CollectUserInfomationView()
}
