//
//  SummaryVC.swift
//  Yogi Practice
//
//  Created by margot on 2018-01-02.
//  Copyright © 2018 foxberryfields. All rights reserved.
//

import UIKit
import Charts

class SummaryVC: UIViewController {
    
    var meditationTime = 0
    var practiceTime = 0
    
    @IBOutlet weak var pieChart: PieChartView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(meditationTime)
        print(practiceTime)
        
        pieChartUpdate()

    }
    
        func pieChartUpdate () {
            
            let entry1 = PieChartDataEntry(value: Double(meditationTime), label: "Meditation")
            let entry2 = PieChartDataEntry(value: Double(practiceTime), label: "Asana")
    
            let dataSet = PieChartDataSet(values: [entry1, entry2], label: " ")
            let data = PieChartData(dataSet: dataSet)
            
             // chart setup
            
            pieChart.data = data
            pieChart.chartDescription?.text = " "
           
            dataSet.colors = [UIColor(red:0.36, green:0.74, blue:0.58, alpha:1.0),
                          UIColor(red:0.67, green:0.40, blue:0.80, alpha:1.0)]
            
    

            pieChart.noDataText = "No data available"
            pieChart.centerText = ("Total: \(meditationTime+practiceTime) mins")
    
            //This must stay at end of function
            pieChart.notifyDataSetChanged()
        }



}
