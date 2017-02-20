//
//  CountriesController.swift
//  SpontProject
//
//  Created by Alex Sanchez on 20/2/17.
//  Copyright © 2017 Alex Sanchez. All rights reserved.
//

import UIKit

class CountriesController: UITableViewController {
    
    var countriesArray = [String]()
    var numbersArray = [String]()
    var codesArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadListOfCountries()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissController))
        self.navigationItem.title = "Seleccionar país"
        tableView.register(CountryCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return countriesArray.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryCell
        cell.nameTextLabel.text = countriesArray[indexPath.row]
        cell.numberTextLabel.text = "+" + numbersArray[indexPath.row]
        return cell
    }
    
    func loadListOfCountries(){
        let pathCount = Bundle.main.path(forResource: "countries_en", ofType: "txt")
        let pathNumb = Bundle.main.path(forResource: "countries_numbers", ofType: "txt")
        let pathCode = Bundle.main.path(forResource: "countries_codes", ofType: "txt")
        
        if let pathCountries = pathCount, let pathNumbers = pathNumb, let pathCod = pathCode {
            // Load the file contents as a string.
            
            do {
                let countriesString = try String(contentsOfFile: pathCountries, encoding: String.Encoding.utf8)
                let numbersString = try String(contentsOfFile: pathNumbers, encoding: String.Encoding.utf8)
                let codesString = try String(contentsOfFile: pathCod, encoding: String.Encoding.utf8)
                countriesArray = countriesString.components(separatedBy: "\n")
                numbersArray = numbersString.components(separatedBy: "\n")
                codesArray = codesString.components(separatedBy: "\n")
            } catch let err {
                print(err)
            }
            
        }
    }
    
    func dismissController(){
        dismiss(animated: true, completion: nil)
    }

}
