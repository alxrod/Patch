//
//  PatchApi.swift
//  MobilePatch
//
//  Created by Antonio Rodriguez on 7/2/16.
//  Copyright © 2016 Antonio Rodriguez. All rights reserved.
//

import Foundation
import Alamofire




enum DevCreds  {
    static let devApiEndpoint = "http://localhost:5000/api/"
    static let username = "alex"
    static let password = "andrew2005"
    
}

/* pass in two blocks- will call back the success block with the token as a string 
 * if we autheticate and will call the failure block if it doesn't work to login 
 * the caller is responsible for all of the UI showing what is happening
 * and for storing the token for subsequent calls to the API
 */

func getToken(username: String, password: String,
              success: (String->Void), failed: (Void->Void)) -> Void  {
    let endpoint = DevCreds.devApiEndpoint + "gettoken"
    var token:String = ""
    Alamofire.request(.POST, endpoint,
                      parameters: ["username": username, "password": password] )
        .responseJSON { resp in switch resp.result {
            case .Success(let resp):
                token = resp as! String
                if token != "failure" {
                    success(token)
                } else {
                    failed()
            }
            
            case .Failure(let error):
                NSLog("%s" , error)
                failed()
            }
    }
    

}

func getTasks(token: String, success: ([[String:AnyObject]]->Void)) -> Void {
    let endpoint = DevCreds.devApiEndpoint + "tasks"
    var tasks: [[String:AnyObject]] = []
    Alamofire.request(.POST, endpoint, parameters: ["api_key": token,])
        .responseJSON { resp in switch resp.result {
        case .Success(let resp):
            print("made requ est")
            print(resp)
            tasks = resp as! [[String:AnyObject]]
            
            if tasks.isEmpty {
                print ("empty")
            } else {
               success(tasks)
        }
            
        case .Failure(let error):
            NSLog("%s", error)
            print ("failed")
        }
    }
}

func completeTaskAPI(token: String, task: [String:AnyObject], success: ([String:AnyObject]->Void)) {
    let endpoint = DevCreds.devApiEndpoint + "complete-task"
    let param_id = task["task_id"] as! Int
    print ("Token: \(token) Endpoint: \(endpoint) Params_id \(param_id)")
    Alamofire.request(.POST, endpoint, parameters: ["api_key": token, "id": param_id])
        .responseJSON { resp in switch resp.result {
            case .Success(let resp):
                let respString = resp as! String
                if respString == "completed"{
                    success(task)
                } else {
                    print(resp)
                }
            case .Failure(let error):
                NSLog("%s", error)
                print("failed")
                print(error)
            
        }
    }
    
}

func createTaskAPI(token: String, taskDate: String, taskDescript: String, ParentProjectId: Int, success: ([String:AnyObject]->Void)) {
    print("hello????1")
    print(taskDate)
    let endpoint = DevCreds.devApiEndpoint + "create-task"
    Alamofire.request(.POST, endpoint, parameters: ["api_key": token, "descript": taskDescript, "date": taskDate, "project_id": ParentProjectId])
        .responseJSON { resp in switch resp.result {
            case .Success(let resp):
                print("hello????2")
                if String(resp) != "failure" {
                    print("Cleared with: \(resp)")
                    success(resp as! [String:AnyObject])
                } else {
                    print("hello????")
                    print(resp)
                }
            case .Failure(let error):
                print(error)
                NSLog("%s", error)
                    
            }
            
        }
}


//inout means that the task dict shouldn't be made constant when accepted as argument
func editTaskAPI(token: String, inout task: [String:AnyObject], success: ([String:AnyObject]->Void)) {
    let endpoint = DevCreds.devApiEndpoint + "edit-task"
    task["api_key"] =  token
    Alamofire.request(.POST, endpoint, parameters: task, encoding: .JSON)
        .responseJSON { resp in switch resp.result {
            case .Success(let resp):
                success(task)
            
            case .Failure(let error):
                print(error)
                NSLog("%s", error)
        }
    }
    
}

func deleteTaskAPI(token: String, task_id: Int, success: (Void->Void)) {
    print(task_id)
    let endpoint = DevCreds.devApiEndpoint + "delete-task"
    Alamofire.request(.POST, endpoint, parameters: ["api_key": token, "id": task_id])
        .responseJSON { resp in switch resp.result {
        case .Success(let resp):
            print("resp: \(resp)")
            success()
            
        case .Failure(let error):
            print(error)
            NSLog("%s", error)
            
        }
    }
        
            
}




