//
//  YogaClassTableVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-11-26.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import Foundation

class YogaClassTableVC: UITableViewController {
    
    var classes = ["Standard Class", "Asana Class", "Pranayama Class"];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath)
        cell.textLabel?.text = classes[indexPath.row]
        //labelTitle.text=classes[indexPath.row]
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toClass" {
        let nextScene =  segue.destination as! PranayamaVC
        
        // Pass the selected object to the new view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let type = classes[indexPath.row]
            nextScene.selectedType = type
            
            }
        }
    }
}
 
