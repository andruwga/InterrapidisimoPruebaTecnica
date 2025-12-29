//
//  LaunchViewModel.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Combine
import Foundation


@MainActor
final class LaunchViewModel: ObservableObject {
	@Published var isLoading = true
	@Published var navigationPath: [AppRoute] = []
	@Published var showAlert = false
	@Published var alertMessage = ""
	@Published var versionStatus: VersionStatus = .upToDate
	
	private let checkVersionUseCase: CheckVersionUseCase
	private let loginUseCase: LoginUseCase
	private let syncSchemaUseCase: SyncSchemaUseCase
	private let database: SQLiteClient
	
	init(
		checkVersionUseCase: CheckVersionUseCase? = nil,
		loginUseCase: LoginUseCase? = nil,
		syncSchemaUseCase: SyncSchemaUseCase? = nil,
		database: SQLiteClient? = nil
	) {
		self.checkVersionUseCase = checkVersionUseCase ?? .init()
		self.loginUseCase = loginUseCase ?? .init()
		self.syncSchemaUseCase = syncSchemaUseCase ?? .init()
		self.database = database ?? .shared
	}
	
	func initialize() async {
		defer { isLoading = false }
		
		do {
			try database.openDatabase()
			
			let status = await fetchVersionStatus()
			versionStatus = status
			
			_ = try? await syncSchemaUseCase.execute()
			
			let route: AppRoute = (try? loginUseCase.getStoredUser()) != nil ? .home : .login
			navigationPath = [route]                 
			
			if status != .upToDate {
				alertMessage = status.message
				showAlert = true
			}
			
		} catch {
			alertMessage = "Error al inicializar: \(error.localizedDescription)"
			showAlert = true
		}
	}
	
	private func fetchVersionStatus() async -> VersionStatus {
		do {
			let versionResponse = try await checkVersionUseCase.execute()
			let localVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
			
			return checkVersionUseCase.compareVersions(
				remoteVersion: versionResponse.versionApp,
				localVersion: localVersion
			)
		} catch {
			print("⚠️ Error al verificar versión: \(error.localizedDescription)")
			return .upToDate
		}
	}
}

enum AppRoute: Hashable {
    case login
    case home
    case tables
    case localities
    case photos
    case photoDetail(photos: [Photo], index: Int)

    func hash(into hasher: inout Hasher) {
        switch self {
        case .login:
            hasher.combine("login")
        case .home:
            hasher.combine("home")
        case .tables:
            hasher.combine("tables")
        case .localities:
            hasher.combine("localities")
        case .photos:
            hasher.combine("photos")
        case let .photoDetail(_, index):
            hasher.combine("photoDetail")
            hasher.combine(index)
        }
    }

    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.login, .login),
             (.home, .home),
             (.tables, .tables),
             (.localities, .localities),
             (.photos, .photos):
            return true
        case let (.photoDetail(_, lhsIndex), .photoDetail(_, rhsIndex)):
            return lhsIndex == rhsIndex
        default:
            return false
        }
    }
}
