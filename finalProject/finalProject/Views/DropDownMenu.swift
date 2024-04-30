//
//  DropDownMenu.swift
//  finalProject
//
//  Created by Zak Young on 4/19/24.
//

import SwiftUI

struct DropDownMenu: View {
    @EnvironmentObject var appHandler : AppHandler
    @Binding var showDropdown: Bool
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        ]
    var body: some View {
        VStack{
            HStack{
                Button(action: {showDropdown = false}, label: {
                    Text("Cancel")
                })
                .padding(8)
                .foregroundStyle(Color.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                Text("Choose Background")
                    .font(.title)
                Spacer()
                Spacer()
                Spacer()
            }
            .padding()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Papers.allCases,  id: \.id){ paper in
                        HStack{
                            Button(action: {appHandler.changeBackgroundNote(background: paper)
                                appHandler.backgroundDidChange = true
                                showDropdown = false}){
                                    ZStack(alignment: .bottomLeading){
                                        Image(paper == .NONE ? "white" : paper.rawValue)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 160, height: 200, alignment: .center)
                                        HStack{
                                            Spacer()
                                            Text(paper.rawValue)
                                                .padding(.bottom,10)
                                                .foregroundStyle(Color(red: 0.3, green: 0.3, blue: 0.3))
                                            Spacer()
                                        }
                                        .frame(width: 160)
                                        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    }
                                    .border(Color(red: 0.93, green: 0.93, blue: 0.93), width: 5)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: Color(red: 0.93, green: 0.93, blue: 0.93), radius: 20)
                                }
                        }
                    }
                }
            }
        }
    }
}
