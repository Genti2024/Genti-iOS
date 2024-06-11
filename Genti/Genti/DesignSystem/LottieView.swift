//
//  LottieView.swift
//  Genti
//
//  Created by uiskim on 6/3/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    var lottieFile: String
    var loopMode: LottieLoopMode = .loop
    var animationView = LottieAnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = loopMode
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        

        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    }
}

struct Lottie: View {
    var body: some View {
        LottieView(lottieFile: "ProgressLottie")
    }
}

#Preview {
    Lottie()
}
