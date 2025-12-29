//
//  EmptyStateView.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import SwiftUI                                                                                                               
                                                                                                                               
  struct EmptyStateView: View {                                                                                                
      let message: String                                                                                                      
      let icon: String                                                                                                         
                                                                                                                               
      init(message: String, icon: String = "tray") {                                                                           
          self.message = message                                                                                               
          self.icon = icon                                                                                                     
      }                                                                                                                        
                                                                                                                               
      var body: some View {                                                                                                    
          VStack(spacing: 16) {                                                                                                
              Image(systemName: icon)                                                                                          
                  .font(.system(size: 60))                                                                                     
                  .foregroundColor(.gray)                                                                                      
                                                                                                                               
              Text(message)                                                                                                    
                  .font(.headline)                                                                                             
                  .foregroundColor(.secondary)                                                                                 
                  .multilineTextAlignment(.center)                                                                             
                  .padding(.horizontal)                                                                                        
          }                                                                                                                    
          .frame(maxWidth: .infinity, maxHeight: .infinity)                                                                    
      }                                                                                                                        
  }   