//
//  API View.swift
//  Asignment4_ReadAPIData
//
//  Created by Willie Green on 9/20/23.
//

import SwiftUI

//API Variables
struct Rankings: Codable, Identifiable{
    var id: Int { return UUID().hashValue }
    var rank: Int
    var school: String
    var conference: String
    var firstPlaceVotes: Int
    var points: Int
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
            let url = URL(string: "https://api.collegefootballdata.com/rankings?year=<\(year)>&week=<\(week)>&seasonType=regular")!
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data)
            rankings = try JSONDecoder().decode([Rankings].self, from:data)
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
                        Button("Search"){
                            
                        }
                    }
                
                List(rankings){ ranking in
                    HStack(alignment: .top){
                        //Image("SEC")

                        Text("\(rankings.rank)")
                            .font(.title)
                            .fontWeight(.medium)

                        VStack(alignment: .leading){
                            Text("\(rankings.school)")
                                .font(.title)
                                .fontWeight(.medium)

                            Text("\(ranking.firstPlaceVotes)     \(rankings.points)")
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
