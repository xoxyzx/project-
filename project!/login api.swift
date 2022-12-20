import Foundation
class  Login:ObservableObject {
    @Published var token :String = ""
    @Published var login :String = ""
}


struct  CreatedSessionBody:Encodable {
    public let user:SessionUser
}

struct SessionUser :Encodable{
    public let login: String
    public let password: String
}

struct  CreateSessionResponse:Decodable {
    public let Token: String
    public let login: String
    public let email:String
    
    enum CodingKeys:String,CodingKey{
        case Token = "User-Token"
        case login
        case email
    }
}

struct  CreatedUsersBody:Encodable {
    public let user:CreatedUsers
}

struct CreatedUsers:Encodable {
    let login: String
    let email: String
    let password: String
}

struct  CreatedUsersResponse:Decodable {
    let Token: String
    let login: String
    enum CodingKeys:String,CodingKey{
        case Token = "User-Token"
        case login
    }
}
enum ActiveAlert {
    case net, login
}
