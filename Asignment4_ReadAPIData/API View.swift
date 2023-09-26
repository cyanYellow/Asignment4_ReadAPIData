//
//  API View.swift
//  Asignment4_ReadAPIData
//
//  Created by Willie Green on 9/20/23.
//

import SwiftUI

//API Variables
struct Rankings: Codable, Identifiable {
    var id: Int { return UUID().hashValue }
    var season: Int
    var week: Int
    struct Polls: Codable{
        var poll:String?
        struct Ranks: Codable{
            var rank: Int
            var school: String
            var Conference: String
            var firstPlaceVotes: Int
            var points: Int
        }
        var ranks: [Ranks]
    }
    var polls: [Polls]
}

struct APIView: View {
    @State var rankings = [Rankings]()
    
    
    // Search Peramiters
    @State var year = 2023
    let step = 1
    let yearRange = 1950...2023
    
    @State var week = 1
    let weekRange = 1...13

    
    //API Functions
    func getRanking() async -> (){
        do{
            var urlRequest = URLRequest(url: URL(string: "https://api.collegefootballdata.com/rankings?year=\(year)&week=\(week)&seasonType=regular")!)
                       urlRequest.setValue("Bearer  T8PKrQTcRbkCLful5ufGeOhXpyI3l/GJltspEsUwdTZxsNlY8DoCKDlaC0p2nE4T", forHTTPHeaderField: "Authorization")
                       let (data, _) = try await URLSession.shared.data(for: urlRequest)
            rankings = try JSONDecoder().decode([Rankings].self, from: data)
        } catch{
            print("Invalid Data")
        }
        
        
    }

    
    
    var body: some View {
        NavigationView{
            
            VStack{
                
                Text("College Football Rankings")
                    .multilineTextAlignment(.leading)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.top, .leading, .trailing])
                
                Form{
                        Section(header: Text("Year")){
                            Stepper(
                                String(year),
                                value: $year,
                                in: yearRange,
                                step: step
                            ) {_
                                in
                            }
                        }
                        Section(header: Text("Week")){
                            Stepper(
                                String(week),
                                value: $week,
                                in: weekRange,
                                step: step
                            )
                                    
                        }
//                        Button("Search"){
//
//
//                        }
                    }
                
                List(rankings){ rankings in
                    HStack(alignment: .top){
                        Image("SEC")
                
                        Text("\(rankings.ranks.rank)")
                            .font(.title)
                            .fontWeight(.medium)
                
                        VStack(alignment: .leading){
                            Text("\(rankings.ranks.school)")
                                .font(.title)
                                .fontWeight(.medium)
                
                            Text("\(rankings.ranks.firstPlaceVotes)\(rankings.ranks.points)")
                                .font(.footnote)
                                .fontWeight(.medium)
                        }
                    }
                }

                }
                .task{
                    await getRanking()
                }
              
                Spacer()
                
            }
            
        }

        
    }


#Preview {
    APIView()
}
