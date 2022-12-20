import SwiftUI
import UIKit
struct SignInView: View {
    @EnvironmentObject var loginData:Login
    @State var email:String=""
    @State var password:String=""
    @State private var showingAlert = false
    @State private var activeAlert : ActiveAlert = .login
    var body: some View {
        NavigationView{
            VStack{
                Text("漫威人")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(height: 100, alignment: .center)
                    .offset(x:0,y:50)
                TextField("電子郵件",text: $email).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 300, height: 50, alignment: .center)
                    .offset(x:0,y:100)
                SecureField("密碼",text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 100, alignment: .center)
                    .offset(x:0,y:70)
                Button(action: {
                    let url = URL(string: "https://favqs.com/api/session")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Token token=\"418e36330b5982ab2ec1988d51b6574f\"", forHTTPHeaderField: "Authorization")
                    let encoder = JSONEncoder()
                    let user = CreatedSessionBody(user:SessionUser(login: email, password: password))
                    let data = try? encoder.encode(user)
                    request.httpBody = data
                    print("user=\(user)")
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data{
                            do{
                                let content = String(data: data, encoding: .utf8)
                                print("content=\(content)")
                                let decoder = JSONDecoder()
                                let createSessionResponse = try decoder.decode(CreateSessionResponse.self, from: data)
                                
                                print(createSessionResponse)
                                loginData.token = createSessionResponse.Token
                                loginData.login=createSessionResponse.login
                                
                            }catch{
                              
                                print(error)
                                showingAlert = true
                                activeAlert = .login
                            }
                        }else if let error = error{
                          
                            showingAlert = true
                            activeAlert = .net
                        }
                    }.resume()
                }, label: {
                    Text("登入")
                }).alert(isPresented: $showingAlert, content: {
                    switch activeAlert{
                    case .login:
                        return                        Alert(title:  Text("帳號或密碼錯誤"))
                    case .net:
                        return Alert(title: Text("網路錯誤"))
                    }
                })
               
                .frame(width: 100, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(40)
                .padding()
                .offset(y:150)
                NavigationLink(
                    destination: SignUpView(),
                    label: {
                        Text("註冊")
                            .offset(x:120,y:-50)
                    })
                
            }.offset(y: -150.0)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

