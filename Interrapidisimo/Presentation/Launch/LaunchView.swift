//
//  LaunchView.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import SwiftUI

struct LaunchView: View {
	@StateObject private var viewModel = LaunchViewModel()
	
	var body: some View {
		NavigationStack(path: $viewModel.navigationPath) {
			SplashView()
				.navigationDestination(for: AppRoute.self) { route in
					switch route {
						case .login:
							LoginView(navigationPath: $viewModel.navigationPath)
						case .home:
							HomeView(navigationPath: $viewModel.navigationPath)
						case .tables:
							TablesView()
						case .localities:
							LocalitiesView()
						case .photos:
							PhotosView(navigationPath: $viewModel.navigationPath)
						case .photoDetail(let photos, let index):
							PhotoDetailView(photos: photos, initialIndex: index)
					}
				}
		}
		.alert("Información", isPresented: $viewModel.showAlert) {
			Button("Aceptar", role: .cancel) { }
		} message: {
			Text(viewModel.alertMessage)
		}
		.task {
			await viewModel.initialize()
		}
	}
}


struct SplashView: View {
	var body: some View {
		ZStack {
			Color.blue.ignoresSafeArea()
			
			VStack {
				Image(systemName: "shippingbox.fill")
					.font(.system(size: 100))
					.foregroundColor(.white)
				
				Text("Interrapidísimo")
					.font(.largeTitle)
					.fontWeight(.bold)
					.foregroundColor(.white)
				
				ProgressView()
					.tint(.white)
					.padding(.top, 20)
			}
		}
	}
}
