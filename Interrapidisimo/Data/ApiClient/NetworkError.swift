//
//  NetworkError.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import Foundation                                                                                                            
                                                                                                                               
  enum NetworkError: LocalizedError {                                                                                          
      case invalidURL                                                                                                          
      case noData                                                                                                              
      case decodingError(Error)                                                                                                
      case serverError(Int, String)                                                                                            
      case networkError(Error)                                                                                                 
      case unauthorized                                                                                                        
      case timeout                                                                                                             
                                                                                                                               
      var errorDescription: String? {                                                                                          
          switch self {                                                                                                        
          case .invalidURL:                                                                                                    
              return "URL inválida"                                                                                            
          case .noData:                                                                                                        
              return "No se recibieron datos del servidor"                                                                     
          case .decodingError(let error):                                                                                      
              return "Error al procesar la respuesta: \(error.localizedDescription)"                                           
          case .serverError(let code, let message):                                                                            
              return "Error del servidor (\(code)): \(message)"                                                                
          case .networkError(let error):                                                                                       
              return "Error de red: \(error.localizedDescription)"                                                             
          case .unauthorized:                                                                                                  
              return "No autorizado"                                                                                           
          case .timeout:                                                                                                       
              return "Tiempo de espera agotado"                                                                                
          }                                                                                                                    
      }                                                                                                                        
  }                    