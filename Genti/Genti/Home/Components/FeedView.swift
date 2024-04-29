//
//  FeedView.swift
//  Genti
//
//  Created by uiskim on 4/19/24.
//

import SwiftUI
import SwiftfulUI

struct FeedView: View {
    
    var profileImage: String = Constants.randomImage
    var userName: String = "i_am_GenTi"
    var mainImage: String = "SampleImage32"
    var description: String = Constants.text(length: 55)
    
    @State var likeCount: Int = 123
    @State private var isLike: Bool = false
    @State private var isExpaned: Bool = false
    @State private var isOver: Bool = false
    
    var onLikePressed: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            feedHeaderView()
            /// 추후 url로 수정
            feedImageView()
            feedDetailView()
            
        } //:VSTACK
        .padding(.vertical, 12)
        .overlay (
            RoundedRectangle(cornerRadius: 10)
                .fill(.clear)
                .stroke(.gray6, lineWidth: 1)
        )
        .animation(.bouncy(duration: 0.2), value: isLike)
    }
    
    private func feedHeaderView() -> some View {
        HStack(spacing: 14) {
            ImageLoaderView(urlString: profileImage)
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            
            Text("\(userName)")
                .pretendard(.small)
        } //:HSTACK
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
    }
    
    private func isOverButton() -> some View {
        Text("더보기")
            .pretendard(.small)
            .bold()
            .foregroundStyle(.gentiGreen)
            .frame(width: 57, alignment: .trailing)
            .background(
                LinearGradient(
                    colors: [
                        .backgroundWhite.opacity(0),
                        .backgroundWhite.opacity(1),
                        .backgroundWhite.opacity(1),
                        .backgroundWhite.opacity(1),
                        .backgroundWhite.opacity(1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
            )
            .onTapGesture {
                isExpaned.toggle()
            }
            .opacity(isExpaned ? 0 : 1)
    }
    
    private func feedDetailView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Image(isLike ? "Like_fill" : "Like_empty")
                .onTapGesture {
                    tap()
                }
            
            Text("\(likeCount)명이 좋아합니다.")
                .pretendard(.number)
                .font(.caption)
            
            Text(description)
                .pretendard(.small)
                .readingFrame { frame in
                    self.isOver = isOver(
                        for: description,
                        in: frame.size,
                        lines: 2
                    )
                }
                .lineLimit(isExpaned ? nil : 2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .bottomTrailing) {
                    if isOver {
                        isOverButton()
                    }
                }
        } //:VSTACK
        .padding(.horizontal, 12)
    }
    
    private func feedImageView() -> some View {
        Image(mainImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onTapGesture(count: 2, perform: {
                tap()
            })
    }
    
    private func tap() {
        isLike.toggle()
        likeCount += isLike ? 1 : -1
    }
}

private extension FeedView {
    func isOver(for text: String, in size: CGSize, lines: Int) -> Bool {
        let totalHeight = self.height(for: text, in: size)
        let oneHeight = self.height(for: "1", in: size)
        if totalHeight > (oneHeight * CGFloat(lines)) {
            return true
        }
        return false
    }
    
    
    func height(for text: String, in size: CGSize) -> CGFloat {
        let font = UIFont(name: "Pretendard-Medium", size: 14)!
        let attributedText = NSAttributedString(string: text, attributes: [.font: font])
        let constraintRect = CGSize(width: size.width, height: .greatestFiniteMagnitude)
        let boundingBox = attributedText.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return boundingBox.height
    }
}

#Preview {
    ZStack {
        // Background Color
        Color.backgroundWhite
            .ignoresSafeArea()
        // Content
        ScrollView {
            VStack(spacing: 10) {
                FeedView()
                FeedView(description: Constants.text(length: 100))
                FeedView(mainImage: "SampleImage23")
            }
        }
        .padding()
    } //:ZSTACK
}
