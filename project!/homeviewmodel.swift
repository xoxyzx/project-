import Combine
import SwiftUI
import CryptoKit

class  homeviewmodel:  ObservableObject{
    @Published var searchQuery=""
    @Published var fetchedcharacters:[Character]?=nil
    var searchcancellable:AnyCancellable?=nil
    init(){
        searchcancellable = $searchQuery.removeDuplicates()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str == ""{
                    self.fetchedcharacters=nil
                }
                else{
                    self.searchcharacter()
                }
            })
    }
    
    func searchcharacter(){
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        let originalQuary=searchQuery.replacingOccurrences(of: " ", with: "%20")
        let url = "https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=\(originalQuary)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!){(data, _,err)in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            guard let APIData = data else{
                print("no data found")
                return
            }
            do{
                let characters = try JSONDecoder().decode(APIResult.self, from: APIData)
                DispatchQueue.main.async {
                    if self.fetchedcharacters==nil{ self.fetchedcharacters = characters.data.results
                    }
                }
            }
            catch{
                print(error.localizedDescription)
                print("2")
            }
               
        }
        .resume()
    }
    func MD5(data:String)->String{
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map{
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}
