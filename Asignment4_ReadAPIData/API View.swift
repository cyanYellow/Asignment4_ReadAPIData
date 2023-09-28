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

struct Rank: Codable, Identifiable {
    var id: Int { return UUID().hashValue }
    var rank: Int
    var school: String
    var conference: String
    var firstPlaceVotes: Int
    var points: Int
    
}

struct APIView: View {
    
    //API Parameters
    @State var rankings = [Ranking]()
    @State var allRanks = [Rank]()
    
        
    // Search Paramets
    @State var year = 2023
    let step = 1
    let yearRange = 1950...2023
    
    @State var week = 1
    let weekRange = 1...13
    
    //Scroll View Lables
    @Namespace var topID
    @Namespace var SeachID
    
    @State var visibleItems: Set <Int> = Set()

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
        if let polls = rankings.first?.polls { //1
            let coachingPolls = polls.filter({ $0.poll == "AP Top 25" }).first //2
            allRanks = coachingPolls?.ranks ?? [] //3
        }
    }
    
    var body: some View {
        NavigationView{
            
            ScrollViewReader{ proxy in
                ZStack(alignment: .bottomTrailing){
                    
                    VStack{
                        
                        Form{
                            
                            Section(header: Text("Year")){
                                Stepper(
                                    String(year),
                                    value: $year,
                                    in: yearRange,
                                    step: step
                                )
                            }
                            .id(topID)
                            Section(header: Text("Week")){
                                Stepper(
                                    String(week),
                                    value: $week,
                                    in: weekRange,
                                    step: step
                                )
                            }
                            
                            Section{
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
                            .id(SeachID)
                            
                            Spacer()
                            
                            
                            List(allRanks){ allRank in
                                VStack (alignment: .leading){
                                    HStack(alignment: .top){
                                        
                                        Text("\(allRank.rank).")
                                            .font(.title)
                                        
                                        VStack(alignment: .leading){
                                            
                                            Text("\(allRank.school)")
                                                .font(.title)
                                            
                                            HStack{
                                                Text("First Place Votes: \(allRank.firstPlaceVotes) ")
                                                    .font(.footnote)
                                                
                                                Text("Points: \(allRank.points)")
                                                    .font(.footnote)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                        
                        //back to top button
                        Button {
                            proxy.scrollTo(topID)
                            
                        }label: {
                                Image(systemName: "arrow.uturn.up")
                            .padding(15)
                            .background(.black.opacity(0.75) )
                            .foregroundColor(.white)
                            
                        }
                        .frame(alignment: .bottom)
                        .cornerRadius(10.0)
                        .padding(20)
                    
                }
            }

                }
                .task{
                    await getRanking()
                }
                
            }
            
        }

        



#Preview {
    APIView()
}
