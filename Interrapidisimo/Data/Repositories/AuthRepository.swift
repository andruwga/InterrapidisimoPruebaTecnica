//
//  AuthRepositoryProtocol.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import Foundation

protocol AuthRepositoryProtocol {
    func saveUser(_ user: User) throws
    func getUser() throws -> User?
    func deleteUser() throws
}

final class AuthRepository: AuthRepositoryProtocol {
    private let database: SQLiteClient

    init(database: SQLiteClient = .shared) {
        self.database = database
    }

    func saveUser(_ user: User) throws {
        try? deleteUser()

        let query = """
        INSERT INTO users (usuario, identificacion, nombre)
        VALUES ('\(user.usuario)', '\(user.identificacion)', '\(user.nombre)');
        """

        try database.execute(query)
    }

    func getUser() throws -> User? {
        let query = "SELECT * FROM users ORDER BY id DESC LIMIT 1;"
        let results = try database.query(query)

        guard let row = results.first,
              let usuario = row["usuario"] as? String,
              let identificacion = row["identificacion"] as? String,
              let nombre = row["nombre"] as? String else {
            return nil
        }

        return User(
            usuario: usuario,
            identificacion: identificacion,
            nombre: nombre
        )
    }

    func deleteUser() throws {
        let query = "DELETE FROM users;"
        try database.execute(query)
    }
}
