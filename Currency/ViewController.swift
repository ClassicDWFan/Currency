//
//  ViewController.swift
//  Currency
//
//  Created by Robert O'Connor and John Ryan on 16/03/2018.
//  Copyright © 2018 IrishTwitApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK Model holders
    var currencyDict:Dictionary = [String:Currency]()
    var currencyArray = [Currency]()
    var baseCurrency:Currency = Currency.init(name:"EUR", rate:1, flag:"🇪🇺", symbol:"€")!
    var lastUpdatedDate:Date = Date()
    
    var convertValue:Double = 0
    
    //MARK Outlets
    //@IBOutlet weak var convertedLabel: UILabel!
    
    @IBOutlet weak var baseSymbol: UILabel!
    @IBOutlet weak var baseTextField: UITextField!
    @IBOutlet weak var baseFlag: UILabel!
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    
    @IBOutlet weak var gbpSymbolLabel: UILabel!
    @IBOutlet weak var gbpValueLabel: UILabel!
    @IBOutlet weak var gbpFlagLabel: UILabel!
    
    @IBOutlet weak var usdSymbolLabel: UILabel!
    @IBOutlet weak var usdValueLabel: UILabel!
    @IBOutlet weak var usdFlagLabel: UILabel!
    
    @IBOutlet weak var jpySymbolLabel: UILabel!
    @IBOutlet weak var jpyValueLabel: UILabel!
    @IBOutlet weak var jpyFlagLabel: UILabel!
    
    @IBOutlet weak var audSymbolLabel: UILabel!
    @IBOutlet weak var audValueLabel: UILabel!
    @IBOutlet weak var audFlagLabel: UILabel!
    
    @IBOutlet weak var cadSymbolLabel: UILabel!
    @IBOutlet weak var cadValueLabel: UILabel!
    @IBOutlet weak var cadFlagLabel: UILabel!
    
    @IBOutlet weak var chfSymbolLabel: UILabel!
    @IBOutlet weak var chfValueLabel: UILabel!
    @IBOutlet weak var chfFlagLabel: UILabel!
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if baseTextField.isEditing{
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.window?.frame.origin.y = -1 * keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.window?.frame.origin.y += keyboardHeight
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // print("currencyDict has \(self.currencyDict.count) entries")
        
        // create currency dictionary
        self.createCurrencyDictionary()
        
        // get latest currency values
        getConversionTable()
        convertValue = 1
        
        // set up base currency screen items
        baseTextField.text = String(format: "%.02f", baseCurrency.rate)
        baseSymbol.text = baseCurrency.symbol
        baseFlag.text = baseCurrency.flag
        
        // set up last updated date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy hh:mm a"
        lastUpdatedDateLabel.text = dateformatter.string(from: lastUpdatedDate)
        
        // display currency info
        self.displayCurrencyInfo()
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        
        self.addDoneButtonOnKeyboard()
        
        // setup view mover
        baseTextField.delegate = self
        
        self.convert(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.baseTextField.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction()
    {
        self.baseTextField.resignFirstResponder()
    }
    
    func createCurrencyDictionary(){
        //let c:Currency = Currency(name: name, rate: rate!, flag: flag, symbol: symbol)!
        //self.currencyDict[name] = c
        currencyDict["GBP"] = Currency(name:"GBP", rate:1, flag:"🇬🇧", symbol: "£")
        currencyDict["USD"] = Currency(name:"USD", rate:1, flag:"🇺🇸", symbol: "$")
        currencyDict["JPY"] = Currency(name:"JPY", rate:1, flag:"🇯🇵", symbol: "¥")
        currencyDict["AUD"] = Currency(name:"AUD", rate:1, flag:"🇦🇺", symbol: "AU$")
        currencyDict["CAD"] = Currency(name:"CAD", rate:1, flag:"🇨🇦", symbol: "CA$")
        currencyDict["CHF"] = Currency(name:"CHF", rate:1, flag:"🇨🇭", symbol: "Fr.")
    }
    
    func displayCurrencyInfo() {
        // GBP
        if let c = currencyDict["GBP"]{
            gbpSymbolLabel.text = c.symbol
            gbpValueLabel.text = String(format: "%.02f", c.rate)
            gbpFlagLabel.text = c.flag
        }
        if let c = currencyDict["USD"]{
            usdSymbolLabel.text = c.symbol
            usdValueLabel.text = String(format: "%.02f", c.rate)
            usdFlagLabel.text = c.flag
        }
        if let c = currencyDict["JPY"]{
            jpySymbolLabel.text = c.symbol
            jpyValueLabel.text = String(format: "%.02f", c.rate)
            jpyFlagLabel.text = c.flag
        }
        if let c = currencyDict["AUD"]{
            audSymbolLabel.text = c.symbol
            audValueLabel.text = String(format: "%.02f", c.rate)
            audFlagLabel.text = c.flag
        }
        if let c = currencyDict["CAD"]{
            cadSymbolLabel.text = c.symbol
            cadValueLabel.text = String(format: "%.02f", c.rate)
            cadFlagLabel.text = c.flag
        }
        if let c = currencyDict["CHF"]{
            chfSymbolLabel.text = c.symbol
            chfValueLabel.text = String(format: "%.02f", c.rate)
            chfFlagLabel.text = c.flag
        }
    }
    
    
    func getConversionTable() {
        //var result = "<NOTHING>"
        
        let urlStr:String = "https://api.fixer.io/latest"
        
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { response, data, error in
            
            indicator.stopAnimating()
            
            if error == nil{
                //print(response!)
                
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                    //print(jsonDict)
                    
                    if let ratesData = jsonDict["rates"] as? NSDictionary {
                        //print(ratesData)
                        for rate in ratesData{
                            //print("#####")
                            let name = String(describing: rate.key)
                            let rate = (rate.value as? NSNumber)?.doubleValue
                            //var symbol:String
                            //var flag:String
                            
                            switch(name){
                            case "USD":
                                //symbol = "$"
                                //flag = "🇺🇸"
                                let c:Currency  = self.currencyDict["USD"]!
                                c.rate = rate!
                                self.currencyDict["USD"] = c
                            case "GBP":
                                //symbol = "£"
                                //flag = "🇬🇧"
                                let c:Currency  = self.currencyDict["GBP"]!
                                c.rate = rate!
                                self.currencyDict["GBP"] = c
                            case "JPY":
                                //symbol = "¥"
                                //flag = "🇯🇵"
                                let c:Currency  = self.currencyDict["JPY"]!
                                c.rate = rate!
                                self.currencyDict["JPY"] = c
                            case "AUD":
                                //symbol = AU$"
                                //flag = "🇦🇺"
                                let c:Currency  = self.currencyDict["AUD"]!
                                c.rate = rate!
                                self.currencyDict["AUD"] = c
                            case "CAD":
                                //symbol = CA$"
                                //flag = ""🇨🇦"
                                let c:Currency  = self.currencyDict["CAD"]!
                                c.rate = rate!
                                self.currencyDict["CAD"] = c
                            case "CHF":
                                //symbol = "Fr."
                                //flag = "🇨🇭"
                                let c:Currency  = self.currencyDict["CHF"]!
                                c.rate = rate!
                                self.currencyDict["CHF"] = c
                            default:
                                print("Ignoring currency: \(String(describing: rate))")
                            }
                            
                            /*
                             let c:Currency = Currency(name: name, rate: rate!, flag: flag, symbol: symbol)!
                             self.currencyDict[name] = c
                             */
                        }
                        self.lastUpdatedDate = Date()
                    }
                }
                catch let error as NSError{
                    print(error)
                }
            }
            else{
                print("Error")
            }
            
        }
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        _ = getConversionTable()
    }
    
    @IBAction func convert(_ sender: Any) {
        var resultGBP = 0.0
        var resultUSD = 0.0
        var resultJPY = 0.0
        var resultAUD = 0.0
        var resultCAD = 0.0
        var resultCHF = 0.0
        
        if let euro = Double(baseTextField.text!) {
            convertValue = euro
            if let gbp = self.currencyDict["GBP"] {
                resultGBP = convertValue * gbp.rate
            }
            if let usd = self.currencyDict["USD"] {
                resultUSD = convertValue * usd.rate
            }
            if let jpy = self.currencyDict["JPY"] {
                resultJPY = convertValue * jpy.rate
            }
            if let aud = self.currencyDict["AUD"] {
                resultAUD = convertValue * aud.rate
            }
            if let cad = self.currencyDict["CAD"] {
                resultCAD = convertValue * cad.rate
            }
            if let chf = self.currencyDict["CHF"] {
                resultCHF = convertValue * chf.rate
            }
        }
        //GBP
        
        //convertedLabel.text = String(describing: resultGBP)
        
        gbpValueLabel.text = String(format: "%.02f", resultGBP)
        usdValueLabel.text = String(format: "%.02f", resultUSD)
        jpyValueLabel.text = String(format: "%.02f", resultJPY)
        audValueLabel.text = String(format: "%.02f", resultAUD)
        cadValueLabel.text = String(format: "%.02f", resultCAD)
        chfValueLabel.text = String(format: "%.02f", resultCHF)
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     
     }
     */
    
    
}

