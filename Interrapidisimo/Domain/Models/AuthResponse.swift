//
//  AuthResponse.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import Foundation

struct AuthResponse: Codable {
    let usuario: String?
    let identificacion: String?
    let nombre: String?
    let apellido1: String?
    let apellido2: String?
    let cargo: String?
    let mensajeResultado: Int?

    enum CodingKeys: String, CodingKey {
        case usuario = "Usuario"
        case identificacion = "Identificacion"
        case nombre = "Nombre"
        case apellido1 = "Apellido1"
        case apellido2 = "Apellido2"
        case cargo = "Cargo"
        case mensajeResultado = "MensajeResultado"
    }

    func toUser() -> User {
        return User(
            usuario: usuario ?? "unknown",
            identificacion: identificacion ?? "N/A",
            nombre: nombre ?? "Nombre"
        )
    }
} 
