//
//  TableViewController.swift
//  shopify_intern_challenge
//
//  Created by user148961 on 1/14/19.
//  Copyright © 2019 user148961. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {
    
    var collectionTitleClicked = ""
    var collectionImageClicked = ""
    var html:String = ""
    var titles:[String] = []
    var ids:[Int] = []
    var collectionImageUrl:[String] = []
    var allHtmls:[String] = []
    var Id:Int = 0
    var wholeObject:[JSON] = []
    var selectedObject:JSON? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        let URL = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        
        // ALAMOFIRE function: get the data from the website
        Alamofire.request(URL, method: .get, parameters: nil).responseJSON {
            (response) in
            
            // -- put your code below this line
            
            if (response.result.isSuccess) {
                print("awesome, i got a response from the website!")
                
                do {
                    let json = try JSON(data:response.data!)
                    //print(json["custom_collections"])
                    let customCollection = json["custom_collections"]
                    for (index, object) in customCollection{
                        let title = object["title"].stringValue
                        let id = object["id"]
                        self.titles.append(title)
                        self.ids.append(id.intValue)
                        self.allHtmls.append(object["body_html"].stringValue)
                        self.wholeObject.append(object)
                        
                        let imageObject = object["image"]
                        
                        for (key, value) in imageObject {
                            if(key == "src"){
                                self.collectionImageUrl.append(value.stringValue)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
                catch {
                    print ("Error while parsing JSON response")
                }
                
            }
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.detailTextLabel?.text = "ID:" + String(ids[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Id = ids[indexPath.row]
        collectionTitleClicked = titles[indexPath.row]
        collectionImageClicked = collectionImageUrl[indexPath.row]
        html = allHtmls[indexPath.row]
        selectedObject = wholeObject[indexPath.row]
        performSegue(withIdentifier: "segueA", sender: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsPage = segue.destination as! DetailsTableViewController
        detailsPage.collectionID = Id
        detailsPage.collectionTitle = collectionTitleClicked
        detailsPage.collectionImageUrl = collectionImageClicked
        detailsPage.bodyHtml = selectedObject!
    }
    

}
