//
//  ErrorView.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


 import SwiftUI                                                                                                               
                                                                                                                               
  struct ErrorView: View {                                                                                                     
      let message: String                                                                                                      
      let retryAction: () -> Void                                                                                              
                                                                                                                               
      var body: some View {                                                                                                    
          VStack(spacing: 20) {                                                                                                
              Image(systemName: "exclamationmark.triangle")                                                                    
                  .font(.system(size: 60))                                                                                     
                  .foregroundColor(.red)                                                                                       
                                                                                                                               
              Text("Error")                                                                                                    
                  .font(.title2)                                                                                               
                  .fontWeight(.bold)                                                                                           
                                                                                                                               
              Text(message)                                                                                                    
                  .font(.body)                                                                                                 
                  .foregroundColor(.secondary)                                                                                 
                  .multilineTextAlignment(.center)                                                                             
                  .padding(.horizontal)                                                                                        
                                                                                                                               
              Button(action: retryAction) {                                                                                    
                  Text("Reintentar")                                                                                           
                      .fontWeight(.semibold)                                                                                   
                      .foregroundColor(.white)                                                                                 
                      .frame(maxWidth: .infinity)                                                                              
                      .padding()                                                                                               
                      .background(Color.blue)                                                                                  
                      .cornerRadius(10)                                                                                        
              }                                                                                                                
              .padding(.horizontal, 40)                                                                                        
          }                                                                                                                    
          .frame(maxWidth: .infinity, maxHeight: .infinity)                                                                    
      }                                                                                                                        
  }  