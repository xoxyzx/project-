
import SwiftUI

struct APIResult: Codable {
    var data:APICaracterData
}
struct APICaracterData : Codable {
    var count :Int
    var results:[Character]
}
struct Character: Identifiable,Codable{
    var id : Int
    var name : String
    var description : String
    var thumbnail : [String:String]
    var urls : [[String:String]]
}
