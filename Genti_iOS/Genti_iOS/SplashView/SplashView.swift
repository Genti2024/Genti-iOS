//
//  SplashView.swift
//  Genti
//
//  Created by uiskim on 6/13/24.
//

import SwiftUI

import SDWebImageSwiftUI
import Lottie

struct SplashView: View {
    @Bindable var router: Router<MainRoute>
    @State private var play: Bool = false
    var body: some View {
        ALottieView(animationName: "SplashLottie", play: $play) {
            router.routeTo(.login)
        }
            .ignoresSafeArea()
            .onAppear {
                self.play = true
            }
    }
}


struct ALottieView: UIViewRepresentable {
    let animationName: String
    @Binding var play: Bool
    var animationView: LottieAnimationView
    var onComplete: (() -> Void)?

    init(animationName: String,
         play: Binding<Bool> = .constant(true),
         onComplete: (() -> Void)? = nil
    ) {
        self.animationName = animationName
        self.animationView = LottieAnimationView(name: animationName)
        self._play = play
        self.onComplete = onComplete
    }

    class Coordinator: NSObject {
        @Binding var play: Bool
        let parent: ALottieView

        init(parent: ALottieView, play: Binding<Bool>) {
            self.parent = parent
            _play = play
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, play: $play)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if play {
            animationView.play { [self] _ in
                play.toggle()
                onComplete?()
            }
        }
    }
}
