//
//  PopupImagePickerView.swift
//  Genti
//
//  Created by uiskim on 4/28/24.
//

import SwiftUI
import Photos

import SwiftfulUI

struct PopupImagePickerView: View {
    @State private var scrollViewHeight: CGFloat = 0
    @State private var cellHeight: CGFloat = 0
    @ObservedObject var imagePickerModel: ImagePickerViewModel
    @EnvironmentObject var generatorViewModel: GeneratorViewModel
    @Environment(\.dismiss) private var dismiss
    

    var onEnd: (() -> Void)? = nil
    var onSelect: (([PHAsset]) -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Background Color
            Color.black
                .ignoresSafeArea()
            // Content
            VStack(spacing: 0) {
                HStack {
                    Text("Select Images")
                        .bold()
                        .font(.callout)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        // Action
                        onEnd?()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.primary)
                    }
                } //:HSTACK
                .padding([.horizontal, .top])
                .padding(.bottom, 10)
                
                ScrollViewWithOnScrollChanged {
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 3)) {
                        ForEach(imagePickerModel.fetchedImages) { imageAsset in
                            gridContent(imageAsset: imageAsset)
                                .aspectRatio(1, contentMode: .fit)
                                .readingFrame { frame in
                                    guard cellHeight == 0 else { return }
                                    cellHeight = frame.height
                                }
                        }
                    }

                } onScrollChanged: { origin in
                    if scrollViewHeight > origin.y {
                        self.imagePickerModel.getPhotosWithPagination()
                    }
                }
                .padding(.horizontal, 10)
                .onReadSize({ size in
                    self.scrollViewHeight = size.height
                })
            } //:VSTACK
            
            Button {
                // Action
                self.generatorViewModel.setImageAsset(asset: imagePickerModel.selectedImages[0])
                dismiss()
            } label: {
                Text("추가하기")
                    .foregroundStyle(.white)
                    .padding()
                    .background(.red)
                    
            }
            .disabled(!imagePickerModel.isReachLimit)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            
        } //:ZSTACK
    }
    
    func gridContent(imageAsset: ImageAsset) -> some View {
            ZStack {
                ImageView(from: imageAsset.asset)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.black.opacity(0.1))
                    Circle()
                        .fill(.white.opacity(0.2))
                    Circle()
                        .stroke(.white, lineWidth: 1)
                    
                    if let index = imagePickerModel.selectedImages.firstIndex(where: { asset in
                        asset.id == imageAsset.id
                    }) {
                        Circle()
                            .fill(.blue)
                        Text("\(imagePickerModel.selectedImages[index].assetIndex + 1)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                    }
                    
                }
                .frame(width: 15, height: 15)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(4)
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    if let index = imagePickerModel.selectedImages.firstIndex(where: { asset in
                        return asset.id == imageAsset.id
                    }) {
                        imagePickerModel.selectedImages.remove(at: index)
                        imagePickerModel.selectedImages.enumerated().forEach { item in
                            imagePickerModel.selectedImages[item.offset].assetIndex = item.offset
                        }
                    } else {
                        guard !imagePickerModel.isReachLimit else { return }
                        var newAsset = imageAsset
                        newAsset.assetIndex = imagePickerModel.selectedImages.count
                        imagePickerModel.selectedImages.append(newAsset)
                    }
                }
            }
    }
}


extension View {
  @ViewBuilder
  func onReadSize(_ perform: @escaping (CGSize) -> Void) -> some View {
    self.customBackground {
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    }
    .onPreferenceChange(SizePreferenceKey.self, perform: perform)
  }
  
  @ViewBuilder
  func customBackground<V: View>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View {
    self.background(alignment: alignment, content: content)
  }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}
