import SwiftUI

struct homeView: View {
    @StateObject var homedata = homeviewmodel()
    var body: some View {
        TabView{
            
            SignInView()
                .tabItem{
                    Image(systemName: "star.fill")
                    Text("logic")
                }
            charactersView()
                .tabItem{
                    Image(systemName: "person.3.fill")
                    Text("characters")
                }
                .environmentObject(homedata)
            
        }
    }
}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        homeView()
    }
}

