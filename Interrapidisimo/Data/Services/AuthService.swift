//
//  AuthService.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


  import Foundation                                                                                                            
                                                                                                                               
  extension InterrapidisimoAPI {
      struct AuthService {                                                                                                     
          private let apiClient: ApiClient                                                                                     
                                                                                                                               
          init(apiClient: ApiClient = InterrapidisimoApiClient()) {                                                            
              self.apiClient = apiClient                                                                                       
          }                                                                                                                    
                                                                                                                                                                                
          func login() async throws -> AuthResponse {
              let headers: [String: String] = [                                                                                
                  "Usuario": "pam.meredy21",                                                                                   
                  "Identificacion": "987204545",                                                                               
                  "IdUsuario": "pam.meredy21",                                                                                 
                  "IdCentroServicio": "1295",                                                                                  
                  "NombreCentroServicio": "PTO/BOGOTA/CUND/COL/OF PRINCIPAL - CRA 30 # 7-45",                                  
                  "IdAplicativoOrigen": "9"                                                                                    
              ]                                                                                                                
                                                                                                                               
              let body: [String: String] = [                                                                                   
                  "Mac": "",                                                                                                   
                  "NomAplicacion": "Controller APP",                                                                           
                  "Password": "SW50ZXIyMDIx\n",                                                                                
                  "Path": "",                                                                                                  
                  "Usuario": "cGFtLm1lcmVkeTIx\n"                                                                              
              ]                                                                                                                
                                                                                                                               
              let bodyData = try JSONEncoder().encode(body)                                                                    
                                                                                                                               
              let endpoint = Endpoint(
                  path: Configuration.Endpoints.login,
                  method: .post,
                  headers: headers,
                  body: bodyData,
                  timeout: 60  
              )                                                                                                                
                                                                                                                               
              return try await apiClient.sendRequest(                                                                          
                  endpoint: endpoint,                                                                                          
                  responseModel: AuthResponse.self                                                                             
              )                                                                                                                
          }                                                                                                                    
      }                                                                                                                        
  }
