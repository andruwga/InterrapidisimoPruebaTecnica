//
//  ApiClient.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import Foundation                                                                                                            
                                                                                                                               
  protocol ApiClient {                                                                                                         
      func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
  }         
