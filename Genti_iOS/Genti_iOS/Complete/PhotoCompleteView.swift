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
        .addPopUp(isPresent: $viewModel.state.showRatingView, popUpType: .ratingPopUp)
        .onReceive(NotificationCenter.default.publisher(for: .init("ratingCompleted"))) { _ in
            self.viewModel.sendAction(.ratingActionIsDone)
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
        .customAlert(alertType: $viewModel.state.showAlert)
    }
}



protocol PopUp {
    associatedtype Content: View
    /// popUpView는 View라는 프로토콜을 채택한 어떤 종류의 객체라도 가능하다
    var popUpView: Content { get }
    /// 이렇게 받은 popUpView를 가지고 custom할것이기때문에 여기는 어떤뷰가 들어올지 모르니까 AnyView로 감싼다
    /// 결국 popUpView를 나중에는 AnyView로 만들어줘야한다
    /// 이렇게한 이유는 popup을 만드는사람 입장에서는 AnyView를 쓴다는걸 모르게하는게 훨씬 편하기 때문
    /// 즉 그냥 Custom View를 받고 내부적으로 AnyView를 만들어서 customize해준다
    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters { get }
}

struct PopUpModifier: ViewModifier {
    var isPresent: Binding<Bool>
    var popUp: AnyPopUp
    
    init(isPresent: Binding<Bool>, popUpType: PopUpType) {
        self.isPresent = isPresent
        self.popUp = popUpType.object
    }
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: isPresent, view: { popUp._popUpView }, customize: popUp._customize)
    }
}

extension View {
    func addPopUp(isPresent: Binding<Bool>, popUpType: PopUpType) -> some View {
        modifier(PopUpModifier(isPresent: isPresent, popUpType: popUpType))
    }
}



struct AnyPopUp {
    var _popUpView: AnyView
    var _customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters
    
    init<PopUpObject: PopUp>(popUp: PopUpObject) {
        self._popUpView = AnyView(popUp.popUpView)
        self._customize = popUp.customize
    }
    
    var popUpView: AnyView {
        return _popUpView
    }
    var customize: (Popup<AnyView>.PopupParameters) -> Popup<AnyView>.PopupParameters {
        return _customize
    }
}

enum PopUpType {
    case selectOnboardingPopUp
    case ratingPopUp
    
    /// object타입을 some PopUp으로 하면 되지 않을까요?
    /// some이라는건 사용시점에서 무조건 하나의 타입으로 결정되어야함
    /// 하지만 case마다 객체가 달라짐 즉, PopUp프로토콜을 채택한 하나의 객체만 나와야하는데 case의 갯수별로 나오게됨
    /// some은 타입을 제한하는거지만
    /// "popup을 채택하기만했으면 괜찮아(=지금 우리가 만들고싶은로직)"는 타입의 추상화라고 할 수 있음
    /// 하지만 associatedtype을 사용한순간 해당프로토콜을 채택한 객체는 타입이 제한됨
    /// 결국 우리는 타입을 제한한 상황에서 타입을 추상화하려하는 상황에 마주함
    /// 추상화하는 가장쉬운방법 any PopUp을 반환타입으로 하면된다 하지만 이렇게되면 쓸때마다 downcasting을 해줘야한다
    var object: AnyPopUp {
        switch self {
        case .selectOnboardingPopUp:
            return AnyPopUp(popUp: SelectOnboardingPopUp())
        case .ratingPopUp:
            return AnyPopUp(popUp: RatingPopUp())
        }
    }
}

struct SelectOnboardingPopUp: PopUp {
    /// some View는 View라는 프로토콜을 채택한 하나의 타입이라는 뜻이다
    /// opaque type으로 사용시점에선 알수가없다(다만 하나의 타입으로 고정된다는건안다)
    /// 하지만 구현시점에서는 Image라는걸 알수있다
    var popUpView: some View {
        Image(.selectOnboarding)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 16)
    }
    
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

struct RatingPopUp: PopUp {
    var popUpView: some View {
        RatingAlertView(viewModel: RatingAlertViewModel(userRepository: UserRepositoryImpl(requestService: RequestServiceImpl())))
    }
    
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
