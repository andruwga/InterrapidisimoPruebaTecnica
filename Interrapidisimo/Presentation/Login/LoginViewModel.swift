//
//  LoginViewModel.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Combine
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""

    private let loginUseCase: LoginUseCase
    private let syncSchemaUseCase: SyncSchemaUseCase

    init(
        loginUseCase: LoginUseCase? = nil,
        syncSchemaUseCase: SyncSchemaUseCase? = nil
    ) {
        self.loginUseCase = loginUseCase ?? .init()
        self.syncSchemaUseCase = syncSchemaUseCase ?? .init()
    }

    func login(onSuccess: @escaping () -> Void) async {
        isLoading = true

        do {
			_ = try await loginUseCase.execute()
            _ = try await syncSchemaUseCase.execute()
            isLoading = false
            onSuccess()

        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
