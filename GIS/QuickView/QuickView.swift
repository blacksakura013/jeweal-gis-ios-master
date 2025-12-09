//
//  QuickViewViewController.swift
//  GIS
//
//  Created by Apple Hawkscode on 04/01/22.
//

import UIKit
import Alamofire
class ReserveOrderCell : UITableViewCell {
    
    @IBOutlet weak var mLocationName: UILabel!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mQuantity: UILabel!
    @IBOutlet weak var mAmount: UILabel!
    @IBOutlet weak var mStockName: UILabel!
    @IBOutlet weak var mStockId: UILabel!
    @IBOutlet weak var mCheckIcon: UIImageView!
    @IBOutlet weak var mStatusDot: UILabel!
    @IBOutlet weak var mStatusDotView: UIView!
    
}

class QuickViewLocationCell : UITableViewCell {
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mCheckIcon: UIImageView!
    @IBOutlet weak var mLocationName: UILabel!
    @IBOutlet weak var mQuantity: UILabel!
}

class QuickView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , UITableViewDelegate, UITableViewDataSource, GetCustomerDataDelegate, UIViewControllerTransitioningDelegate {
    
    /**Bottom ReserveOrder View*/
    var mSiriID: String?
    @IBOutlet weak var mParentView: UIView!
    
    @IBOutlet weak var mReserveOrderListView: UIView!
    @IBOutlet weak var mItemsTableView: UITableView!
    
    @IBOutlet weak var mListType: UILabel!
    
    @IBOutlet weak var mLocation: UILabel!
    var mReserveOrderData = NSArray()
    var mReserveData = NSMutableArray()
    var mCurrentLocation = ""
    @IBOutlet weak var mConfirmButton: UIButton!
    
    @IBOutlet weak var mStoneViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mLocationTableView: UITableView!
    @IBOutlet weak var mSearchField: UITextField!
    @IBOutlet weak var mProductCollectionView: UICollectionView!
    @IBOutlet weak var mPageController: UIPageControl!
    @IBOutlet weak var mProductName: UITextView!
    @IBOutlet weak var mStockIdName: UILabel!
    @IBOutlet weak var mSelectAllBUTTON: UIButton!
    
    @IBOutlet weak var mBottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mReserveOrderView: UIView!
    
    @IBOutlet weak var mOrderButton: UIButton!
    @IBOutlet weak var mReserveButton: UIButton!
    @IBOutlet weak var mLocationCount: UILabel!
    @IBOutlet weak var mStoneCollectionView: UICollectionView!
    @IBOutlet weak var mMetalCollectionView: UICollectionView!
    @IBOutlet weak var mSizeCollectionView: UICollectionView!
    @IBOutlet weak var mMetalLABEL: UILabel!
    @IBOutlet weak var mStoneLABEL: UILabel!
    @IBOutlet weak var mSizeLABEL: UILabel!
    @IBOutlet weak var mLocaitonLABEL: UILabel!
    
    @IBOutlet weak var mSwitchIcon: UIImageView!
    var mSearchType = "inventory"
    var mMetalsData = NSArray()
    var mSelectedItems = NSArray()
    
    var mSelectedRows = [String]()
    
    var mMetalsId = [String]()
    
    var mStonesData = NSArray()
    var mStonesId = [String]()
    
    var mLocationsData = NSArray()
    var mLocationsId = [String]()
    
    var mSizeData = NSArray()
    var mSizeId = [String]()
    
    var mFilterData = NSMutableDictionary()
    
    var mImageData = [String]()
    
    var mType = ""
    var mSKUName = ""
    var mSKUDetails = ""
    var mStockIds = ""
    
    @IBOutlet weak var mHeading: UILabel!
    var mProductIds = [String]()
    var mCustomerId = ""
    @IBOutlet weak var mLocationViewHeight: NSLayoutConstraint!
    
    var mProductIdForImage = ""
    
    //new imageview
    
    @IBOutlet weak var sPreviewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        mSearchField.text = mSKUName
        mProductName.text = mSKUDetails
        mStockIdName.text = mSKUName
        mPageController.numberOfPages =  mImageData.count
        self.mProductCollectionView.isPagingEnabled = false
        self.mProductCollectionView.decelerationRate = .fast
        self.mProductCollectionView.delegate = self
        self.mProductCollectionView.dataSource = self
        self.mMetalCollectionView.delegate = self
        self.mMetalCollectionView.dataSource = self
        self.mSizeCollectionView.delegate = self
        self.mSizeCollectionView.dataSource = self
        self.mStoneCollectionView.delegate = self
        self.mStoneCollectionView.dataSource = self
        self.mLocationTableView.delegate = self
        self.mLocationTableView.dataSource = self
        mReserveOrderView.layer.cornerRadius = 10
        mReserveOrderView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        mReserveOrderView.dropShadow()
        mReserveOrderListView.layer.cornerRadius = 20
        mReserveOrderListView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        mReserveOrderListView.dropShadow()
        mReserveOrderListView.isHidden =  true
        
    }
    
    @IBAction func mBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mViewImage(_ sender: Any) {
        if mProductIdForImage != "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
            if let mGlobalImageViewer = storyBoard.instantiateViewController(withIdentifier: "GlobalImageViewer") as? GlobalImageViewer {
                mGlobalImageViewer.modalPresentationStyle = .overFullScreen
                mGlobalImageViewer.mProductId = mProductIdForImage
                mGlobalImageViewer.mSKUName = mSKUName
                mGlobalImageViewer.transitioningDelegate = self
                self.present(mGlobalImageViewer,animated: false)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mGetQuickView()
        mSelectAllBUTTON.setTitleColor(#colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1), for: .normal)
        mSelectAllBUTTON.setTitleColor(#colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1), for: .selected)
        
        mReserveButton.setTitle("RESERVE".localizedString, for: .normal)
        mOrderButton.setTitle("ORDER".localizedString, for: .normal)
        mConfirmButton.setTitle("CONFIRM".localizedString, for: .normal)
        mSelectAllBUTTON.setTitle("Select All".localizedString, for: .normal)
        mMetalLABEL.text = "Metal".localizedString
        mStoneLABEL.text = "Stone".localizedString
        mSizeLABEL.text = "Size".localizedString
        mHeading.text = "Quick View".localizedString
        mSearchField.placeholder = "Search by SKU / Stock Id".localizedString
        
        //setPreviewImage
        if mImageData.count > 0 {
            sPreviewImage.downlaodImageFromUrl(urlString: self.mImageData[0])
        }
    }
    
    
    
    
    @IBAction func mSwitchInvCatlog(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            
            self.mMetalsId.removeAll()
            self.mStonesId.removeAll()
            self.mLocationsId.removeAll()
            self.mSizeId.removeAll()
            self.mMetalsData = NSArray()
            self.mStonesData = NSArray()
            self.mLocationsData = NSArray()
            self.mSizeData = NSArray()
            
            mSearchType = "catalog"
            mSwitchIcon.image = UIImage(named: "quickViewCat")
            
            mGetQuickView()
        }else{
            mSearchType = "inventory"
            self.mMetalsId.removeAll()
            self.mStonesId.removeAll()
            self.mLocationsId.removeAll()
            self.mSizeId.removeAll()
            self.mMetalsData = NSArray()
            self.mStonesData = NSArray()
            self.mLocationsData = NSArray()
            self.mSizeData = NSArray()
            
            
            mSwitchIcon.image = UIImage(named: "quickViewInv")
            mGetQuickView()
            
        }
    }
    
    @IBAction func mOrderNow(_ sender: Any) {
        mSelectedRows = [String]()
        
        if mSearchType == "inventory" {
            mGetInventory(type:"Order")
            return
        }
        CommonClass.showFullLoader(view: self.view)
        let params:[String: Any] = ["ids" :mProductIds]
        
        mGetData(url: mAllGetCatalogItems,headers: sGisHeaders,  params: params) { response , status in
            CommonClass.stopLoader()
            if status {
                if "\(response.value(forKey: "code") ?? "")" == "200" {
                    if let mData = response.value(forKey: "data") as? NSArray {
                        
                        self.mReserveOrderData = mData
                        
                        self.mParentView.isHidden = false
                        self.mReserveOrderListView.isHidden =  false
                        self.mReserveOrderListView.slideFromBottom()
                        
                        if self.mSearchType == "inventory" {
                            self.mListType.text = "Reserve"
                            self.mLocation.text = ""
                        }else{
                            self.mListType.text = "Catalog"
                            self.mLocation.text = ""
                        }
                        
                        self.mItemsTableView.delegate = self
                        self.mItemsTableView.dataSource = self
                        self.mItemsTableView.reloadData()
                        
                    }
                    
                }else{
                    
                }
            }
        }
    }
    
    @IBAction func mReserveNow(_ sender: Any) {
        
        mSelectedRows = [String]()
        mGetInventory(type:"")
        
    }
    
    func mGetInventory(type: String){
        CommonClass.showFullLoader(view: self.view)
        let params:[String: Any] = ["search" : mSKUName, "metal": mMetalsId, "size": mSizeId, "stone":mStonesId, "location":mLocationsId, "type":mSearchType]
        
        mGetData(url: mGetQuickViewOrderReserveData,headers: sGisHeaders,  params: params) { response , status in
            CommonClass.stopLoader()
            if status {
                if let code = response.value(forKey: "code") as? Int {
                    
                    switch code {
                    case 200:
                        if let mData = response.value(forKey: "data") as? NSArray {
                            
                            self.mReserveOrderData = mData
                            
                            self.mParentView.isHidden = false
                            self.mReserveOrderListView.isHidden =  false
                            self.mReserveOrderListView.slideFromBottom()
                            
                            if !type.isEmpty {
                                self.mListType.text = "Inventory"
                                self.mLocation.text = ""
                            }else{
                                self.mListType.text = "Reserve"
                                self.mLocation.text = ""
                            }
                            
                            self.mItemsTableView.delegate = self
                            self.mItemsTableView.dataSource = self
                            self.mItemsTableView.reloadData()
                            
                        }
                        break
                    case 403:
                        CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                        break
                    default:
                        let errorMessage = response.value(forKey: "message") as? String ?? "An error occurred."
                        CommonClass.showSnackBar(message: "Error \(code): \(errorMessage)")
                        break
                    }
                } else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                }
            }
        }
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
        }
    }
    
    func mOpenCustomerPopup(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
            home.delegate = self
            home.modalPresentationStyle = .automatic
            home.transitioningDelegate = self
            self.present(home,animated: true)
        }
    }
    
    @IBAction func mConfirmButt(_ sender: Any) {
        if mSelectedRows.isEmpty {
            CommonClass.showSnackBar(message: "Please select items.")
            return
        }
        
        if mSearchType == "inventory" {
            
            if self.mListType.text == "Inventory" {
                
                if mCustomerId == "" {
                    mOpenCustomerPopup()
                    return
                }
                
                let mParams = ["product_id":self.mSelectedRows, "customer_id":mCustomerId, "sales_person_id":"", "type":mSearchType, "order_type":"custom_order"] as [String : Any]
                
                mGetData(url: mAddCustomProduct,headers: sGisHeaders,  params: mParams) { response , status in
                    CommonClass.stopLoader()
                    if status {
                        if "\(response.value(forKey: "code") ?? "")" == "200" {
                            let storyBoard: UIStoryboard = UIStoryboard(name: "customOrder", bundle: nil)
                            if let mCustomCart = storyBoard.instantiateViewController(withIdentifier: "CustomCart") as? CustomCart {
                                self.navigationController?.pushViewController(mCustomCart, animated:true)
                            }
                        }else{
                            
                        }
                    }
                }
            }else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "reserveBoard", bundle: nil)
                if let mInventoryPage = storyBoard.instantiateViewController(withIdentifier: "InventoryReserveCart") as? InventoryReserveCart {
                    mInventoryPage.mOriginalData = NSArray(array: mReserveData)
                    self.navigationController?.pushViewController(mInventoryPage, animated:true)
                }
            }
            
            
        }else{
            
            if mCustomerId == "" {
                mOpenCustomerPopup()
                return
            }
            
            let mParams = ["product_id":self.mSelectedRows, "customer_id":mCustomerId, "sales_person_id":"", "type":mSearchType, "order_type":"custom_order"] as [String : Any]
            
            
            mGetData(url: mAddCustomProduct,headers: sGisHeaders,  params: mParams) { response , status in
                CommonClass.stopLoader()
                if status {
                    if "\(response.value(forKey: "code") ?? "")" == "200" {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "customOrder", bundle: nil)
                        if let mCustomCart = storyBoard.instantiateViewController(withIdentifier: "CustomCart") as? CustomCart {
                            self.navigationController?.pushViewController(mCustomCart, animated:true)
                        }
                    }else{
                        
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func mHideBottomSheet(_ sender: Any) {
        self.mParentView.isHidden = true
        self.mReserveOrderListView.isHidden =  true
        
    }
    @IBAction func mSearchNow(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "QuickViewSearch") as? QuickViewSearch {
            home.mType = "Quick View"
            self.navigationController?.pushViewController(home, animated:true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        
        if collectionView == self.mMetalCollectionView {
            count = mMetalsData.count
            
        } else if collectionView == self.mStoneCollectionView {
            count = mStonesData.count
            
            
        }else if collectionView == self.mSizeCollectionView {
            count = mSizeData.count
            
            
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if collectionView == self.mMetalCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "MetalCell", for: indexPath) as? MetalCell,
                  let mData = mMetalsData[indexPath.row] as? NSDictionary else {
                return cell
            }
            cells.mMetalName.text = mData.value(forKey: "name") as? String
            
            if "\(mData.value(forKey: "select") ?? "")" == "0" {
                
                cells.mMetalName.backgroundColor =  #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
                cells.backgroundColor =  #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
                cells.mMetalName.textColor = #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)
                
            }else{
                cells.mMetalName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                if "\(mData.value(forKey: "exsits") ?? "")" == "0" {
                    cells.backgroundColor =  #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                    cells.mMetalName.backgroundColor =  #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                }else{
                    cells.mMetalName.backgroundColor =  #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1)
                    cells.backgroundColor =  #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1)
                }
                
            }
            
            cells.layoutSubviews()
            cell = cells
            
        }else if collectionView == self.mSizeCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath) as? SizeCell,
                  let mData = mSizeData[indexPath.row] as? NSDictionary else {
                return cell
            }
            
            cells.mSizeName.text = mData.value(forKey: "name") as? String
            
            if "\(mData.value(forKey: "select") ?? "")" == "0" {
                cells.backgroundColor =  #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
                cells.mSizeName.backgroundColor =  #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
                cells.mSizeName.textColor = #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)
            }else{
                cells.mSizeName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                if "\(mData.value(forKey: "exsits") ?? "")" == "0" {
                    cells.mSizeName.backgroundColor =  #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                    cells.backgroundColor =  #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                }else{
                    cells.mSizeName.backgroundColor =  #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1)
                    cells.backgroundColor =  #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1)
                }
            }
            
            cells.layoutSubviews()
            cell = cells
            
        }else if collectionView == self.mStoneCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "StoneCell", for: indexPath) as? StoneCell,
                  let mData =  mStonesData[indexPath.row] as? NSDictionary else {
                return cell
            }
            
            cells.mCStone.text = mData.value(forKey: "name") as? String
            
            if "\(mData.value(forKey: "select") ?? "")" == "0" {
                cells.backgroundColor =  #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
                cells.mCStone.backgroundColor =  #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
                cells.mCStone.textColor = #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)
            }else{
                cells.mCStone.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                if "\(mData.value(forKey: "exsits") ?? "")" == "0" {
                    cells.backgroundColor =  #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                    cells.mCStone.backgroundColor =  #colorLiteral(red: 0.8078431373, green: 0.9333333333, blue: 0.9254901961, alpha: 1)
                }else{
                    cells.backgroundColor =  #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1)
                    cells.mCStone.backgroundColor =  #colorLiteral(red: 0.3607843137, green: 0.7803921569, blue: 0.7568627451, alpha: 1)
                }
                
            }
            
            cells.layoutSubviews()
            cell = cells
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.mStoneCollectionView {
            
            if let mData = mStonesData[indexPath.row] as? NSDictionary {
                
                if "\(mData.value(forKey: "select") ?? "")" == "1" {
                    if let id = mData.value(forKey: "id") as? String {
                        if mStonesId.contains(id) {
                            mStonesId = mStonesId.filter {$0 != id }
                        }else{
                            mStonesId.append(id)
                        }
                    }
                    if mSearchType == "inventory" {
                       // self.mMetalsId.removeAll()
                        self.mSizeId.removeAll()
                    }
                    mGetQuickView()
                }
            }
        }
        
        
        if collectionView == self.mMetalCollectionView {
            
            if let mData = mMetalsData[indexPath.row] as? NSDictionary {
                if "\(mData.value(forKey: "select") ?? "")" == "1" {
                    if let id = mData.value(forKey: "id") as? String {
                        if mMetalsId.contains(id) {
                            mMetalsId = mMetalsId.filter {$0 != id }
                        }else{
                            mMetalsId.append(id)
                        }
                    }
                    if mSearchType == "inventory" {
                        self.mStonesId.removeAll()
                        self.mSizeId.removeAll()
                    }
                    mGetQuickView()
                }
            }
        }
        
        if collectionView == self.mSizeCollectionView {
            
            if let mData = mSizeData[indexPath.row] as? NSDictionary {
                if "\(mData.value(forKey: "select") ?? "")" == "1" {
                    if let id = mData.value(forKey: "id") as? String {
                        if mSizeId.contains(id) {
                            mSizeId = mSizeId.filter {$0 != id }
                        }else{
                            mSizeId.append(id)
                        }
                    }
                    
                    if mSearchType == "inventory" {
                        //self.mMetalsId.removeAll()
                        //self.mStonesId.removeAll()
                    }
                    mGetQuickView()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == mItemsTableView {
            return mReserveOrderData.count
        }
        return mLocationsData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        var cell = UITableViewCell()
        
        if tableView == mItemsTableView {
            if let  cells = tableView.dequeueReusableCell(withIdentifier: "ReserveOrderCell") as? ReserveOrderCell {
                
                if let mData = mReserveOrderData[indexPath.row] as? NSDictionary {
                    
                    let statusProperties: [String: (textColor: UIColor, backgroundColor: UIColor, statusText: String)] = [
                        "stock": (#colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1), #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1), "Stock"),
                        "reserve": (#colorLiteral(red: 1, green: 0.7386777401, blue: 0.3924969435, alpha: 1), #colorLiteral(red: 1, green: 0.7386777401, blue: 0.3924969435, alpha: 1), "Reserved"),
                        "custom_order": (#colorLiteral(red: 0.9137254902, green: 0.4392156863, blue: 0.4392156863, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.4392156863, blue: 0.4392156863, alpha: 1), "Reserved"),
                        "repair_order": (#colorLiteral(red: 0.662745098, green: 0.6078431373, blue: 0.7411764706, alpha: 1), #colorLiteral(red: 0.662745098, green: 0.6078431373, blue: 0.7411764706, alpha: 1), "Repair"),
                        "warehouse": (#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), "Warehouse"),
                        "transit": (#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), "Transit")
                    ]
                    
                    if mSearchType == "inventory" {
                      
//                        if let statusType = mData.value(forKey: "status_type") as? String,
//                           let status = statusProperties[statusType] {
//                             
//                            cells.mStatusDot.backgroundColor = status.backgroundColor
//                        } else {
//                            
//                            cells.mStatusDotView.isHidden = true
//                        }
                        
                        if let statusType = mData.value(forKey: "status_type") as? String {
                            
                            if let status = statusProperties[statusType] {
                                cells.mStatusDot.backgroundColor = status.backgroundColor
                                cells.mStatusDotView.isHidden = false
                            } else {
                                cells.mStatusDotView.isHidden = true
                            }
                        } else {
                            cells.mStatusDotView.isHidden = true
                        }
                        cells.mStockName.text  = "\(mData.value(forKey: "SKU") ?? "--")"
                        cells.mStockId.text  = "\(mData.value(forKey: "stock_id") ?? "--")"
                        cells.mQuantity.text  = "\(mData.value(forKey: "po_QTY") ?? "--")"
                        cells.mAmount.text  = "\(mData.value(forKey: "formattedPrice") ?? "--")"
                        cells.mLocationName.text  = "\(mData.value(forKey: "location_name") ?? "--")"
                        cells.mStockId.isHidden = false
                        cells.mQuantity.isHidden = false
                        cells.mLocationName.isHidden = false
                        
                        if let id = mData.value(forKey: "po_product_id") as? String {
                            if mSelectedRows.contains(id) {
                                cells.mCheckIcon.image = UIImage(named: "check_item")
                            }else{
                                cells.mCheckIcon.image = UIImage(named: "uncheck_item")
                            }
                        }
                    }else{
                        
                        if let statusType = mData.value(forKey: "status_type") as? String,
                           let status = statusProperties[statusType] {
                            cells.mStatusDot.backgroundColor = status.backgroundColor
                        } else {
                            cells.mStatusDotView.isHidden = true
                        }
                        cells.mStockName.text  = "\(mData.value(forKey: "SKU") ?? "--")"
                        cells.mStockId.isHidden = true
                        cells.mQuantity.isHidden = true
                        cells.mAmount.text  = "\(mData.value(forKey: "price") ?? "--")"
                        cells.mLocationName.isHidden = true
                        
                        if let id = mData.value(forKey: "id") as? String , mSelectedRows.contains(id) {
                            cells.mCheckIcon.image = UIImage(named: "check_item")
                        }else{
                            cells.mCheckIcon.image = UIImage(named: "uncheck_item")
                        }
                        
                    }
                    
                    if (indexPath.row % 2 == 0) {
                        cells.mView.backgroundColor = UIColor(named: "themeBackground")
                    }else{
                        cells.mView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
                        
                    }
                    
                    cells.layoutSubviews()
                }
                cell = cells
            }
        }else {
            
            guard let  cells = tableView.dequeueReusableCell(withIdentifier: "QuickViewLocationCell") as? QuickViewLocationCell,
                  let mData = mLocationsData[indexPath.row] as? NSDictionary else {
                return cell
            }
            
            cells.mView.backgroundColor = UIColor(named: "themeBackground")
            
            cells.mLocationName.text = mData.value(forKey: "name") as? String
            
            cells.mQuantity.text = "\(mData.value(forKey: "qty") ?? "0")"
            
            cells.mLocationName.backgroundColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            cells.mQuantity.backgroundColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            if "\(mData.value(forKey: "qty") ?? "1")" == "0" {
                
                cells.mLocationName.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                cells.mQuantity.textColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                
            }else{
                cells.mQuantity.textColor = UIColor(named: "themeColor")
                cells.mLocationName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
            if mSearchType == "inventory" {
                if mLocationsId.isEmpty {
                    mBottomViewHeight.constant = 0
                    mReserveButton.isHidden = true
                    mOrderButton.isHidden = true
                }else{
                    mBottomViewHeight.constant = 120
                    mReserveButton.isHidden = false
                    mOrderButton.isHidden = false
                }
            }
            
            if let id = mData.value(forKey: "id") as? String ,mLocationsId.contains(id) {
                cells.mCheckIcon.image = UIImage(named: "check_item")
            }else{
                cells.mCheckIcon.image = UIImage(named: "uncheck_item")
            }
            
            cells.layoutSubviews()
            cell = cells
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == mItemsTableView {
            
            if let mData = mReserveOrderData[indexPath.row] as? NSDictionary {
                
                if mSearchType == "inventory" {
                    
                    guard let poProductId = mData.value(forKey: "po_product_id") as? String else {
                        return
                    }
                    if poProductId == "0" {
                        return
                    }
                    
                    if mSelectedRows.contains(poProductId) {
                        mSelectedRows = mSelectedRows.filter {$0 != poProductId }
                        
                        if let mInvData = mReserveOrderData[indexPath.row] as? NSDictionary {
                            
                            let mData = NSMutableDictionary()
                            mData.setValue("\(mInvData.value(forKey: "po_product_id") ?? "")", forKey: "id")
                            mData.setValue("1", forKey: "quantity")
                            mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "0")", forKey: "po_QTY")
                            mData.setValue("\(mInvData.value(forKey: "SKU") ?? "")", forKey: "sku")
                            mData.setValue("\(mInvData.value(forKey: "stock_id") ?? "")", forKey: "stockId")
                            mData.setValue("\(mInvData.value(forKey: "formattedPrice") ?? "")", forKey: "formattedPrice")
                            mData.setValue("\(mInvData.value(forKey: "price") ?? "")", forKey: "price")
                            mData.setValue("\(mInvData.value(forKey: "Matatag") ?? "")", forKey: "Matatag")
                            mData.setValue("\(mInvData.value(forKey: "main_image") ?? "")", forKey: "image")
                            mData.setValue("\(mInvData.value(forKey: "metal_name") ?? "")", forKey: "metal")
                            mData.setValue("\(mInvData.value(forKey: "size_name") ?? "")", forKey: "size")
                            let currentDateTime = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "MM/dd/yyy"
                            mData.setValue("\(formatter.string(from: currentDateTime))", forKey: "dueDate")
                            mData.setValue("", forKey: "notes")
                            mReserveData.remove(mData)
                        }
                    }else{
                        
                        mSelectedRows.append(poProductId)
                        
                        if let mInvData = mReserveOrderData[indexPath.row] as? NSDictionary {
                            let mData = NSMutableDictionary()
                            mData.setValue("\(mInvData.value(forKey: "po_product_id") ?? "")", forKey: "id")
                            mData.setValue("1", forKey: "quantity")
                            mData.setValue("\(mInvData.value(forKey: "po_QTY") ?? "0")", forKey: "po_QTY")
                            mData.setValue("\(mInvData.value(forKey: "SKU") ?? "")", forKey: "sku")
                            mData.setValue("\(mInvData.value(forKey: "stock_id") ?? "")", forKey: "stockId")
                            mData.setValue("\(mInvData.value(forKey: "price") ?? "0.0")", forKey: "price")
                            mData.setValue("\(mInvData.value(forKey: "formattedPrice") ?? "")", forKey: "formattedPrice")
                            mData.setValue("\(mInvData.value(forKey: "Matatag") ?? "")", forKey: "Matatag")
                            mData.setValue("\(mInvData.value(forKey: "main_image") ?? "")", forKey: "image")
                            mData.setValue("\(mInvData.value(forKey: "metal_name") ?? "")", forKey: "metal")
                            mData.setValue("\(mInvData.value(forKey: "size_name") ?? "")", forKey: "size")
                            let currentDateTime = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "MM/dd/yyy"
                            mData.setValue("\(formatter.string(from: currentDateTime))", forKey: "dueDate")
                            mData.setValue("", forKey: "notes")
                            mReserveData.add(mData)
                        }
                    }
                }else{
                    if let id = mData.value(forKey: "id") as? String {
                        if mSelectedRows.contains(id) {
                            mSelectedRows = mSelectedRows.filter {$0 != id }
                        }else{
                            mSelectedRows.append(id)
                        }
                    }
                }
                
                self.mItemsTableView.reloadData()
                
                return
            }
        }
        
        
        if let mData = mLocationsData[indexPath.row] as? NSDictionary {
            if "\(mData.value(forKey: "qty") ?? "0")" == "0" {
                return
            }
            if let id = mData.value(forKey: "id") as? String {
                if mLocationsId.contains(id) {
                    mLocationsId = mLocationsId.filter {$0 != id }
                }else{
                    mLocationsId.append(id)
                }
            }
            self.mLocationTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == mItemsTableView {
            return 60
        }
        return 43
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.mProductCollectionView {
            var currentCellOffset = self.mProductCollectionView.contentOffset
            currentCellOffset.x += self.mProductCollectionView.frame.width / 2
            if let indexPath = self.mProductCollectionView.indexPathForItem(at: currentCellOffset) {
                self.mPageController.currentPage = indexPath.row
                self.mProductCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let numberOfSets = CGFloat(1)
        
        let width = (collectionView.frame.size.width - (numberOfSets * view.frame.size.width / 15))/numberOfSets
        
        let height = collectionView.frame.size.height - 32
        
        return CGSize(width: width, height: height)
    }
    
    
    
    @IBAction func mClearAllFilters(_ sender: Any) {
        
        
        self.mMetalsId.removeAll()
        self.mStonesId.removeAll()
        self.mLocationsId.removeAll()
        self.mSizeId.removeAll()
        
        mGetQuickView()
        
        
        
    }
    
    @IBAction func mSelectAll(_ sender: UIButton) {
        mMetalsId.removeAll()
        mSizeId.removeAll()
        mStonesId.removeAll()
        mGetQuickView()
    }
    
    func mGetQuickView(){
        mReserveData = NSMutableArray()
        
        
        var mUrl = ""
        var params = [String: Any]()
        if mSearchType == "catalog" {
            mUrl =  mGetQuickViewCatalogData
            params = ["search": mSKUName ,"metal": self.mMetalsId, "stone": self.mStonesId,"size": self.mSizeId,  "type": mSearchType] as [String : Any]
            
        }else{
            mUrl = mGetQuickViewData
            params = ["search": mSKUName ,"metal": self.mMetalsId, "stone": self.mStonesId,"size": self.mSizeId,  "type": mSearchType] as [String : Any]
        }
        
        
        if Reachability.isConnectedToNetwork() == true {
            CommonClass.showFullLoader(view: self.view)
            AF.request(mUrl, method:.post,parameters: params,encoding: JSONEncoding.default, headers: sGisHeaders).responseJSON
            { response in
                
                CommonClass.stopLoader()
                if(response.error != nil){
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                }else{
                    guard let jsonData = response.data else {
                        CommonClass.showSnackBar(message: "OOP's something went wrong!")
                        return
                    }

                    let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                    
                    guard let jsonResult = json as? NSDictionary else {
                        CommonClass.showSnackBar(message: "OOP's something went wrong!")
                        return
                    }
                    
                    if let mCode =  jsonResult.value(forKey: "code") as? Int {
                        if mCode == 403 {
                            CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                            return
                        }
                    }
                    
                    if jsonResult.value(forKey: "code") as? Int == 200 {
                        
                        self.mBottomViewHeight.constant = 0
                        self.mReserveButton.isHidden = true
                        self.mOrderButton.isHidden = true
                        
                        if jsonResult.value(forKey: "productList") == nil {
                            CommonClass.showSnackBar(message: "No Data Found!")
                            return
                        }
                        
                        if let mData = jsonResult.value(forKey: "productList") as? NSDictionary {
                            self.mLocationCount.text = "(\(mData.value(forKey: "total_qty") ?? "0"))"
                            
                            if let mMetal = mData.value(forKey: "metal") as? NSArray {
                                if mMetal.count > 0 {
                                    self.mMetalsData = mMetal
                                    self.mMetalCollectionView.reloadData()
                                }else{
                                    self.mMetalCollectionView.reloadData()
                                }
                            }

                            if let mStone = mData.value(forKey: "Stone") as? NSArray {
                                if mStone.count > 0 {
                                    self.mStonesData = mStone
                                    self.mStoneCollectionView.reloadData()
                                    self.mStoneCollectionView.layoutIfNeeded()
                                    //self.mStoneViewHeight.constant = self.mStoneCollectionView.contentSize.height + 60

                                }else{
                                    self.mStoneCollectionView.reloadData()
                                    
                                }
                            }
                            
                            if let mSized = mData.value(forKey: "size") as? NSArray {
                                if mSized.count > 0 {
                                    self.mSizeData = mSized
                                    self.mSizeCollectionView.reloadData()
                                }else{
                                    self.mSizeCollectionView.reloadData()
                                    
                                }
                            }
                            
                            if let mProductId = mData.value(forKey: "product_ids") as? [String] {
                                self.mProductIds = mProductId
                                
                                self.mBottomViewHeight.constant = 120
                                self.mReserveButton.isHidden = true
                                self.mOrderButton.isHidden = false
                                
                            }else{
                                self.mProductIds = [String]()
                            }
                            
                            self.mLocationsId = [String]()
                            self.mLocationsData = NSArray()
                            
                            if let mLocation = mData.value(forKey: "lcoation") as? NSArray {
                                
                                if mLocation.count > 0 {
                                    let finalLocations = NSMutableArray()
                                    for obj in mLocation {
                                        if let item = obj as? NSDictionary, let qty = item.value(forKey: "qty") as? Int, qty != 0 {
                                            finalLocations.add(obj)
                                        }
                                    }
                                    
                                    self.mLocationsData = finalLocations as NSArray
                                    
                                    self.mLocationTableView.reloadData()
                                    self.mLocationTableView.layoutIfNeeded()
                                    self.mLocationViewHeight.constant = self.mLocationTableView.contentSize.height + 60
                                    
                                }else{
                                    self.mLocationTableView.reloadData()
                                    
                                }
                            }
                        }
                        self.mLocationTableView.reloadData()
                        
                    }else{
                        if let error = jsonResult.value(forKey: "error") as? String{
                            if error == "Authorization has been expired" {
                                CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                            }
                        }
                    }
                    
                }
                
                
            }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
        }
        
        
    }
}
