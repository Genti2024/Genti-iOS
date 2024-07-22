//
//  PhotoCompleteView.swift
//  Genti
//
//  Created by uiskim on 5/31/24.
//

import SwiftUI

import PopupView

struct PhotoCompleteView: View {

    @State var viewModel: PhotoCompleteViewViewModel

    var body: some View {
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                if viewModel.photoInfo.imageRatio == .threeSecond {
                    VerticalImageContentView(viewModel: viewModel)
                } else {
                    HorizontalImageContentView(viewModel: viewModel)
                }
                
                Spacer()
                
                ShareLink(item: viewModel.getImage, preview: .init("내 사진", image: viewModel.getImage)) {
                    Text("공유하기")
                        .shareStyle()
                }
                .disabled(viewModel.disabled)
                
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
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background {
                Color.backgroundWhite
                    .ignoresSafeArea()
            }
            .overlay(alignment: .center) {
                if viewModel.state.isLoading {
                    LoadingView()
                }
            }
        }
        .addCustomPopup(isPresented: $viewModel.state.showRatingView, popupType: .rating)
        .onReceive(NotificationCenter.default.publisher(for: .init("ratingCompleted"))) { _ in
            self.viewModel.sendAction(.ratingActionIsDone)
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
        .customAlert(alertType: $viewModel.state.showAlert)
    }
}


/// CustomPopup 프로토콜은 팝업 콘텐츠와 커스터마이징 옵션을 정의합니다.
protocol CustomPopup {
    associatedtype Content: View
    /// contentView는 View라는 프로토콜을 채택한 어떤 종류의 객체라도 가능하다.
    var contentView: Content { get }
    /// 이렇게 받은 contentView를 가지고 custom할 것이기 때문에 여기는 어떤 뷰가 들어올지 모르니까 AnyView로 감싼다.
    /// 결국 contentView를 나중에는 AnyView로 만들어줘야 한다.
    /// 이렇게 한 이유는 popup을 만드는 사람 입장에서는 AnyView를 쓴다는 걸 모르게 하는 게 훨씬 편하기 때문.
    /// 즉, 그냥 Custom View를 받고 내부적으로 AnyView를 만들어서 customize해준다.
    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters { get }
}

/// CustomPopupModifier는 뷰에 팝업을 추가하는 뷰 모디파이어입니다.
struct CustomPopupModifier: ViewModifier {
    var isPresented: Binding<Bool>
    var customPopup: AnyCustomPopup
    
    init(isPresented: Binding<Bool>, popupType: PopupType) {
        self.isPresented = isPresented
        self.customPopup = popupType.object
    }
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: isPresented, view: { customPopup.contentView }, customize: customPopup.customize)
    }
}

/// View 확장을 통해 쉽게 팝업을 추가할 수 있는 메서드를 제공합니다.
extension View {
    func addCustomPopup(isPresented: Binding<Bool>, popupType: PopupType) -> some View {
        modifier(CustomPopupModifier(isPresented: isPresented, popupType: popupType))
    }
}

/// AnyCustomPopup 구조체는 다양한 팝업 타입을 AnyView로 감싸서 다룰 수 있게 합니다.
struct AnyCustomPopup {
    var contentView: AnyView
    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters
    
    init<PopupObject: CustomPopup>(popup: PopupObject) {
        self.contentView = AnyView(popup.contentView)
        self.customize = popup.customize
    }
}

/// PopupType 열거형은 다양한 팝업 타입을 정의하고, 각 타입에 맞는 팝업 객체를 생성합니다.
enum PopupType {
    case selectOnboarding
    case rating
    
    /// 팝업 타입에 맞는 AnyCustomPopup 객체를 반환합니다.
    var object: AnyCustomPopup {
        switch self {
        case .selectOnboarding:
            return AnyCustomPopup(popup: SelectOnboardingPopup())
        case .rating:
            return AnyCustomPopup(popup: RatingPopup())
        }
    }
}

/// SelectOnboardingPopup 구조체는 CustomPopup 프로토콜을 준수하며, 특정 팝업 콘텐츠와 커스터마이징 옵션을 정의합니다.
struct SelectOnboardingPopup: CustomPopup {
    /// contentView는 특정 팝업 콘텐츠를 나타냅니다.
    var contentView: some View {
        Image("selectOnboarding")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 16)
    }
    
    /// customize는 팝업의 커스터마이징 옵션을 정의합니다.
    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters {
        return { parameters in
            parameters
                .appearFrom(.bottomSlide)
                .animation(.easeInOut(duration: 0.3))
                .closeOnTapOutside(true)
                .backgroundColor(Color.black.opacity(0.3))
        }
    }
}

/// RatingPopup 구조체는 CustomPopup 프로토콜을 준수하며, 특정 팝업 콘텐츠와 커스터마이징 옵션을 정의합니다.
struct RatingPopup: CustomPopup {
    /// contentView는 특정 팝업 콘텐츠를 나타냅니다.
    var contentView: some View {
        RatingAlertView(viewModel: RatingAlertViewModel(userRepository: UserRepositoryImpl(requestService: RequestServiceImpl())))
    }
    
    /// customize는 팝업의 커스터마이징 옵션을 정의합니다.
    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters {
        return { parameters in
            parameters
                .appearFrom(.bottomSlide)
                .animation(.easeInOut(duration: 0.3))
                .closeOnTap(false)
                .closeOnTapOutside(false)
                .backgroundColor(Color.black.opacity(0.3))
        }
    }
}



//protocol A {
//    associatedtype Content = Int
//}
//
//class One: A {}
//class Two: A {}
//
//enum B {
//    case OneOne, TwoTwo
//    
//    var object: any A {
//        switch self {
//        case .OneOne:
//            return One()
//        case .TwoTwo:
//            return Two()
//        }
//    }
//}
