//
//  CustomCellData.swift
//  test
//
//  Created by student-xCode on 7/1/19.
//  Copyright © 2019 student-xCode. All rights reserved.
//

import Foundation

typealias Project = (id: Int, name: String)
typealias Tracker = (id: Int, name: String)
typealias Status = (id: Int, name: String)
typealias Priority = (id: Int, name: String)
typealias Author = (id: Int, name: String)
typealias AssignedTo = (id: Int, name: String)

struct IssueData: Equatable {
   
    var id: Int
    
    var project: Project
    var tracker: Tracker
    var status: Status
    var priority: Priority
    var author: Author
    var assignedTo: AssignedTo
    
    var title: String
    var description: String
    var startDate: Date
    var dueDate: Date
    var estimatedHours: Int
    var createdOn: Date
    var updatedOn: Date
    
    var progress: Int {
        didSet {
            if progress > 100 {
                progress = 100
                print("progress must be less or equal 100")
            } else if progress < 0 {
                progress = 0
                print("progress must be greater or equal 0")                
            }
        }
    }
    
    init?(from json: [String: Any]){
        guard let id = json["id"] as? Int,
            
        let project = json["project"] as? [String: Any],
        let projectId = project["id"] as? Int,
        let projectName = project["name"] as? String,
        
        let tracker = json["tracker"] as? [String: Any],
        let trackerId = tracker["id"] as? Int,
        let trackerName = tracker["name"] as? String,
        
        let status = json["status"] as? [String: Any],
        let statusId = status["id"] as? Int,
        let statusName = status["name"] as? String,
        
        let priority = json["priority"] as? [String: Any],
        let priorityId = priority["id"] as? Int,
        let priorityName = priority["name"] as? String,
        
        let author = json["author"] as? [String: Any],
        let authorId = author["id"] as? Int,
        let authorName = author["name"] as? String,
        
        let assignedTo = json["assigned_to"] as? [String: Any],
        let assignedToId = assignedTo["id"] as? Int,
        let assignedToName = assignedTo["name"] as? String,
        
        let title = json["subject"] as? String,
        let description = json["description"] as? String,
        let progress = json["done_ratio"] as? Int,
        let estimatedHours = json["estimated_hours"] as? Int,
        let startDate = (json["start_date"] as? String)?.toDate(format: "yyyy-MM-dd"),
        let dueDate = (json["due_date"] as? String)?.toDate(format: "yyyy-MM-dd"),
        let createdOn = (json["created_on"] as? String)?.toDate(format: "yyyy-MM-dd'T'HH:mm:ss'Z'"),
        let updatedOn = (json["updated_on"] as? String)?.toDate(format: "yyyy-MM-dd'T'HH:mm:ss'Z'")

        else { return nil }
    
        self.id = id
        self.project = Project(id: projectId, name: projectName)
        self.tracker = Tracker(id: trackerId, name: trackerName)
        self.status = Status(id: statusId, name: statusName)
        self.priority = Priority(id: priorityId, name: priorityName)
        self.author = Author(id: authorId, name: authorName)
        self.assignedTo = AssignedTo(id: assignedToId, name: assignedToName)
        self.title = title
        self.description = description
        self.progress = progress
        self.estimatedHours = estimatedHours
        self.startDate = startDate
        self.dueDate = dueDate
        self.createdOn = createdOn
        self.updatedOn = updatedOn
    }
    
    func toJson()->[String: Any]{
        var json = [String: Any]()
        json["subject"] = title
        json["description"] = description
        return ["issue" : json]
    }
    
    static func == (lhs: IssueData, rhs: IssueData) -> Bool {
        return lhs.id == rhs.id
            && lhs.assignedTo.id == rhs.assignedTo.id
            && lhs.assignedTo.name == rhs.assignedTo.name
            && lhs.author.id == rhs.author.id
            && lhs.createdOn == rhs.createdOn
            && lhs.description == rhs.description
            && lhs.dueDate == rhs.dueDate
            && lhs.estimatedHours == rhs.estimatedHours
            && lhs.priority.id == rhs.priority.id
            && lhs.priority.name == rhs.priority.name
            && lhs.progress == rhs.progress
            && lhs.project.id == rhs.project.id
            && lhs.project.name == rhs.project.name
            && lhs.startDate == rhs.startDate
            && lhs.status.id == rhs.status.id
            && lhs.status.name == rhs.status.name
            && lhs.title == rhs.title
            && lhs.tracker.id == rhs.tracker.id
            && lhs.tracker.name == lhs.tracker.name
            && lhs.updatedOn == rhs.updatedOn
    }
}
