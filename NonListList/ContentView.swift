//
//  ContentView.swift
//  NonListList
//
//  Created by Eric Bright on 6/17/21.
//

import SwiftUI

enum SectionCategory: String, CaseIterable {
    case firstSection = "Section 1 Name Here"
    case secondSection = "Section 2 Name Here"
    case thirdSection = "Section 3 Name Here"
    // etc... Continue for as many sections as you have.
}

extension CaseIterable where Self: Equatable {
    // This extension allows you to get the index value of any enumerated item such as our categories.
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}

// My list items are made up of several parts, and I needed them codable to load from JSON.
// You may not need the list items to be identifiable (the UUID var), but I'm not sure.
struct ListEntry: Codable, Identifiable {
    // Needs id to be identifiable and UUID is a Universal Unique Identifier.
    // The UUID is produced by Swift when you initialize the item.
    var id: UUID
    var section: String
    var item: String
    // Any other properties that you want your list items to have.
    
    init(section: String, item: String) {
        self.id = UUID()
        self.section = section
        self.item = item
    }
}

struct ContentView: View {
    // Inside the main struct of your view but before the actual view, you'll need a boolean to say whether each section is on or off.
    // I had three generic sections defined, so three booleans.  False means collapsed and true means expanded.
    @State var sectionExpanded: [Bool] = [false, false, false]
    let items: [ListEntry] = [
        ListEntry(section: "Section 1 Name Here", item: "First item in section"),
        ListEntry(section: "Section 1 Name Here", item: "Second item in section"),
        ListEntry(section: "Section 1 Name Here", item: "Third item in section"),
        ListEntry(section: "Section 2 Name Here", item: "First item in section"),
        ListEntry(section: "Section 2 Name Here", item: "Second item in section"),
        ListEntry(section: "Section 2 Name Here", item: "Third item in section"),
        ListEntry(section: "Section 3 Name Here", item: "First item in section"),
        ListEntry(section: "Section 3 Name Here", item: "Second item in section"),
        ListEntry(section: "Section 3 Name Here", item: "Third item in section"),
        ListEntry(section: "Section 1 Name Here", item: "Notice it can be out of order"),
        ListEntry(section: "Section 3 Name Here", item: "But it still works")
    ]
    var body: some View {
        // Instead of List, use ScrollView so you don't get the forced style and colors of List.
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            VStack {
                Text("Title of View Here")
                    .font(.title)
                ScrollView {
                    ForEach(SectionCategory.allCases, id: \.rawValue) { category in
                        Section(header:
                                    VStack {
                                        Spacer()
                                            .frame(height: 5)
                                        Button(action: {
                                            // Click the button to expand/collapse.
                                            sectionExpanded[category.index ?? 0].toggle()
                                        }, label: {
                                            HStack {
                                                Text(category.rawValue)
                                                    .foregroundColor(.black) // Text color if you don't want button blue.
                                                Spacer()
                                                // If it's expanded, show the up arrow.  Otherwise, show the down arrow.
                                                if sectionExpanded[category.index ?? 0] {
                                                    Image(systemName: "chevron.up")
                                                        .foregroundColor(.black)
                                                } else {
                                                    Image(systemName: "chevron.down")
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        })
                                        .frame(height: 30)
                                        .background(Color.red)
                                        // Spacers instead of dividers
                                        Spacer()
                                            .frame(height: 5)
                                    })
                        {
                            // Check to see if the section is expanded first
                            if sectionExpanded[category.index ?? 0] {
                                // If it is expanded, get the individual items from the [ListItem] called items.
                                // Also, filter the items by section.
                                ForEach(items.filter { $0.section == category.rawValue }) { entry in
                                    HStack {
                                        Image(systemName: "diamond")
                                        Text(entry.item)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
       }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
