//
//  InventoryReserveCart.swift
//  GIS
//
//  Created by MacBook Hawkscode  on 02/12/22.
//  Copyright © 2022 Hawkscode. All rights reserved.
//

import UIKit
import UIDrawer
import Alamofire

class ReserveNewItems : UITableViewCell {
    let mDatePicker:UIDatePicker = UIDatePicker()

    @IBOutlet weak var mAmount: UITextField!
    @IBOutlet weak var mChooseDate: UIButton!
    @IBOutlet weak var mProductImage: UIImageView!
    @IBOutlet weak var mSno: UILabel!
    @IBOutlet weak var mRemarks: UITextField!
    @IBOutlet weak var mProductInfo: UILabel!
    @IBOutlet weak var mDeleteItem: UIButton!
    @IBOutlet weak var mSKU: UILabel!
    @IBOutlet weak var mDueDate: UITextField!
    @IBOutlet weak var mPlusButton: UIButton!
    @IBOutlet weak var mMaterialInfo: UILabel!
    @IBOutlet weak var mStockId: UILabel!
    @IBOutlet weak var mQuantity: UILabel!
    @IBOutlet weak var mMinusButton: UIButton!
 
}

class InventoryReserveCart: UIViewController , GetCustomerDataDelegate , UIViewControllerTransitioningDelegate , UITextViewDelegate , UITableViewDelegate, UITableViewDataSource {
  
    var mCurrentIndex = -1
    @IBOutlet weak var mCustomerName: UILabel!
    @IBOutlet weak var mCustomerImage: UIImageView!
    @IBOutlet weak var mSelectedCustomerIcon: UIImageView!
    var mQuantityData = [Int]()
    @IBOutlet weak var mReserveCartTable: UITableView!
    @IBOutlet weak var mCheckOutView: UIView!
    let mDatePicker:UIDatePicker = UIDatePicker()
    private var mReserveData = NSMutableArray()
    var mOriginalData = NSArray()
    
    var mCustomerId = ""
    @IBOutlet weak var mReserveHeadingLABEL: UILabel!
    @IBOutlet weak var mCustomerLABEL: UILabel!
    
    @IBOutlet weak var mSubmitBUTTON: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        self.mReserveHeadingLABEL.text = "Reserve".localizedString
        mCustomerLABEL.text = "Customer".localizedString
        mSubmitBUTTON.setTitle("SUBMIT".localizedString, for: .normal)
        mReserveData = NSMutableArray(array: mOriginalData )
        mQuantityData = [Int]()
        
        for i in mReserveData {
            if let mData = i as? NSDictionary {
                mQuantityData.append(Int("\(mData.value(forKey: "po_QTY") ?? "0")") ?? 0)
            }
        }
        self.mReserveCartTable.delegate  = self
        self.mReserveCartTable.dataSource = self
        self.mReserveCartTable.reloadData()
        
        mCustomerName.text = ""
        mCustomerImage.contentMode = .scaleAspectFill
        
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
            home.delegate = self
            home.modalPresentationStyle = .automatic
            home.transitioningDelegate = self
            self.present(home,animated: true)
        }
    }
    
    @IBAction func mBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
        
 
        
    
    
    
    @IBAction func mMinusButton(_ sender: UIButton) {
      
        
        let index = sender.tag
        if let mInvData = mReserveData[index] as? NSDictionary,
           let cells = mReserveCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? ReserveNewItems {
            
            let mMinQty = 1
            var mCurrentQty = Int(cells.mQuantity.text ?? "") ?? 0
            if  mCurrentQty == mMinQty {
                cells.mQuantity.text = "\(mMinQty)"
                cells.mAmount.text = "\((Double("\(mInvData.value(forKey: "price") ?? "0")") ?? 0.0) * (Double(mMinQty)))"
            }else{
                mCurrentQty = mCurrentQty - 1
                cells.mQuantity.text = "\(mCurrentQty)"
                cells.mAmount.text = "\((Double("\(mInvData.value(forKey: "price") ?? "0")") ?? 0.0) * (Double(mCurrentQty)))"
            }
            
            let mData = NSMutableDictionary()
            mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
            mData.setValue("\(cells.mQuantity.text ?? "")", forKey: "quantity")
            mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "")", forKey: "po_QTY")
            mData.setValue("\(mInvData.value(forKey: "sku") ?? "")", forKey: "sku")
            mData.setValue("\(mInvData.value(forKey: "stockId") ?? "")", forKey: "stockId")
            mData.setValue("\(mInvData.value(forKey: "price") ?? "")", forKey: "price")
            mData.setValue("\(mInvData.value(forKey: "Matatag") ?? "")", forKey: "Matatag")
            mData.setValue("\(mInvData.value(forKey: "image") ?? "")", forKey: "image")
            mData.setValue("\(mInvData.value(forKey: "metal") ?? "")", forKey: "metal")
            mData.setValue("\(mInvData.value(forKey: "size") ?? "")", forKey: "size")
            mData.setValue("\(mInvData.value(forKey: "dueDate") ?? "")", forKey: "dueDate")
            mData.setValue("\(mInvData.value(forKey: "notes") ?? "")", forKey: "notes")
            
            mReserveData.removeObject(at: index)
            mReserveData.insert(mData, at: index)
        }
    }
    
    
    @IBAction func mPlusButton(_ sender: UIButton) {
        let index = sender.tag
        
        if let mInvData = mReserveData[index] as? NSDictionary,
            let cells = mReserveCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? ReserveNewItems {
            
            let mMaxQty =  mQuantityData[index]
            var mCurrentQty = Int(cells.mQuantity.text ?? "") ?? 0
            if  mCurrentQty == mMaxQty {
                cells.mQuantity.text = "\(mMaxQty)"
                
                cells.mAmount.text = "\((Double("\(mInvData.value(forKey: "price") ?? "0")") ?? 0.0) * (Double(mMaxQty)))"
                
                
                
                
            }else{
                mCurrentQty = mCurrentQty + 1
                cells.mQuantity.text = "\(mCurrentQty)"
                cells.mAmount.text = "\((Double("\(mInvData.value(forKey: "price") ?? "0")") ?? 0.0) * (Double(mCurrentQty)))"
                
                
            }
            
            let mData = NSMutableDictionary()
            mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
            mData.setValue("\(cells.mQuantity.text ?? "")", forKey: "quantity")
            mData.setValue("\(mInvData.value(forKey: "sku") ?? "")", forKey: "sku")
            mData.setValue("\(mInvData.value(forKey: "stockId") ?? "")", forKey: "stockId")
            mData.setValue("\(mInvData.value(forKey: "price") ?? "")", forKey: "price")
            mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "")", forKey: "po_QTY")
            mData.setValue("\(mInvData.value(forKey: "Matatag") ?? "")", forKey: "Matatag")
            mData.setValue("\(mInvData.value(forKey: "image") ?? "")", forKey: "image")
            mData.setValue("\(mInvData.value(forKey: "metal") ?? "")", forKey: "metal")
            mData.setValue("\(mInvData.value(forKey: "size") ?? "")", forKey: "size")
            mData.setValue("\(mInvData.value(forKey: "dueDate") ?? "")", forKey: "dueDate")
            mData.setValue("\(mInvData.value(forKey: "notes") ?? "")", forKey: "notes")
            
            mReserveData.removeObject(at: index)
            mReserveData.insert(mData, at: index)
        }
    }
    
    
    @IBAction func mChooseDate(_ sender: UIButton) {
        guard let cells = mReserveCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? ReserveNewItems else {
            return
        }

        mCurrentIndex = sender.tag
        let currentDate = Date()
        var datecomp = DateComponents()
        let min = Calendar.init(identifier: .gregorian)
        
        mDatePicker.preferredDatePickerStyle = .wheels
        datecomp.day = 0
        let minDates = min.date(byAdding: datecomp, to: currentDate)
        
        datecomp.year = 5
        let maxDates = min.date(byAdding: datecomp, to: currentDate)
        mDatePicker.minimumDate = minDates
        mDatePicker.maximumDate = maxDates
        mDatePicker.datePickerMode = .date
        mDatePicker.backgroundColor = .white
        //ToolBar
        let mToolBar = UIToolbar()
        mToolBar.sizeToFit()
        mToolBar.backgroundColor = .white
        mToolBar.barTintColor = .white
        let mDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePick))
        let mSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let mCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(mCancelDatePick))
        mToolBar.setItems([mCancel, mSpace,mDone], animated: false)
        cells.mDueDate.inputAccessoryView = mToolBar
        cells.mDueDate.inputView = mDatePicker
        cells.mDueDate.becomeFirstResponder()

    }
    
    @objc
    func doneDatePick(){
        let mDayd = DateFormatter()
        mDayd.dateFormat = "dd"
        
        let mMonthm = DateFormatter()
        mMonthm.dateFormat = "MM"
        
        let mYeard = DateFormatter()
        mYeard.dateFormat = "yyyy"
        
        if let cell1 = mReserveCartTable.cellForRow(at: IndexPath(row: mCurrentIndex, section: 0)) as? ReserveNewItems {
            
            cell1.mDueDate.text  = "\(mMonthm.string(from: mDatePicker.date))/" +  "\(mDayd.string(from: mDatePicker.date))/"+"\(mYeard.string(from: mDatePicker.date))"
            
            
            if let mInvData = mReserveData[mCurrentIndex] as? NSDictionary {
                
                let mData = NSMutableDictionary()
                mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
                mData.setValue("\(mInvData.value(forKey: "quantity") ?? "")", forKey: "quantity")
                mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "")", forKey: "po_QTY")
                mData.setValue("\(mInvData.value(forKey: "sku") ?? "")", forKey: "sku")
                mData.setValue("\(mInvData.value(forKey: "stockId") ?? "")", forKey: "stockId")
                mData.setValue("\(mInvData.value(forKey: "price") ?? "")", forKey: "price")
                mData.setValue("\(mInvData.value(forKey: "Matatag") ?? "")", forKey: "Matatag")
                mData.setValue("\(mInvData.value(forKey: "image") ?? "")", forKey: "image")
                mData.setValue("\(mInvData.value(forKey: "metal") ?? "")", forKey: "metal")
                mData.setValue("\(mInvData.value(forKey: "size") ?? "")", forKey: "size")
                mData.setValue("\(cell1.mDueDate.text ?? "")", forKey: "dueDate")
                mData.setValue("\(mInvData.value(forKey: "notes") ?? "")", forKey: "notes")
                
                mReserveData.removeObject(at: mCurrentIndex)
                mReserveData.insert(mData, at: mCurrentIndex)
            }
            self.view.endEditing(true)
    }
        
    }
         @objc func mCancelDatePick(){
             self.view.endEditing(true)
         }
    
    @IBAction func mDueDateOnChange(_ sender: UITextField) {
     
    }
    
    @IBAction func mEditAmount(_ sender: UITextField) {
        
        if let mInvData = mReserveData[sender.tag] as? NSDictionary,
              let mOrgData = mOriginalData[sender.tag] as? NSDictionary,
              let cells = mReserveCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? ReserveNewItems {
                  
                  if sender.text == "" || sender.text == "0" {
                      cells.mAmount.text = "\(mOrgData.value(forKey: "price") ?? "")"
                      let mData = NSMutableDictionary()
                      mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
                      mData.setValue("\(mInvData.value(forKey: "quantity") ?? "")", forKey: "quantity")
                      mData.setValue("\(mInvData.value(forKey: "sku") ?? "")", forKey: "sku")
                      mData.setValue("\(mInvData.value(forKey: "stockId") ?? "")", forKey: "stockId")
                      mData.setValue(cells.mAmount.text ?? "0", forKey: "price")
                      mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "0")", forKey: "po_QTY")
                      
                      mData.setValue("\(mInvData.value(forKey: "Matatag") ?? "")", forKey: "Matatag")
                      mData.setValue("\(mInvData.value(forKey: "image") ?? "")", forKey: "image")
                      mData.setValue("\(mInvData.value(forKey: "metal") ?? "")", forKey: "metal")
                      mData.setValue("\(mInvData.value(forKey: "size") ?? "")", forKey: "size")
                      mData.setValue("\(mInvData.value(forKey: "dueDate") ?? "")", forKey: "dueDate")
                      mData.setValue("\(mInvData.value(forKey: "notes") ?? "")", forKey: "notes")
                      mReserveData.removeObject(at: sender.tag)
                      mReserveData.insert(mData, at: sender.tag)
                      
                      return
                  }
                  
                  
                  let mData = NSMutableDictionary()
                  mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
                  mData.setValue("\(mInvData.value(forKey: "quantity") ?? "")", forKey: "quantity")
                  mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "")", forKey: "po_QTY")
                  
                  mData.setValue("\(mInvData.value(forKey: "sku") ?? "")", forKey: "sku")
                  mData.setValue("\(mInvData.value(forKey: "stockId") ?? "")", forKey: "stockId")
                  mData.setValue(cells.mAmount.text, forKey: "price")
                  mData.setValue("\(mInvData.value(forKey: "Matatag") ?? "")", forKey: "Matatag")
                  mData.setValue("\(mInvData.value(forKey: "image") ?? "")", forKey: "image")
                  mData.setValue("\(mInvData.value(forKey: "metal") ?? "")", forKey: "metal")
                  mData.setValue("\(mInvData.value(forKey: "size") ?? "")", forKey: "size")
                  mData.setValue("\(mInvData.value(forKey: "dueDate") ?? "")", forKey: "dueDate")
                  mData.setValue("\(mInvData.value(forKey: "notes") ?? "")", forKey: "notes")
                  
                  mReserveData.removeObject(at: sender.tag)
                  mReserveData.insert(mData, at: sender.tag)
                  
              }
    }
    
    @IBAction func mEditremarks(_ sender: UITextField) {
        
        if let mInvData = mReserveData[sender.tag] as? NSDictionary,
           let cells = mReserveCartTable.cellForRow(at: IndexPath(row: sender.tag , section: 0)) as? ReserveNewItems {
            let mData = NSMutableDictionary()
            mData.setValue("\(mInvData.value(forKey: "id") ?? "")", forKey: "id")
            mData.setValue("\(mInvData.value(forKey: "quantity") ?? "")", forKey: "quantity")
            mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "")", forKey: "po_QTY")
            
            mData.setValue("\(mInvData.value(forKey: "sku") ?? "")", forKey: "sku")
            mData.setValue("\(mInvData.value(forKey: "stockId") ?? "")", forKey: "stockId")
            mData.setValue("\(mInvData.value(forKey: "price") ?? "")", forKey: "price")
            mData.setValue("\(mInvData.value(forKey: "Matatag") ?? "")", forKey: "Matatag")
            mData.setValue("\(mInvData.value(forKey: "image") ?? "")", forKey: "image")
            mData.setValue("\(mInvData.value(forKey: "metal") ?? "")", forKey: "metal")
            mData.setValue("\(mInvData.value(forKey: "size") ?? "")", forKey: "size")
            mData.setValue("\(mInvData.value(forKey: "dueDate") ??  "")", forKey: "dueDate")
            mData.setValue(cells.mRemarks.text ?? "", forKey: "notes")
            mReserveData.removeObject(at: sender.tag)
            mReserveData.insert(mData, at: sender.tag)
        }
    }
    
    
    @IBAction func mDeleteReserve(_ sender: UIButton) {
        mDeleteCartItems(index: sender.tag)
        }
    
    func mDeleteCartItems(index: Int) {
        self.mReserveData.removeObject(at: index)
        self.mReserveCartTable.reloadData()
 
    }
        @IBAction func mOpenImages(_ sender: UIButton) {
      
                  
        }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
     
       if editingStyle == .delete {
           self.mDeleteCartItems(index: indexPath.row)
       }
   }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mReserveData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        guard let cells = tableView.dequeueReusableCell(withIdentifier: "ReserveNewItems") as? ReserveNewItems else {
            return UITableViewCell()
        }
        
        cells.mDueDate.tag = indexPath.row
        cells.mSno.text = "#\(indexPath.row + 1)"

        if let mData = mReserveData[indexPath.row] as? NSDictionary {
            cells.mRemarks.tag = indexPath.row
            cells.mChooseDate.tag = indexPath.row
            cells.mPlusButton.tag = indexPath.row
            cells.mMinusButton.tag = indexPath.row
            cells.mDeleteItem.tag = indexPath.row
            cells.mAmount.tag = indexPath.row
            cells.mRemarks.placeholder = "EX. Urgent Order".localizedString
            cells.mDueDate.text = "\(mData.value(forKey: "dueDate") ?? "--")"
            cells.mProductInfo.text = "\(mData.value(forKey: "Matatag") ?? "--")"
            cells.mSKU.text = "\(mData.value(forKey: "sku") ?? "--")"
            cells.mMaterialInfo.text = "\(mData.value(forKey: "metal") ?? "--")" + " \(mData.value(forKey: "size") ?? "--")"
            cells.mAmount.text = "\(mData.value(forKey: "price") ?? "--")"
            cells.mQuantity.text = "\(mData.value(forKey: "quantity") ?? "--")"
            cells.mStockId.text = "\(mData.value(forKey: "stockId") ?? "--")"
            cells.mProductImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "image") ?? "")")
            
            if let reserveDate = UserDefaults.standard.string(forKey: "reserveDeliveryDate") {
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                if let date = inputFormatter.date(from: reserveDate) {
                    let outputFormatter = DateFormatter()
                    outputFormatter.dateFormat = "MM/dd/yyyy"
                    let outputDateString = outputFormatter.string(from: date)
                    cells.mDueDate.text = outputDateString
                }
            }
            
        }
        return cells
    }
     
    func mCreateNewCustomer() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "reserveBoard", bundle: nil)
        if let mCreateCustomer = storyBoard.instantiateViewController(withIdentifier: "CreateCustomer") as? CreateCustomer {
            self.navigationController?.pushViewController(mCreateCustomer, animated:true)
        }
    }

    func mGetCustomerData(data: NSMutableDictionary) {
        if let id = data.value(forKey: "id") as? String {
            UserDefaults.standard.set(id, forKey: "DEFAULTCUSTOMER")
            self.mCustomerId = id
        }
        UserDefaults.standard.set(data.value(forKey: "profile") ?? "", forKey: "DEFAULTCUSTOMERPICTURE")
        
        if let name = data.value(forKey: "name") as? String {
            UserDefaults.standard.set(name, forKey: "DEFAULTCUSTOMERNAME")
            self.mCustomerName.text = name
        }
        
        self.mCustomerImage.downlaodImageFromUrl(urlString: "\(data.value(forKey: "profile") ?? "")")
        self.mSelectedCustomerIcon.image = UIImage(named: "selected_customer")
        
    }

        
        @IBAction func mChooseCustomer(_ sender: Any) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
            if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
                home.delegate = self
                home.modalPresentationStyle = .automatic
                home.transitioningDelegate = self
                self.present(home,animated: true)
            }
        }
       
        
        
    @IBAction func mCreateReseveNow(_ sender: Any) {
   
        if mCustomerId == "" {
            CommonClass.showSnackBar(message: "Please choose customer!")
            return
        }
        
        if mReserveData.count == 0 {
            CommonClass.showSnackBar(message: "No items in cart!")
            return
        }
        let mReserveProductsData = NSMutableArray()
        for item in mReserveData {
            if let value = item as? NSDictionary {
                let mData = NSMutableDictionary()
                mData.setValue("\(value.value(forKey: "sku") ?? "")", forKey: "SKU")
                mData.setValue("\(value.value(forKey: "stockId") ?? "")", forKey: "stock_id")
                mData.setValue("\(value.value(forKey: "quantity") ?? "")", forKey: "reserve_qty")
                mData.setValue("\(value.value(forKey: "price") ?? "")", forKey: "price")
                mData.setValue("\(value.value(forKey: "notes") ?? "")", forKey: "remark")
                mData.setValue("\(value.value(forKey: "dueDate") ?? "" )", forKey: "dueDate")
                mData.setValue("\(value.value(forKey: "id") ?? "")", forKey: "po_product_id")
                mReserveProductsData.add(mData)
            }
        }

        
        let mLocation = UserDefaults.standard.string(forKey: "location") ?? ""
        
        let params:[String: Any] = ["reservedItems" : mReserveProductsData, "customer_id" : mCustomerId, "location_id": mLocation]
        
        CommonClass.showFullLoader(view: self.view)
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")

        mGetData(url: mCreateReserve ,headers: sGisHeaders,  params: params) { response , status in
            CommonClass.stopLoader()
            if status {
                if "\(response.value(forKey: "code") ?? "")" == "200" {

                    CommonClass.showSnackBar(message: "Reserved Items Successfully!")
                    let storyBoard: UIStoryboard = UIStoryboard(name: "reserveBoard", bundle: nil)
                    if let mInventoryPage = storyBoard.instantiateViewController(withIdentifier: "InventoryPageNew") as? InventoryPage {
                        self.navigationController?.pushViewController(mInventoryPage, animated:true)
                    }
                }else{
                }
            }
        }
        
    }
        
        
        
   
        
    }
