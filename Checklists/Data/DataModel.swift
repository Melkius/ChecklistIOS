//
//  DataModel.swift
//  Checklists
//
//  Created by MALOSSE Maxime on 14/03/2019.
//  Copyright © 2019 MALOSSE Maxime. All rights reserved.
//

import UIKit

class DataModel {
    
    static let shared = DataModel()
    
    private var documentDirectory: URL {
        get{
            return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
        }
    }
    
    private var dataFileUrl: URL {
        get {
            return documentDirectory.appendingPathComponent("allCkecklists").appendingPathExtension("json")
        }
    }
    
    var listOfChecklists = [Checklist]()
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveChecklists),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
    }
    
    @objc func saveChecklists() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(listOfChecklists)
            try jsonData.write(to: dataFileUrl)
        }
        catch {
            print("error")
        }
    }
    
    func loadChecklists() -> [Checklist]{
        do {
            let jsonDecoder = JSONDecoder()
            let data = try Data.init(contentsOf: dataFileUrl)
            listOfChecklists = try jsonDecoder.decode([Checklist].self, from: data)
            for item in listOfChecklists {
                print(item.name)
            }
        }
        catch {
            print("error")
        }
        return listOfChecklists
    }
    
    
}

