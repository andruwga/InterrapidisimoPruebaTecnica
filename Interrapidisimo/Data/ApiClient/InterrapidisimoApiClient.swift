//
//  InterrapidisimoApiClient.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//

import Foundation
              

final class InterrapidisimoApiClient: ApiClient {
  private let session: URLSession
  private let baseURL: String
																														   
  init(
	  session: URLSession = .shared,
	  baseURL: String = Configuration.baseURL
  ) {
	  self.session = session
	  self.baseURL = baseURL
  }

  @MainActor
  func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T {
	  guard let url = URL(string: baseURL + endpoint.path) else {
		  throw NetworkError.invalidURL
	  }
																														   
	
	  var request = URLRequest(url: url, timeoutInterval: endpoint.timeout)
	  request.httpMethod = endpoint.method.rawValue
	  request.httpBody = endpoint.body
																														   
	  
	  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	  request.setValue("text/json", forHTTPHeaderField: "Accept")
																														   
	  
	  endpoint.headers?.forEach { key, value in
		  request.setValue(value, forHTTPHeaderField: key)
	  }
																														   
	  
	  #if DEBUG
	  print("🌐 Request: \(endpoint.method.rawValue) \(url)")
	  if let headers = endpoint.headers {
		  print("📋 Headers: \(headers)")
	  }
	  if let body = endpoint.body,
		 let bodyString = String(data: body, encoding: .utf8) {
		  print("📦 Body: \(bodyString)")
	  }
	  #endif
																														   
	  do {
		  let (data, response) = try await session.data(for: request)
																														   
		  guard let httpResponse = response as? HTTPURLResponse else {
			  throw NetworkError.noData
		  }
																														   
		  #if DEBUG
		  print("✅ Response Code: \(httpResponse.statusCode)")
		  if let responseString = String(data: data, encoding: .utf8) {
			  print("📥 Response: \(responseString)")
		  }
		  #endif
																														   
		  
		  guard (200...299).contains(httpResponse.statusCode) else {
			  let message = String(data: data, encoding: .utf8) ?? "Error desconocido"
			  throw NetworkError.serverError(httpResponse.statusCode, message)
		  }
																														   
		  
		  let decoder = JSONDecoder()
		  decoder.dateDecodingStrategy = .iso8601

		  do {
			  #if DEBUG
			  print("🔄 Decodificando respuesta como \(T.self)...")
			  #endif
			  let decodedResponse = try decoder.decode(T.self, from: data)
			  #if DEBUG
			  print("✅ Decodificación exitosa")
			  #endif
			  return decodedResponse
		  } catch let decodingError as DecodingError {
			  #if DEBUG
			  print("❌ Error de decodificación:")
			  switch decodingError {
			  case .keyNotFound(let key, let context):
				  print("   - Campo faltante: \(key.stringValue)")
				  print("   - Ruta: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
			  case .typeMismatch(let type, let context):
				  print("   - Tipo incorrecto: esperaba \(type)")
				  print("   - Ruta: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
			  case .valueNotFound(let type, let context):
				  print("   - Valor null inesperado para tipo: \(type)")
				  print("   - Ruta: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
			  case .dataCorrupted(let context):
				  print("   - Datos corruptos: \(context.debugDescription)")
			  @unknown default:
				  print("   - Error desconocido: \(decodingError)")
			  }
			  #endif
			  throw NetworkError.decodingError(decodingError)
		  } catch {
			  #if DEBUG
			  print("❌ Error inesperado en decodificación: \(error)")
			  #endif
			  throw NetworkError.decodingError(error)
		  }
																														   
	  } catch let error as NetworkError {
		  throw error
	  } catch {
		  throw NetworkError.networkError(error)
	  }
  }
}
