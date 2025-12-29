//
//  LoginUseCase.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation

struct LoginUseCase {
    private let authService: InterrapidisimoAPI.AuthService
    private let authRepository: AuthRepositoryProtocol

    init(
        authService: InterrapidisimoAPI.AuthService? = nil,
        authRepository: AuthRepositoryProtocol? = nil
    ) {
        self.authService = authService ?? .init()
        self.authRepository = authRepository ?? AuthRepository()
    }

    func execute() async throws -> User {
        let authResponse = try await authService.login()

        #if DEBUG
            print("📦 LoginUseCase: Respuesta recibida del servidor")
            print("   - Usuario: \(authResponse.usuario ?? "nil")")
            print("   - Identificación: \(authResponse.identificacion ?? "nil")")
            print("   - Nombre: \(authResponse.nombre ?? "nil")")
            print("   - Mensaje Resultado: \(authResponse.mensajeResultado ?? -1)")
        #endif

        
        let user = authResponse.toUser()

        try authRepository.saveUser(user)

        #if DEBUG
            print("💾 LoginUseCase: Usuario guardado en base de datos")
            print("✅ LoginUseCase: Login completado exitosamente")
        #endif

        return user
    }

    func getStoredUser() throws -> User? {
        return try authRepository.getUser()
    }

    func logout() throws {
        try authRepository.deleteUser()
    }
}
