//
//  VisitedRestaurantListVC.swift
//  Grabem
//
//  Created by Callsoft on 16/01/19.
//  Copyright © 2019 callsoft. All rights reserved.
//

import UIKit

class VisitedRestaurantListVC: UIViewController {

    
    @IBOutlet weak var tableview: UITableView!
    //MARK: - Variables
    var scanedListArray = [ScannedListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func tap_backbtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension VisitedRestaurantListVC{
    
    func configureTableView(){
        
        let cellNib = UINib(nibName: "VisitedRestaurantTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "Cell")
        tableview.rowHeight = 106
        tableview.tableFooterView = UIView()
        QRCodeScanedListApiCall()
    }
}


extension VisitedRestaurantListVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scanedListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VisitedRestaurantTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.configure(with: self.scanedListArray[indexPath.row])
        return cell
    }
    
}
//MARK: - extension web services
extension VisitedRestaurantListVC{
    //qrcodeverification
    func QRCodeScanedListApiCall(){
        let user_id = UserDefaults.standard.value(forKey: "unique_user_id") as? String ?? ""
        let parameters = ["user_id":user_id]
        print(parameters)
        ServiceClassMethods.AlamoRequest(method: "POST", serviceString: AppConstants.kQRscanbyuser, parameters: parameters, completion: { (dic) in
            
            print("Response Data :\n\(dic)")
            if self.scanedListArray.count > 0{
                self.scanedListArray.removeAll()
            }
            let status =  dic.object(forKey: "status") as! NSString
//            guard let message = dic.object(forKey: "message") as? Int else{
//                print("No message.")
//                return
//            }
            if status == "SUCCESS"{
                if let dataArray = dic.object(forKey: "data") as? NSArray{
                    for dataItemIndex in 0..<dataArray.count{
                        if let scanedItemDict = dataArray[dataItemIndex] as? NSDictionary{
                            guard let discount = scanedItemDict.value(forKey: "discount") as? String else{
                                print("No discount")
                                return
                            }
                            guard let image1 = scanedItemDict.value(forKey: "image1") as? String else{
                                print("No image1")
                                return
                            }
                            guard let name = scanedItemDict.value(forKey: "name") as? String else{
                                print("No name")
                                return
                            }
                            guard let created_at = scanedItemDict.value(forKey: "created_at") as? String else{
                                print("No created_at")
                                return
                            }
                            
                            
                            let scanedItemModelItem = ScannedListDataModel(discount: String(discount), image1: image1, name: name,created_at:created_at)
                            self.scanedListArray.append(scanedItemModelItem)
                            self.tableview.insertRows(at: [IndexPath(row: dataItemIndex, section: 0)], with: .automatic)
                        }
                    }
                    
                }
                
            } else if status == "FAILURE"{
                
               
                
            }
        })
    }
}


