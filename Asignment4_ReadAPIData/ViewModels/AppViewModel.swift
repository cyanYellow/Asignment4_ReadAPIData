//
//  AppViewModel.swift
//  Asignment4_ReadAPIData
//
//  Created by Willie Green on 10/5/23.
//

import Foundation

class AppViewModel: ObservableObject {
    
    
    // Search Paramets
    @Published var year = 2023
    let step = 1
    let yearRange = 1950...2023
    
    @Published var week = 1
    let weekRange = 1...13
    
    //API Parameters
    @Published var rankings = [Ranking]()
    @Published var allRanks = [Rank]()
    
    
    
    //API Functions
    func getRanking() async -> (){
        do{
            var urlRequest = URLRequest(url: URL(string: "https://api.collegefootballdata.com/rankings?year=\(year)&week=\(week)&seasonType=regular")!)
            urlRequest.setValue("Bearer T8PKrQTcRbkCLful5ufGeOhXpyI3l/GJltspEsUwdTZxsNlY8DoCKDlaC0p2nE4T", forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            rankings = try JSONDecoder().decode([Ranking].self, from: data)
            
            if let polls = rankings.first?.polls { //1
                let coachingPolls = polls.filter({ $0.poll == "AP Top 25" }).first //2
                allRanks = coachingPolls?.ranks ?? [] //3
            }
        } catch( let error){
            print("Invalid Data \(error)")
        }
    }
    
    func loadRanking(){
        Task{
            await getRanking()
        }
    }
    
}

