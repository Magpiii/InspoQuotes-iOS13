//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

//Must import StoreKit for in-app purchases:
import StoreKit

class QuoteTableViewController: UITableViewController {
    //ProductID from Apple:
    
    let productID = "[Product ID from Apple]"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets the tableView's delegate as self:
        tableView.delegate = self
        
        //Sets the PaymentQueue delegate method to self (NOTE: this is required):
        SKPaymentQueue.default().add(self)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        /*Returns the amount of rows equal to the amount of quotes in the quotesToShow array (+1 for the prompt to do in-app purchase):
        */
        return quotesToShow.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        //If the current indexPath is less than the amount of quotes...
        if (indexPath.row < quotesToShow.count){
            //...allows the textLabel to use as many lines as it needs to show the quote:
            cell.textLabel?.numberOfLines = 0
            
            //Sets the cell's textLabel to the appropriate quote for the index of the array:
            cell.textLabel?.text = quotesToShow[indexPath.row]
        //Otherwise...
        } else {
            //Sets the text label of the new cell to the following string:
            cell.textLabel?.text = "Tap here to get more quotes!"
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            
            /*Puts a chevron at the right side of the cell which tells the user that the cell will take them somewhere if they tap on it:
            */
            cell.accessoryType = .disclosureIndicator
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
    
    //MARK: - TableView Delegate Methods:
    //Method for when cell is selected:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If the current index of the array equals the end of the quotesToShow array...
        if (indexPath.row == quotesToShow.count){
            //Checks to make sure the cell I'm working with is actually the right cell:
            print("Buy quotes tapped.")
            
            buyPremiumQuotes()
        }
        
        /*Deselects the row after tapping so that it doesn't stay "tapped" (UI looks better that way):
        */
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - In-app Purchase Methods:
    func buyPremiumQuotes() {
        /*Condition check to make sure the user has the permissions to actually make purchases (i.e. doesn't have parental controls):
        */
        if SKPaymentQueue.canMakePayments() == true {
            //Initializes a new payment request:
            let paymentRequest = SKMutablePayment()
            
            //Specifies the product identifier for the purchase as the productID from Apple:
            paymentRequest.productIdentifier = productID
            
            /*Adds the above payment request to the PaymentQueue (works kind of like DispatchQueue):
            */
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            print("Error code 1: user is unable to make payments.")
        }
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
    }
}

//MARK: - Transaction Observer:
extension QuoteTableViewController: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        /*Transactions are processed as an array, so one must loop through the transactions to see if the user actually paid:
        */
        for transaction in transactions {
            //If the user paid for it and the transaction went through...
            if (transaction.transactionState == .purchased){
                print("Transaction succeeded.")
                
                /*Indicates to the PaymentQueue that the transaction is complete for the current transaction:
                */
                SKPaymentQueue.default().finishTransaction(transaction)
            /*Else if the user's transaction failed (i.e. they hit cancel or the card got declined)...
            */
            } else if (transaction.transactionState == .failed){
                print("Error code 2: transaction failed.")
                
                /*Must indicate that transaction is finished in both cases, whether it succeeds or not:
                */
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
}
