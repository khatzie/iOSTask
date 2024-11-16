//
//  JSONUtils.swift
//  iOSTask
//
//  Created by Katherine Petalio on 11/14/24.
//

import Foundation

func readLocalJSONFile(forName name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            return data
        }
    } catch {
        print("error: \(error)")
    }
    return nil
}

func parse(jsonData: Data) -> ActivityResponse? {
    do {
        let decodedData = try JSONDecoder().decode(ActivityResponse.self, from: jsonData)
        return decodedData
    } catch {
        print("error: \(error)")
    }
    return nil
}
