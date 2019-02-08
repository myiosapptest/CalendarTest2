//
//  ViewController.swift
//  CalendarTest2
//
//  Created by Ron Rith on 1/17/19.
//  Copyright © 2019 Ron Rith. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    let formatter = DateFormatter()

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    var cellDisplayDay: CustomCell!
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue:0x4e3f5d)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
    }
    func setupCalendarView(){
        //setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //setup labels
        calendarView.visibleDates{ visibleDates in
            self.setUpViewOfCalendar(from: visibleDates)
        }
    }
    func handleCellSelected(view: JTAppleCell?,cellState: CellState){
        guard let validCell = view as? CustomCell else {return}
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        }else{
            validCell.selectedView.isHidden = true
        }
    }
    func handleCellTextColor(view: JTAppleCell?,cellState: CellState){
        guard let validCell = view as? CustomCell else {return}
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        }else{
            if(cellState.dateBelongsTo == .thisMonth){
                validCell.dateLabel.textColor = monthColor
            }else{
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func setUpViewOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
        print("setUpViewOfCalendar self.month.text... \(self.month.text!)")
    }
}

extension ViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2019 01 01")!
        let endDate = formatter.date(from: "2019 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension ViewController: JTAppleCalendarViewDelegate{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    // display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        
        if cell.dateLabel.text == "5" {
            cell.buddaUIImageView.isHidden = false
        }else{
            cell.buddaUIImageView.isHidden = true
        }
        
        print("self.month.text... \(self.month.text!)")
        
        cell.layer.cornerRadius = 7
        cell.layer.borderWidth = 0
        
        handleCellSelected(view: cell,cellState: cellState)
        handleCellTextColor(view: cell,cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell,cellState: cellState)
        handleCellTextColor(view: cell,cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell,cellState: cellState)
        handleCellTextColor(view: cell,cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setUpViewOfCalendar(from: visibleDates)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("first self.month.text.. "+self.month.text!)
//        if self.month.text?.elementsEqual("month") == true{
//            self.month.text = "January"
//        }
        self.month.text = "January"
        print("ViewWill..")
        print("self.month.text.. "+self.month.text!)
    }
    
}


extension UIColor{
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
                          alpha: alpha
        )
    }
}
