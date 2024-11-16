//
//  ActivityViewModel.swift
//  iOSTask
//
//  Created by Katherine Petalio on 11/13/24.
//

import Foundation

class ActivityViewModel{
    
    @Published private(set) var activity: ActivityResponse?
    @Published private(set) var screens: Screens?

    func fetchActivityData() {
        guard let jsonData = readLocalJSONFile(forName: "activity-response-ios") else {
            // Handle error: JSON file not found or unable to read
            return
        }

        guard let response = parse(jsonData: jsonData) else {
            // Handle error: Parsing JSON failed
            return
        }

        self.activity = response
        self.screens = response.activity
    }

}
