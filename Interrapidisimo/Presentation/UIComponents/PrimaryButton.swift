//
//  PrimaryButton.swift
//  Interrapidisimo
//
//  Created by Andres on 12/24/25.
//


import SwiftUI                                                                                                               
                                                                                                                               
  struct PrimaryButton: View {                                                                                                 
      let title: String                                                                                                        
      let icon: String?                                                                                                        
      let action: () -> Void                                                                                                   
                                                                                                                               
      init(title: String, icon: String? = nil, action: @escaping () -> Void) {                                                 
          self.title = title                                                                                                   
          self.icon = icon                                                                                                     
          self.action = action                                                                                                 
      }                                                                                                                        
                                                                                                                               
      var body: some View {                                                                                                    
          Button(action: action) {                                                                                             
              HStack {                                                                                                         
                  if let icon = icon {                                                                                         
                      Image(systemName: icon)                                                                                  
                  }                                                                                                            
                  Text(title)                                                                                                  
                      .fontWeight(.semibold)                                                                                   
              }                                                                                                                
              .foregroundColor(.white)                                                                                         
              .frame(maxWidth: .infinity)                                                                                      
              .padding()                                                                                                       
              .background(Color.blue)                                                                                          
              .cornerRadius(10)                                                                                                
          }                                                                                                                    
      }                                                                                                                        
  }   