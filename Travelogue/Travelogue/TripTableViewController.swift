//
//  TripTableViewController.swift
//  Travelogue
//
//  Created by Megan Wilson on 11/18/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//

import UIKit
import CoreData


class TripTableViewController: UITableViewController {
    var trips : [Trip]?
    
    @IBOutlet var tripTableView: UITableView!
    @IBOutlet weak var addTrip: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tripTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
              return
          }
          let managedContext = appDelegate.persistentContainer.viewContext
          let fetchRequest : NSFetchRequest<Trip> = Trip.fetchRequest()
          do{
              trips = try managedContext.fetch(fetchRequest)
              tripTableView.reloadData()
          }catch{
              print("Could not fetch categories")
          }
          //print(trips?.count ?? 0)
      }
      
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return trips?.count ?? 0
      }
      
      override func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tripTableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
          let trip = trips?[indexPath.row]
          cell.textLabel?.text = trip?.tripTitle
          return cell
      }
    
    
    @IBAction func addTripButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add Trip", message: "Enter the name of the trip", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
                    (alertAction)->Void in
                    if let textField = alert.textFields?[0], let name = textField.text{
                        let tripName = name.trimmingCharacters(in: .whitespaces)
                        if(tripName == ""){
                            print("Trip not created")
                            return
                        }
                        //create actual trip here, add it to array and core data
                        let trip = Trip(title: tripName)
                        do{
                            try trip?.managedObjectContext?.save()
                            self.viewWillAppear(true)
                            //self.tripTableView.reloadData()
                            print("trip should be saved")
                        }catch{
                            print("Could not save trip")
                        }
                        
                        
                    }
                }))
                alert.addTextField(configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = "trip name"
                    textField.isSecureTextEntry = false
                })
                self.present(alert, animated: true, completion: nil)
            }
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                guard let destination = segue.destination as? EntriesViewController,
                let selectedRow = self.tripTableView.indexPathForSelectedRow?.row
                    else{
                        return
                }
                //print(trips?[selectedRow].entries?.count)
        //        trips?[selectedRow].addToRawEntries(Entry(entryTitle: "bob", text: "bob", date: Date.init())!)
        //        destination.trip = trips?[selectedRow]
                if let trips = trips {
                    print("trip exists")
                    destination.trip = trips[selectedRow]
                    //print(trips[selectedRow].entries)
                }
                destination.entries = trips?[selectedRow].entries
            }
            
            override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete{
                    deleteTrip(at: indexPath)
                }
            }
    
    
    
    

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let destination = segue.destination as? EntriesViewController,
            let selectedRow = self.tripTableView.indexPathForSelectedRow?.row
                else{
                    return
            }
        
            if let trips = trips {
                print("trip exists")
                destination.trip = trips[selectedRow]
            }
            destination.entries = trips?[selectedRow].entries
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete{
                deleteTrip(at: indexPath)
                
            }
        }
        
        func deleteTrip(at indexPath:IndexPath){
            let trip = trips?[indexPath.row]
            
            guard let managedContext = trip?.managedObjectContext else{
                return
            }
            managedContext.delete(trip!)
            do{
                try managedContext.save()
                trips?.remove(at: indexPath.row)
                tripTableView.deleteRows(at: [indexPath], with: .automatic)
            }catch{
                print("Could not delete Trip")
                tripTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    
}
