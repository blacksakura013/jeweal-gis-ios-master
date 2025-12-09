//
//  SalesPerson.swift
//  GIS
//
//  Created by MacBook Hawkscode  on 04/04/23.
//  Copyright © 2023 Hawkscode. All rights reserved.
//

import UIKit
import Alamofire
class SalesPersonTableCell : UITableViewCell , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var mTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mNotes: UITextView!
    
    @IBOutlet weak var mCustomerImage: UIImageView!
    @IBOutlet weak var mParkItemsTable: UITableView!
    @IBOutlet weak var mCustomerName: UILabel!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mCheckImage: UIImageView!
    
    @IBOutlet weak var mMobile: UILabel!
    @IBOutlet weak var mType: UILabel!
    @IBOutlet weak var mDate: UILabel!
    
    var mCartData = NSArray()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mCartData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ParkNestedCell") as? ParkNestedCell,
              let mData = mCartData[indexPath.row] as? NSDictionary else {
            return UITableViewCell()
        }
        
        cell.mSNo.text = "\(indexPath.row + 1)"
        cell.mProductName.text = "\(mData.value(forKey: "name") ?? "")"
        cell.mQty.text = "\(mData.value(forKey: "Qty") ?? "")"
        cell.mPrice.text = "\(mData.value(forKey: "currency") ?? "")" + "\(mData.value(forKey: "price") ?? "")"
        cell.mStockId.text = "\(mData.value(forKey: "stock_id") ?? "")"
        cell.mSKUName.text = "\(mData.value(forKey: "SKU") ?? "")"
        cell.mMetalSizeColor.text = "\(mData.value(forKey: "metal_name") ?? "")" + "\(mData.value(forKey: "size_name") ?? "")"
        
        
        cell.mProductImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "main_image") ?? "")")
        
        return cell
    }
}

class TransactionCell : UITableViewCell {
    
    @IBOutlet weak var mCheckImage: UIImageView!
    @IBOutlet weak var mCheckButton: UIButton!
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var mTotalQuantity: UILabel!
    @IBOutlet weak var mTotalInvoice: UILabel!
    @IBOutlet weak var mCustomerName: UILabel!
    @IBOutlet weak var mAddressMobile: UILabel!
    @IBOutlet weak var mCustomerImage: UIImageView!
    
    @IBOutlet weak var mTotalQuantityLABEL: UILabel!
    @IBOutlet weak var mTotalInvoiceLABEL: UILabel!
    @IBOutlet weak var mTotalAmountLABEL: UILabel!
    
}

class SalesPerson: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    let mDatePicker:UIDatePicker = UIDatePicker()
    @IBOutlet weak var mProfilePicture: UIImageView!
    
    @IBOutlet weak var mUserName: UILabel!
    
    @IBOutlet weak var mCloudAccount: UILabel!
    @IBOutlet weak var mLocation: UILabel!
    @IBOutlet weak var mOrganization: UILabel!
    @IBOutlet weak var mTime: UILabel!
    @IBOutlet weak var mDOB: UILabel!
    @IBOutlet weak var TransactionTable: UITableView!
    @IBOutlet weak var mCustomerTable: UITableView!
    
    @IBOutlet weak var mTransactionLabel: UILabel!
    @IBOutlet weak var mTransactionLine: UILabel!
    
    @IBOutlet weak var mCustomerLabel: UILabel!
    @IBOutlet weak var mCustomerLine: UILabel!
    
    @IBOutlet weak var mTotalCustomers: UILabel!
    @IBOutlet weak var mTotalCustomerView: UIView!
    
    @IBOutlet weak var mTransactionView: UIStackView!
    
    @IBOutlet weak var mTotalQuantity: UILabel!
    @IBOutlet weak var mTotalInvoice: UILabel!
    @IBOutlet weak var mTotalAmount: UILabel!
    @IBOutlet weak var mCustomerView: UIStackView!
    
    @IBOutlet weak var mDetailsView: UIView!
    @IBOutlet weak var mViewMoreCheckIcon: UIImageView!
    @IBOutlet weak var mViewMoreLess: UILabel!
    @IBOutlet weak var mMostAmount: UILabel!
    @IBOutlet weak var mCurrentDate: UITextField!
    var mMonth = ""
    var mYear = ""
    var mSalespersonTransactionData = NSArray()
    var mCustomerTransactionData = NSArray()
    
    var delegate:SalesPersonTransactionDelegate? = nil
    var mIndex = -1
    
    @IBOutlet weak var mStoreLABEL: UILabel!
    
    @IBOutlet weak var mCloudAccountLABEL: UILabel!
    @IBOutlet weak var mOrganizationLABEL: UILabel!
    
    @IBOutlet weak var mTotalAmountLABEL: UILabel!
    @IBOutlet weak var mHeading: UILabel!
    
    @IBOutlet weak var mTotalInvoiceLABEL: UILabel!
    
    @IBOutlet weak var mTotalCustomerLABEL: UILabel!
    @IBOutlet weak var mTotalQuantityLABEL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mShowDatePicker()
        
        mTotalCustomerLABEL.text = "Total Customer".localizedString
        
        mStoreLABEL.text = "Store".localizedString
        mCloudAccountLABEL.text = "Cloud Account".localizedString
        mOrganizationLABEL.text = "Organization".localizedString
        mTotalAmountLABEL.text = "Total Amount".localizedString
        mHeading.text = "Sales Person".localizedString
        mTotalInvoiceLABEL.text = "Total Invoice".localizedString
        mTotalQuantityLABEL.text = "Total Quantity".localizedString
        mTransactionLabel.text = "Transaction".localizedString
        mCustomerLabel.text = "Customer".localizedString
        mViewMoreLess.text = "View More".localizedString
        
        mCustomerTable.rowHeight = 181
        mTransactionLabel.textColor = #colorLiteral(red: 0.1647058824, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
        mCustomerLabel.textColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
        mTransactionLine.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1)
        mCustomerLine.backgroundColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
        mTransactionView.isHidden = false
        mCustomerView.isHidden = true
        
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        
        let formatter2 = DateFormatter()
        formatter2.timeStyle = .short
        formatter2.dateStyle = .none
        mDOB.text =  formatter.string(from: currentDateTime)
        mTime.text =  formatter2.string(from: currentDateTime)
        
        let mMonthm = DateFormatter()
        mMonthm.dateFormat = "MMM"
        
        let mMonthInt = DateFormatter()
        mMonthInt.dateFormat = "MM"
        
        let mYeard = DateFormatter()
        mYeard.dateFormat = "yyyy"
        
        let mYearInt = DateFormatter()
        mYearInt.dateFormat = "yyyy"
        mCurrentDate.text  =   "\(mMonthm.string(from: mDatePicker.date)) "+"\(mYeard.string(from: mDatePicker.date))"
        mMonth = "\(mMonthInt.string(from: mDatePicker.date))"
        mYear = "\(mYearInt.string(from: mDatePicker.date))"
        
        self.mMostAmount.text = "Low to High"
        mGetCustomerTransaction(month: mMonth, year: mYear , sort: "1")
        mGetTransactions(month: mMonth, year: mYear)
        
        
        
        
    }
    
    
    func mGetTransactions(month : String, year: String) {
        
        mGetData(url: mGetSalesPersonTransactions,headers: sGisHeaders,  params: ["month":month,"Year":year]) { response , status in
            if status {
                
                if let mSalesPersonData = response.value(forKey: "sales_person") as? NSDictionary {
                    self.mProfilePicture.downlaodImageFromUrl(urlString: "\(mSalesPersonData.value(forKey : "myProfile") ?? "--")")
                    self.mOrganization.text = "\(mSalesPersonData.value(forKey : "organization") ?? "--")"
                    self.mLocation.text = "\(mSalesPersonData.value(forKey : "storeName") ?? "--")"
                    self.mCloudAccount.text = "\(mSalesPersonData.value(forKey : "Domain") ?? "--")"
                    self.mUserName.text = "\(mSalesPersonData.value(forKey : "name") ?? "--")"
                }
                if let mData = response.value(forKey: "data") as? NSDictionary {
                    
                    
                    if let mCountData = mData.value(forKey: "count") as? NSDictionary {
                        
                        self.mTotalInvoice.text = "\(mCountData.value(forKey:"total_invoice") ?? "0" )"
                        self.mTotalAmount.text = "\(mCountData.value(forKey:"total_amount") ?? "0" )"
                        self.mTotalQuantity.text = "\(mCountData.value(forKey:"total_qty") ?? "0" )"
                        
                    }
                    
                    if let mArr = mData.value(forKey: "response") as? NSArray {
                        
                        if mArr.count > 0 {
                            self.mSalespersonTransactionData = mArr
                            self.TransactionTable.delegate = self
                            self.TransactionTable.dataSource = self
                            self.TransactionTable.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    func mGetCustomerTransaction(month : String, year: String, sort : String) {
        
        mGetData(url: mGetCustomerTransactions, headers: sGisHeaders, params: ["month":month,"Year":year , "sort":sort]) { response , status in
            if status {
                
                self.mTotalCustomers.text = "\(response.value(forKey: "total") ?? "0")"
                if let mData = response.value(forKey: "data") as? NSArray {
                    
                    if mData.count > 0 {
                        self.mCustomerTransactionData = mData
                        self.mCustomerTable.delegate = self
                        self.mCustomerTable.dataSource = self
                        self.mCustomerTable.reloadData()
                    }
                }
            }
        }
    }
    
    
    @IBAction func mSelectTransaction(_ sender: Any) {
        mTransactionLabel.textColor = #colorLiteral(red: 0.1647058824, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
        mCustomerLabel.textColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
        mTransactionLine.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1)
        mCustomerLine.backgroundColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
        mTransactionView.isHidden = false
        mCustomerView.isHidden = true
        
    }
    
    @IBAction func mSelectCustomer(_ sender: Any) {
        mCustomerLabel.textColor = #colorLiteral(red: 0.1647058824, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
        mTransactionLabel.textColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
        mCustomerLine.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1)
        mTransactionLine.backgroundColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
        mTransactionView.isHidden = true
        mCustomerView.isHidden = false
    }
    
    
    @IBAction func mBack(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    
    
    @IBAction func mViewMore(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            mViewMoreCheckIcon.image = UIImage(systemName: "chevron.down")
            mDetailsView.isHidden = true
            mViewMoreLess.text = "View More".localizedString
        }else{
            mViewMoreLess.text = "View Less".localizedString
            mDetailsView.isHidden = false
            mViewMoreCheckIcon.image = UIImage(systemName:  "chevron.up")
        }
    }
    
    
    @IBAction func mChooseDate(_ sender: Any) {
        mCurrentDate.becomeFirstResponder()
    }
    
    func mShowDatePicker(){
        let currentDate = Date()
        var datecomp = DateComponents()
        let min = Calendar.init(identifier: .gregorian)
        
        mDatePicker.preferredDatePickerStyle = .wheels
        datecomp.year = -5
        let minDates = min.date(byAdding: datecomp, to: currentDate)
        
        datecomp.year = 0
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
        mToolBar.setItems([mDone, mSpace,mCancel], animated: false)
        
        mCurrentDate.inputAccessoryView = mToolBar
        mCurrentDate.inputView = mDatePicker
        
    }
    @objc func doneDatePick(){
        let mDayd = DateFormatter()
        mDayd.dateFormat = "dd"
        
        let mMonthm = DateFormatter()
        mMonthm.dateFormat = "MMM"
        
        let mMonthInt = DateFormatter()
        mMonthInt.dateFormat = "MM"
        
        let mYeard = DateFormatter()
        mYeard.dateFormat = "yyyy"
        
        
        
        mCurrentDate.text  =   "\(mMonthm.string(from: mDatePicker.date)) "+"\(mYeard.string(from: mDatePicker.date))"
        
        mMonth = "\(mMonthInt.string(from: mDatePicker.date))"
        mYear = "\(mYeard.string(from: mDatePicker.date))"
        
        self.mMostAmount.text = "Low to High"
        mGetCustomerTransaction(month: mMonth, year: mYear , sort: "1")
        mGetTransactions(month: mMonth, year: mYear)
        
        self.view.endEditing(true)
        
        
        
        
    }
    @objc func mCancelDatePick(){
        self.view.endEditing(true)
    }
    @IBAction func mMostAmount(_ sender: Any) {
        if   self.mMostAmount.text == "Low to High" {
            mGetCustomerTransaction(month: mMonth, year: mYear , sort: "0")
            self.mMostAmount.text = "High to Low"
            
        }else{
            mGetCustomerTransaction(month: mMonth, year: mYear , sort: "1")
            self.mMostAmount.text = "Low to High"
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == TransactionTable {
            return mSalespersonTransactionData.count
            
        }
        return mCustomerTransactionData.count
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        let cells = UITableViewCell()
        if tableView == TransactionTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SalesPersonTableCell") as? SalesPersonTableCell,
                  let mData = mSalespersonTransactionData[indexPath.row] as? NSDictionary else {
                return UITableViewCell()
            }
            
            
            cell.mCustomerName.text = "\(mData.value(forKey: "customer_name") ?? "--")"
            cell.mType.text = "\(mData.value(forKey: "order_no") ?? "--")"
            cell.mMobile.text = "\(mData.value(forKey: "customer_country") ?? "--")," + "\(mData.value(forKey: "customer_mobile") ?? "--")"
            cell.mDate.text = "\(mData.value(forKey: "date") ?? "--")"
            
            cell.mCustomerImage.contentMode = .scaleAspectFill
            cell.mCustomerImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "customer_profile") ?? "")")
            if let mCart = mData.value(forKey: "items") as? NSArray {
                if mCart.count > 0 {
                    cell.mCartData = mCart
                    cell.mParkItemsTable.delegate = cell
                    cell.mParkItemsTable.dataSource = cell
                    cell.mParkItemsTable.reloadData()
                    cell.mParkItemsTable.layoutIfNeeded()
                    cell.mParkItemsTable.isHidden = false
                    cell.mTableHeight.constant = cell.mParkItemsTable.contentSize.height
                }else{
                    cell.mParkItemsTable.isHidden = true
                    cell.mTableHeight.constant = 0
                    
                }
                
            }else{
                cell.mParkItemsTable.isHidden = true
                cell.mTableHeight.constant = 0
                
            }
            
            return cell
            
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell,
            let mData = mCustomerTransactionData[indexPath.row] as? NSDictionary else {
                return UITableViewCell()
            }
            
            cell.mTotalAmountLABEL.text = "Total Amount".localizedString
            cell.mTotalInvoiceLABEL.text = "Total Invoice".localizedString
            cell.mTotalQuantityLABEL.text = "Total Quantity".localizedString
            
            cell.mCustomerImage.contentMode = .scaleAspectFill
            
            cell.mCustomerName.text = "\(mData.value(forKey: "customer_name") ?? "--")"
            cell.mPrice.text = "\(mData.value(forKey: "total_amount") ?? "--")"
            cell.mAddressMobile.text = "\(mData.value(forKey: "customer_country") ?? "--")," + "\(mData.value(forKey: "customer_mobile") ?? "--")"
            cell.mTotalQuantity.text = "\(mData.value(forKey: "total_qty") ?? "--")"
            cell.mTotalInvoice.text = "\(mData.value(forKey: "total_invoice") ?? "--")"
            cell.mCustomerImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "customer_profile") ?? "")")
            
            
            
            
            return cell
        }
        
        
        return cells
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == mCustomerTable {
            return 180
        }
        return 100
    }
    
}
