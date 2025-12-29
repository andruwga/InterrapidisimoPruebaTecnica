//
//  MockSchemaService.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation

struct MockSchemaService: SchemaServiceProtocol {
    init() {   }

    func getSchema() async throws -> SchemaResponse {

        try? await Task.sleep(nanoseconds: 800000000)

        return createMockSchemaResponse()
    }


    private func createMockSchemaResponse() -> SchemaResponse {
        let mockTables = [
            "Usuarios",
            "Clientes",
            "Paquetes",
            "Destinos",
            "Rutas",
            "Vehiculos",
            "Conductores",
            "Entregas",
            "Localidades",
            "CentrosDistribucion",
            "EstadosPaquete",
            "Tracking",
            "Manifiestos",
            "Productos",
            "Categorias",
            "Inventario",
            "Tarifas",
            "Descuentos",
            "Notificaciones",
            "HistorialCambios",
            "SeguimientoEnvios",
            "DocumentosEntrega",
            "Facturacion",
            "Pagos",
            "ParametrosConfiguracion",
        ]

        return SchemaResponse(tables: mockTables)
    }
}
