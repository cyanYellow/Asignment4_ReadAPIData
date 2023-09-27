//
//  API View.swift
//  Asignment4_ReadAPIData
//
//  Created by Willie Green on 9/20/23.
//

import SwiftUI

//API Variables
struct Ranking: Codable, Identifiable {
    var id: Int { return UUID().hashValue }
    var season: Int
    var week: Int
    var polls:[Poll]
}

struct Poll: Codable {
    var poll: String = "Coaches Poll"
    var ranks: [Rank]
}

struct Rank: Codable {
    var rank: Int
    var school: String
    var conference: String
    var firstPlaceVotes: Int
    var points: Int
    
}

struct APIView: View {
    
    @State var rankings = [Ranking]()
    
    @State var allRanks = [Rank]()
    
        
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
                       urlRequest.setValue("Bearer T8PKrQTcRbkCLful5ufGeOhXpyI3l/GJltspEsUwdTZxsNlY8DoCKDlaC0p2nE4T", forHTTPHeaderField: "Authorization")
                       let (data, _) = try await URLSession.shared.data(for: urlRequest)
            rankings = try JSONDecoder().decode([Ranking].self, from: data)
        } catch( let error){
            print("Invalid Data \(error)")
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
                    Button(action: {
                        Task{
                            await getRanking()
                        }
                        
                        }, label: {
                            
                            HStack{
                                Spacer()
                                Text("Search")
                                Image(systemName: "magnifyingglass")
                                Spacer()
                            }
                            
                        })
                    }
                
                if let polls = rankings.first?.polls { //1
                                let coachingPolls = polls.filter({ $0.poll == "Coaches Poll" }).first //2
                                allRanks = coachingPolls?.ranks ?? [] //3
                }
                
                List(rankings){ ranking in
                    VStack {
                        //Image("SEC")
                
                        Text("team")
                            .font(.title)
                            .fontWeight(.medium)
                
//                        VStack(alignment: .leading){
//                            Text("\(ranking.polls.ranks.first?.school)")
//                                .font(.title)
//                                .fontWeight(.medium)
//                
//                            Text("\(ranking.polls.ranks.first?.firstPlaceVotes)")
//                                .font(.footnote)
//                                .fontWeight(.medium)
//                        }
                        Spacer()
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
