

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var loginData:Login
    @State var login:String=""
    @State var email:String=""
    @State var password:String=""
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            VStack{
                Text("註冊")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .frame(height: 100, alignment: .center)
                    .offset(y:50)
                TextField("使用者名稱",text: $login).textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 100, alignment: .center)
                    .offset(y:60)
                TextField("電子郵件",text: $email).textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: 300, height: 50, alignment: .center)
                    .offset(y:70)
                SecureField("密碼",text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 100, alignment: .center)
                    .offset(y:80)
                Button(action: {
                    let url = URL(string: "https://favqs.com/api/users")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Token token=\"418e36330b5982ab2ec1988d51b6574f\"", forHTTPHeaderField: "Authorization")
                    let encoder = JSONEncoder()
                    let user = CreatedUsersBody(user:CreatedUsers(login: login,email:email, password: password))
                    let data = try? encoder.encode(user)
                    request.httpBody = data
                    print("user=\(user)")
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data{
                            do{
                                let content = String(data: data, encoding: .utf8)
                                print("content=\(content)")
                                let decoder = JSONDecoder()
                                let createdUsersResponse = try decoder.decode(CreatedUsersResponse.self, from: data)
                                print(createdUsersResponse)
                                loginData.token = createdUsersResponse.Token
                                loginData.login=createdUsersResponse.login
                                
                                
                            }catch{
                                print(error)
                                showingAlert = true
                            }
                        }
                    }.resume()
                }
                , label: {
                    Text("註冊")
                }).alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("註冊錯誤"))
                })
                .frame(width: 100, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(40)
                .padding()
                .offset(y:150)
            }.offset(y: -150.0)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

