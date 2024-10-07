//
//  ContentView.swift
//  A25. SwiftUI Alert Dialogs
//
//  Created by Kan Tao on 2024/9/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showPopup:Bool = false
    @State private var showAlert:Bool = false
    
    @State private var isWrongPassword: Bool = false
    @State private var isTryingAgain: Bool = false
    
    var body: some View {
        NavigationStack {
            Button(action: {
                showPopup.toggle()
            }, label: {
                Text("Unlock File")
            })
            .navigationTitle("Documents")
        }
        .popView(isPreseted: $showPopup) {
            showAlert = isWrongPassword
            isWrongPassword = false
        } content: {
            CustomAlertWithTextField(show: $showPopup) { password in
                isWrongPassword = password != "password"
            }
        }
        .popView(isPreseted: $showAlert, onDismiss: {
            showPopup = isTryingAgain
            isTryingAgain = false
        }) {
            CustomAlert(show: $showAlert) {
                isTryingAgain = false
            }
        }

    }
}



struct CustomAlertWithTextField: View {
    @Binding var show: Bool
    var onUnlock:(String) -> Void
    // view properties
    @State private var password: String = ""
    var body: some View {
        VStack(spacing: 8, content: {
            Image(systemName: "person.badge.key.fill")
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 65, height: 65)
                .background {
                    Circle()
                        .fill(.blue.gradient)
                        .background {
                            Circle()
                                .fill(.background)
                                .padding(-5)
                        }
                }
            
            
            Text("Locked File")
                .fontWeight(.semibold)
            
            Text("This file has been locaked by the user, please enter the password to contine")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 5)
            
            
            SecureField("Password", text: $password)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.bar)
                }
                .padding(.vertical, 10)
            
            HStack(spacing: 10, content: {
                Button(action: {
                    show = false
                }, label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.gradient)
                        }
                })
                
                Button(action: {
                    show = false
                    onUnlock(password)
                }, label: {
                    Text("Unlock")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                        }
                })
            })
        })
        .frame(width: 250)
        .padding([.horizontal, .bottom], 25)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.background)
                .padding(.top, 25)
        }
    }
}


struct CustomAlert: View {
    @Binding var show: Bool
    var onTryAgain:() -> Void
    var body: some View {
        VStack(spacing: 8, content: {
            Image(systemName: "lock.trianglebadge.exclamationmark.fill")
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 65, height: 65)
                .background {
                    Circle()
                        .fill(.red.gradient)
                        .background {
                            Circle()
                                .fill(.background)
                                .padding(-5)
                        }
                }
            
            
            Text("Wrong Password")
                .fontWeight(.semibold)
            
            Text("This file has been locaked by the user, please enter the password")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 5)
            
            HStack(spacing: 10, content: {
                Button(action: {
                    show = false
                }, label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.gradient)
                        }
                })
                
                Button(action: {
                    show = false
                    onTryAgain()
                }, label: {
                    Text("Try Again")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                        }
                })
            })
        })
        .frame(width: 250)
        .padding([.horizontal, .bottom], 25)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.background)
                .padding(.top, 25)
        }
    }
}




#Preview {
    ContentView()
}
