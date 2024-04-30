//
//  HomeSubjects.swift
//  finalProject
//
//  Created by Zak Young on 4/14/24.
//

import SwiftUI

struct HomeSubjects: View {
    @EnvironmentObject var appHandler: AppHandler

    var body: some View {
        List(appHandler.allSubjects, selection: $appHandler.selectedSubject) { subject in
            Button(action: {
                appHandler.selectedSubject = subject
                appHandler.saveSubjects()
            }) {
                HStack {
                    Circle()
                        .foregroundStyle(subject.mainColor != nil ? Color(subject.mainColor!) : Color(UIColor.clear))
                        .frame(width: 15, height: 15)
                        .padding(.leading, 10)
                    Text(subject.name)
                        .padding(.leading, 7)
                    Spacer()
                }
                .frame(height: 50)
                .background(appHandler.selectedSubject == subject ? Color(red: 0.90, green: 0.90, blue: 0.90) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .listRowInsets(EdgeInsets())
            .padding(.trailing, -5)
            .padding(.leading, -5)
            .contextMenu {
                Button("Delete") {
                    appHandler.deleteSubject(subject: subject)
                    appHandler.saveSubjects()
                }
            }
        }
        .listStyle(.automatic)
    }
}



#Preview {
    HomeSubjects()
}
