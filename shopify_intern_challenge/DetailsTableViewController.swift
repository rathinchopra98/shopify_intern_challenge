//
//  DetailsTableViewController.swift
//  shopify_intern_challenge
//
//  Created by user148961 on 1/14/19.
//  Copyright © 2019 user148961. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailsTableViewController: UITableViewController {
    
    var collectionID:Int = 0
    var collectionTitle:String = ""
    var collectionImageUrl:String = ""
    var bodyHtml:JSON? = nil
    var productIds:[Int] = []
    var productTitles:[String] = []
    var quantity:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        //self.tableView.contentInset = UIEdgeInsets(top: 10,left: 0,bottom: 0,right: 0)
        
        let URL = "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collectionID)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        
        // ALAMOFIRE function: get the data from the website
        Alamofire.request(URL, method: .get, parameters: nil).responseJSON {
            (response) in
            
            // -- put your code below this line
            
            if (response.result.isSuccess) {
                print("awesome, i got a response from the website!")
                
                do {
                    let json = try JSON(data:response.data!)
                    //print(json["custom_collections"])
                    
                    for (index, object) in json["collects"] {
                        let productsId = object["product_id"].stringValue
                        self.productIds.append(Int(productsId)!)
                        
                        let URL1 = "https://shopicruit.myshopify.com/admin/products.json?ids=\(productsId)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
                        
                        // ALAMOFIRE function: get the data from the website
                        Alamofire.request(URL1, method: .get, parameters: nil).responseJSON {
                            (response) in
                            
                            // -- put your code below this line
                            
                            if (response.result.isSuccess) {
                                
                                do {
                                    let json = try JSON(data:response.data!)
                                    let products = json["products"]
                                    for (index, object) in products {
                                        let title = object["title"].stringValue
                                        self.productTitles.append(title)
                                        
                                        let variants = object["variants"]
                                        var totalQuantity = 0
                                        for(index, object) in variants{
                                            let productQuantity = object["inventory_quantity"].stringValue
                                            totalQuantity = Int(productQuantity)! + totalQuantity
                                            
                                        }
                                        self.quantity.append(Int(totalQuantity))
                                    }
                                    
                                }
                                catch {
                                    print ("Error while parsing JSON response")
                                }
                                self.tableView.reloadData()
                            }
                            
                        }
 
                    }
                    
                }
                catch {
                    print ("Error while parsing JSON response")
                }
                
            }
            
        }
        /*
        var URL1 = "https://shopicruit.myshopify.com/admin/products.json?ids="
        for i in productIds{
            URL1 = URL1 + String(i) + ","
        }
        URL1 = URL1 + "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        print(URL1)
        */
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productTitles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell

        let url = NSURL(string: collectionImageUrl)
        let data = NSData(contentsOf : url as! URL)
        let image = UIImage(data : data! as Data)
        image!.size

        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
        if(indexPath == indexPathForFirstRow){
            cell.productImageView.image = image
            cell.title.text = collectionTitle
            cell.collectionTitle.text = "Flexible detail card"
            cell.quantity.text = ""
            cell.textView.text = "\(bodyHtml!)"
        }else{
            cell.title.text = productTitles[indexPath.row]
            cell.quantity.text = "Total Quantity: " + String(quantity[indexPath.row])
            cell.collectionTitle.text = collectionTitle
            cell.productImageView.image = image
            cell.textView.text = ""
        }
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
