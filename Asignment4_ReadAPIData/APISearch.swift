//
//  API View.swift
//  Asignment4_ReadAPIData
//
//  Created by Willie Green on 9/20/23.
//

import SwiftUI


struct APISearch: View {
    
    //API Parameters
    @State var rankings = [Ranking]()
    @State var allRanks = [Rank]()
    @State var searchedTeam = []
    
        
    // Search Paramets
    @State var teamName = String()
    
    @State var year = 2023
    let step = 1
    let yearRange = 1950...2023
    
    @State var week = 1
    let weekRange = 1...13
    
    enum PollType: String, CaseIterable, Identifiable {
        case apTop25, coachesPoll, fCSCoachesPoll, aFCADivisionIICoachesPoll
        var id: Self { self }
    }


    @State private var pollType: PollType = .apTop25
    
    @State var pollSelect = String()
    
    //Search Function
    
    func setPoll() {
        if pollType == .apTop25 {
           pollSelect = "AP Top 25"
        }
        if pollType == .coachesPoll {
           pollSelect = "Coaches Poll"
        }
        if pollType == .fCSCoachesPoll {
           pollSelect = "FCS Coaches Poll"
        }
        if pollType == .aFCADivisionIICoachesPoll {
           pollSelect = "AFCA Division II Coaches Poll"
        }
    }

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
            let pollSection = polls.filter({ $0.poll == "\(pollSelect)" }).first //2
            allRanks = pollSection?.ranks ?? [] //3
        }
        if let searchResult = allRanks.first { //1
            let shownTeam = allRanks.filter({ $0.school == "\(teamName)" }).first //2
            searchedTeam = [shownTeam] //3
        }
    }
    
    var body: some View {
        NavigationView{
            
            ScrollViewReader{ proxy in
                ZStack(alignment: .bottomTrailing){
                    
                    VStack{
                        
                        Form{
                            
                            Section(header: Text("School Name")){
                                TextField(text: $teamName, prompt: Text("Required")) {
                                        Text("School Name")
                                    }
                            }
                            
                            Section(header: Text("Year")){
                                Stepper(
                                    String(year),
                                    value: $year,
                                    in: yearRange,
                                    step: step
                                )
                            }
                            
                            Section(header: Text("Week")){
                                Stepper(
                                    String(week),
                                    value: $week,
                                    in: weekRange,
                                    step: step
                                )
                            }
                            
                            Section(header: Text("Week")){
                                Picker("Poll", selection: $pollType) {
                                    Text("AP Top 25").tag(PollType.apTop25)
                                    Text("CoachesPoll").tag(PollType.coachesPoll)
                                    Text("FCS Coaches Poll").tag(PollType.fCSCoachesPoll)
                                    Text("AFCA Division II Coaches Poll").tag(PollType.aFCADivisionIICoachesPoll)
                                    }
                            }
                            
                            Section{
                                Button(action: {
                                    setPoll()
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
                            
                            Section{
                            NavigationStack{
                                
                                List(searchedTeam){ searched in
                                    VStack (alignment: .leading){
                                        HStack(alignment: .top){
                                            
                                            Text("\(searchedTeam.rank).")
                                                .font(.title)
                                            
                                            VStack(alignment: .leading){
                                                
                                                Text("\(searchedTeam.school)")
                                                    .font(.title)
                                                
                                                HStack{
                                                    Text("First Place Votes: \(searchedTeam.firstPlaceVotes) ")
                                                        .font(.footnote)
                                                    
                                                    Text("Points: \(searchedTeam.points)")
                                                        .font(.footnote)
                                                }
                                            }
                                            }
                                        }
                                    }
                                }
                            }
                            .navigationTitle("Team Search")
                        }
                    }
                }
            }
        }
            .task{
                await getRanking()
                }
                
    }
            
}

#Preview {
    APISearch()
}
