//
//  PhotoDetailView.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import SwiftUI

struct PhotoDetailView: View {
	let photos: [Photo]
	let initialIndex: Int
	@Environment(\.dismiss) private var dismiss
	@State private var currentIndex: Int
	@State private var scale: CGFloat = 1.0
	@State private var lastScale: CGFloat = 1.0

	init(photos: [Photo], initialIndex: Int) {
		self.photos = photos
		self.initialIndex = initialIndex
		_currentIndex = State(initialValue: initialIndex)
	}

	var currentPhoto: Photo {
		photos[currentIndex]
	}

	var body: some View {
		ZStack {
			Color.black.ignoresSafeArea()
			VStack {
				HStack {
					VStack(alignment: .leading, spacing: 4) {
						Text(currentPhoto.name)
							.font(.headline)
							.foregroundColor(.white)

						Text("\(currentIndex + 1) de \(photos.count)")
							.font(.caption)
							.foregroundColor(.white.opacity(0.7))
					}

					Spacer()

					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark.circle.fill")
							.font(.title2)
							.foregroundColor(.white)
					}
				}
				.padding()

				
				TabView(selection: $currentIndex) {
					ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
						GeometryReader { geometry in
							ZStack {
								Image(uiImage: photo.image)
									.resizable()
									.scaledToFit()
									.frame(width: geometry.size.width, height: geometry.size.height)
									.scaleEffect(currentIndex == index ? scale : 1.0)
									.gesture(
										MagnificationGesture()
											.onChanged { value in
												if currentIndex == index {
													scale = lastScale * value
												}
											}
											.onEnded { _ in
												if currentIndex == index {
													lastScale = scale
													if scale < 1.0 {
														withAnimation {
															scale = 1.0
															lastScale = 1.0
														}
													} else if scale > 5.0 {
														withAnimation {
															scale = 5.0
															lastScale = 5.0
														}
													}
												}
											}
									)
									.onTapGesture(count: 2) {
										if currentIndex == index {
											withAnimation {
												if scale > 1.0 {
													scale = 1.0
													lastScale = 1.0
												} else {
													scale = 2.0
													lastScale = 2.0
												}
											}
										}
									}
							}
							.frame(maxWidth: .infinity, maxHeight: .infinity)
						}
						.tag(index)
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				.onChange(of: currentIndex) { oldValue, newValue in
					if oldValue != newValue {
						withAnimation {
							scale = 1.0
							lastScale = 1.0
						}
					}
				}

				
				VStack(spacing: 8) {
					HStack(spacing: 20) {
						Label("Swipe para navegar", systemImage: "hand.draw")
						Label("Doble tap para zoom", systemImage: "arrow.up.left.and.arrow.down.right")
					}
					.font(.caption)
					.foregroundColor(.white.opacity(0.7))
				}
				.padding()
			}
			.navigationBarBackButtonHidden(true)
		}
	}
}
