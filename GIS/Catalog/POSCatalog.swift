//
//  POSCatalog.swift
//  GIS
//
//  Created by Apple Hawkscode on 25/03/21.
//

import UIKit
import Alamofire
import UIDrawer


public class CustomerSearchItem: UITableViewCell {
    
    @IBOutlet weak var mCustomerName: UILabel!
    @IBOutlet weak var mPlace: UILabel!
    
    @IBOutlet weak var mCustomerImage: UIImageView!
    @IBOutlet weak var mPhone: UILabel!
    @IBOutlet weak var mView: UIView!
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

class CatalogCell :UICollectionViewCell {
    
    @IBOutlet weak var mDesignStatusView: UIView!
    @IBOutlet weak var mHeart: UIImageView!
    @IBOutlet weak var mDiamondStatus: UIImageView!
    @IBOutlet weak var mProductLikeButt: UIButton!
    @IBOutlet weak var mProductImage: UIImageView!
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var mProductName: UITextView!
    @IBOutlet weak var mStackView: UIStackView!
    @IBOutlet weak var mAddtoCart: UIButton!
    @IBOutlet weak var mStatusDot: UILabel!
}



class POSCatalog: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UITableViewDelegate ,UITableViewDataSource , RangeSeekSliderDelegate, GetCustomerDataDelegate,GetInventoryFiltersDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var mSubFilterView: UIView!
    
    @IBOutlet weak var mApplyFilterView: UIView!
    @IBOutlet weak var mFilterView: UIView!
    
    
    @IBOutlet weak var mItemCollectionView: UICollectionView!
    @IBOutlet weak var mCollectCollectionView: UICollectionView!
    @IBOutlet weak var mStoneCollectionView: UICollectionView!
    @IBOutlet weak var mMetalCollectionView: UICollectionView!
    @IBOutlet weak var mLocationCollectionView: UICollectionView!
    
    @IBOutlet weak var mSizeCollectionView: UICollectionView!
    
    @IBOutlet weak var mPriceRange: RangeSeekSlider!
    
    @IBOutlet weak var mCustomerImage: UIImageView!
    
    @IBOutlet weak var mMinPrice: UILabel!
    
    @IBOutlet weak var mMaxPrice: UILabel!
    
    
    var mItemsData = NSArray()
    var mItemsId = [String]()
    
    var mCollectionData = NSArray()
    var mCollectionId = [String]()
    
    var mMetalsData = NSArray()
    var mMetalsId = [String]()
    
    var mStonesData = NSArray()
    var mStonesId = [String]()
    
    var mLocationsData = NSArray()
    var mLocationsId = [String]()
    
    var mSizeData = NSArray()
    var mSizeId = [String]()
    var mStatusId = [String]()
    
    var mMinPrices = ""
    var mMaxPrices = ""
    var mFilterData = NSMutableDictionary()
    var SiriID = "" 
    
     
    @IBOutlet weak var mCustomerSearch: UITextField!
    var mCustomerSearchTableView = UITableView()
    @IBOutlet weak var mCustomerSearchView: UIView!
    @IBOutlet weak var mCustomerDetailView: UIView!
    @IBOutlet weak var mCustomerNames: UILabel!
    @IBOutlet weak var mCustomerAddresss: UILabel!
    @IBOutlet weak var mCustomerNumbers: UILabel!
    
    var mSearchCustomerData = NSArray()
    var mSalesManList = [String]()
    var mSalesManIDList = [String]()
    var mCustomerId = ""
    var mSalesPersonId = ""
    
    var mCustomerName = ""
    var mCustomerAddress = ""
    var mCustomerNumber = ""
    
    var mSearchType = "catalog"
    var isWishlist = "0"
    
    @IBOutlet weak var mCheckUncheckCustomer: UIImageView!
    @IBOutlet weak var mBackView: UIView!
    @IBOutlet weak var mCatalogCollectionView: UICollectionView!
    
    @IBOutlet weak var mChooseCutomerButton: UIButton!
    @IBOutlet weak var mSearchField: UITextField!
    
    @IBOutlet weak var mSearchView: UIView!
    
    @IBOutlet weak var mLeftView: UIView!
    @IBOutlet weak var mRightView: UIView!
    var mCount = 1
    @IBOutlet weak var mPageNo: UILabel!
    var mCatalogData = NSMutableArray()
    
    var mKey = ""
    var mScroll = ""
    @IBOutlet weak var mSwitchIcon: UIImageView!
    
    
    @IBOutlet weak var mCatalogHeaderLABEL: UILabel!
    @IBOutlet weak var mFFilterLABEL: UILabel!
    @IBOutlet weak var mFClearAllBUTTON: UIButton!
    @IBOutlet weak var mFItemLABEL: UILabel!
    @IBOutlet weak var mFISelectAllBUTTON: UIButton!
    @IBOutlet weak var mFCollectionLABEL: UILabel!
    @IBOutlet weak var mFCSelectAllBUTTON: UIButton!
    @IBOutlet weak var mFMetalLABEL: UILabel!
    @IBOutlet weak var mFMSelectAllBUTTON: UIButton!
    @IBOutlet weak var mFStoneLABEL: UILabel!
    @IBOutlet weak var mFSSelectAllBUTTON: UIButton!
    @IBOutlet weak var mFLocationLABEL: UILabel!
    @IBOutlet weak var mFLSelectAllBUTTON: UIButton!
    @IBOutlet weak var mFSizeLABEL: UILabel!
    @IBOutlet weak var mFSZSelectAllBUTTON: UIButton!
    @IBOutlet weak var mFPriceLABEL: UILabel!
    @IBOutlet weak var mFPriceRangeLABEL: UILabel!
    @IBOutlet weak var mFSubmitBUTTON: UIButton!
    
    private var mSkipCount = 0
    private var mTotalData = 0
    private let mDataFetchLimit = 20
    @IBOutlet weak var mShowMoreButton: UIView!
    
    private let speechRecongniger = SpeechRecognizer(localeIdentifier: "en-US")
    private var isSpeechRecongnitionOn = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        mSearchField.placeholder = "Search by SKU / Product name".localizedString
        mCatalogHeaderLABEL.text = "Catalog".localizedString
        
        if !mCustomerId.isEmpty {
            mSkipCount = 0
            mGetCatalogs(key: "")
        }
        
        if openFromHome {
            mClearCart()
        }
        
    }
    
    var openFromHome = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        if mKey == "1" {
            mBackView.isHidden = true
        }else{
            mBackView.isHidden = false
        }
        
        mSubFilterView.layer.cornerRadius = 20
        mSubFilterView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        mItemCollectionView.delegate = self
        mItemCollectionView.dataSource = self
        
        mCollectCollectionView.delegate = self
        mCollectCollectionView.dataSource = self
        
        mMetalCollectionView.delegate = self
        mMetalCollectionView.dataSource = self
        
        mStoneCollectionView.delegate = self
        mStoneCollectionView.dataSource = self
        
        mSizeCollectionView.delegate = self
        mSizeCollectionView.dataSource = self
        
        mCatalogCollectionView.delegate = self
        mCatalogCollectionView.dataSource = self
        
        mShowMoreButton.isHidden = true
        
        if mCustomerId == "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
            if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
                home.delegate = self
                home.modalPresentationStyle = .automatic
                home.transitioningDelegate = self
                self.present(home,animated: true)
            }
        }
        mGetCatalogs(key: "")
        addDoneButtonOnKeyboard()
        self.mSearchField.text = SiriID
    }
    
    func mCheckSelectedCustomer(){
        mCustomerId = UserDefaults.standard.string( forKey: "DEFAULTCUSTOMER") ?? ""
        
        if mCustomerId == "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
            if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
                home.delegate = self
                home.modalPresentationStyle = .automatic
                home.transitioningDelegate = self
                self.present(home,animated: true)
            }
        } else {
            self.mCustomerImage.contentMode = .scaleAspectFill
            self.mCheckUncheckCustomer.image = UIImage(named: "selected_customer")
            self.mCustomerImage.downlaodImageFromUrl(urlString: UserDefaults.standard.string( forKey: "DEFAULTCUSTOMERPICTURE") ?? "")
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    //Speech Recognition
    @IBOutlet weak var sMicImage: UIImageView!
    @IBAction func sSpeechRecognitionButton(_ sender: Any) {
        if !isSpeechRecongnitionOn {
            self.isSpeechRecongnitionOn = true
            self.sMicImage.image = UIImage(systemName: "mic.slash.fill")
            speechRecongniger.startRecognition { value in
                
                DispatchQueue.main.async {
                    self.isSpeechRecongnitionOn = false
                    self.sMicImage.image = UIImage(systemName: "mic.fill")
                    if let text = value , !text.isEmpty{
                        self.mSearchField.text = text
                        self.mSearchField.becomeFirstResponder()
                    }
                }
            }
            
        } else {
            self.sMicImage.image = UIImage(systemName: "mic.fill")
            self.isSpeechRecongnitionOn = false
            speechRecongniger.stopRecognition()
        }
    }
    
    @IBAction func mShowSearchFilters(_ sender: Any) {
        
    }
    
    @IBAction func mShowFilters(_ sender: Any) {
        
        view.endEditing(true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let mFilters = storyBoard.instantiateViewController(withIdentifier: "CommonFilters") as? CommonFilters {
            mFilters.delegate = self
            mFilters.mType = mSearchType
            mFilters.mItemsId = mItemsId
            mFilters.mMetalsId = mMetalsId
            mFilters.mCollectionId = mCollectionId
            mFilters.mStonesId = mStonesId
            mFilters.mSizeId = mSizeId
            mFilters.mLocationsId = mStatusId
            mFilters.mStatusId = mLocationsId
            mFilters.mMinPrices = mMinPrices
            mFilters.mMaxPrices = mMaxPrices
            mFilters.modalPresentationStyle = .automatic
            mFilters.transitioningDelegate = self
            self.present(mFilters,animated: true)
        }
    }
    
    func mGetInventoryFilterData(itemsId: [String], metalId: [String], collectionId: [String], stoneId: [String], sizeId: [String], locationId: [String], statusId: [String], minPrice: String, maxPrice: String) {
        
        mItemsId = itemsId
        mMetalsId = metalId
        mCollectionId = collectionId
        mStonesId = stoneId
        mSizeId = sizeId
        mStatusId = statusId
        mLocationsId = locationId
        mMinPrices = minPrice
        mMaxPrices = maxPrice
        
        mSkipCount = 0
        mGetCatalogs(key: "")
    }
    
    
    @IBAction func mSwitchInvCatlog(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        mSkipCount = 0
        if sender.isSelected {
            
            self.mMetalsId.removeAll()
            self.mStonesId.removeAll()
            self.mLocationsId.removeAll()
            self.mSizeId.removeAll()
            self.mMetalsData = NSArray()
            self.mStonesData = NSArray()
            self.mLocationsData = NSArray()
            self.mSizeData = NSArray()
            
            mSearchType = "inventory"
            self.mCatalogHeaderLABEL.text = "Inventory".localizedString
            mSwitchIcon.image = UIImage(named: "catstock_ic")
             if !SiriID.isEmpty {
                           mSearchField.text = SiriID
                           print("Searching with SiriID: \(SiriID)")
                           self.mGetCatalogs(key: SiriID)
                       } else {
                           self.mGetCatalogs(key: "")
                       }
        }else{
            mSearchType = "catalog"
            self.mMetalsId.removeAll()
            self.mStonesId.removeAll()
            self.mLocationsId.removeAll()
            self.mSizeId.removeAll()
            self.mMetalsData = NSArray()
            self.mStonesData = NSArray()
            self.mLocationsData = NSArray()
            self.mSizeData = NSArray()
            mSwitchIcon.image = UIImage(named: "catcatlog_ic")
            self.mCatalogHeaderLABEL.text = "Catalog".localizedString
            if !SiriID.isEmpty {
                           mSearchField.text = SiriID
                           print("Searching with SiriID: \(SiriID)")
                           self.mGetCatalogs(key: SiriID)
                       } else {
                           self.mGetCatalogs(key: "")
                       }
        }
    }
    
    
    @IBAction func mOpenCustomer(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
        if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
            home.delegate = self
            home.modalPresentationStyle = .automatic
            home.transitioningDelegate = self
            self.present(home,animated: true)
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

        if let profile = data.value(forKey: "profile") as? String {
            UserDefaults.standard.set(profile, forKey: "DEFAULTCUSTOMERPICTURE")
            self.mCustomerImage.downlaodImageFromUrl(urlString: profile)
        }
     
        if let name = data.value(forKey: "name") as? String {
            UserDefaults.standard.set(name, forKey: "DEFAULTCUSTOMERNAME")
        }
           
        self.mCheckUncheckCustomer.image = UIImage(named: "selected_customer")
        mSkipCount = 0
        
        if !SiriID.isEmpty {
                       mSearchField.text = SiriID
                       print("Searching with SiriID: \(SiriID)")
                       self.mGetCatalogs(key: SiriID)
                   } else {
                       self.mGetCatalogs(key: "")
                   }

    }
    
    
    @IBAction func mMinimizeFilters(_ sender: Any) {
        self.mFilterView.slideTop()
        self.mFilterView.isHidden = true
    }
    
    @IBAction func mApplyFilter(_ sender: Any) {
        
        mFilterView.isHidden = true
        mSearchView.isHidden = true
        
        mSkipCount = 0
        self.mGetCatalogs(key: mSearchField.text ?? "")
        
    }
    
    
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        mSearchField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        mSkipCount = 0
        self.mGetCatalogs(key: mSearchField.text ?? "")
        mSearchField.text = ""
        mSearchField.resignFirstResponder()
    }
    
    @IBAction func mClearFilters(_ sender: Any) {
        self.mItemsId.removeAll()
        self.mCollectionId.removeAll()
        self.mMetalsId.removeAll()
        self.mStonesId.removeAll()
        self.mSizeId.removeAll()
        self.mItemCollectionView.reloadData()
        self.mCollectCollectionView.reloadData()
        self.mMetalCollectionView.reloadData()
        self.mStoneCollectionView.reloadData()
        
        self.mSizeCollectionView.reloadData()
        mSkipCount = 0
        self.mGetCatalogs(key: mSearchField.text ?? "")
    }
    
    
    @IBAction func mSelectAllItems(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            
            sender.setTitle("Select All".localizedString, for: .normal)
            mItemsId.removeAll()
            
            mItemCollectionView.reloadData()
            
        }else{
            
            sender.isSelected = true
            mItemsId.removeAll()
            
            for (index, _) in self.mItemsData.enumerated(){
                if let mData = mItemsData[index] as? NSDictionary,
                   let id = mData.value(forKey: "id") as? String {
                    mItemsId.append(id)
                }
            }
            sender.setTitle("Deselect".localizedString, for: .normal)
            mItemCollectionView.reloadData()
            
        }
    }
    
    @IBAction func mSelectAllCollection(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            
            sender.setTitle("Select All".localizedString, for: .normal)
            mCollectionId.removeAll()
            
            mCollectCollectionView.reloadData()
            
        }else{
            sender.setTitle("Deselect".localizedString, for: .normal)
            sender.isSelected = true
            mCollectionId.removeAll()
            
            
            for (index, _) in self.mCollectionData.enumerated(){
                if let mData = mCollectionData[index] as? NSDictionary,
                   let id = mData.value(forKey: "id") as? String {
                    mCollectionId.append(id)
                }
            }
            mCollectCollectionView.reloadData()
            
        }
    }
    
    @IBAction func mSelectAllStones(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            
            sender.setTitle("Select All".localizedString, for: .normal)
            mStonesId.removeAll()
            
            mStoneCollectionView.reloadData()
            
        }else{
            sender.setTitle("Deselect", for: .normal)
            sender.isSelected = true
            
            mStonesId.removeAll()
            
            for (index, _) in self.mStonesData.enumerated(){
                if let mData = mStonesData[index] as? NSDictionary,
                   let id = mData.value(forKey: "id") as? String {
                    mStonesId.append(id)
                }
            }
            mStoneCollectionView.reloadData()
            
        }
    }
    
    @IBAction func mSelectAllMetals(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            
            sender.setTitle("Select All".localizedString, for: .normal)
            mMetalsId.removeAll()
            
            mMetalCollectionView.reloadData()
            
        }else{
            sender.setTitle("Deselect", for: .normal)
            sender.isSelected = true
            mMetalsId.removeAll()
            
            for (index, _) in self.mMetalsData.enumerated(){
                if let mData = mMetalsData[index] as? NSDictionary,
                   let id = mData.value(forKey: "id") as? String {
                    mMetalsId.append(id)
                }
            }
            mMetalCollectionView.reloadData()
            
        }
    }
    
    @IBAction func mSelectAllLocation(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            
            sender.setTitle("Select All".localizedString, for: .normal)
            mLocationsId.removeAll()
            
            mLocationCollectionView.reloadData()
            
        }else{
            
            sender.isSelected = true
            sender.setTitle("Deselect".localizedString, for: .normal)
            mLocationsId.removeAll()
            
            for (index, _) in self.mLocationsData.enumerated(){
                if let mData = mLocationsData[index] as? NSDictionary,
                   let id = mData.value(forKey: "id") as? String {
                    mLocationsId.append(id)
                }
            }
            mLocationCollectionView.reloadData()
        }
    }
    
    @IBAction func mSelectAllSize(_ sender: UIButton) {
        
        
        if sender.isSelected {
            sender.isSelected = false
            
            sender.setTitle("Select All".localizedString, for: .normal)
            mSizeId.removeAll()
            
            mSizeCollectionView.reloadData()
            
        }else{
            sender.setTitle("Deselect".localizedString, for: .normal)
            sender.isSelected = true
            mSizeId.removeAll()
            
            for (index, _) in self.mSizeData.enumerated(){
                if let mData = mSizeData[index] as? NSDictionary,
                   let id = mData.value(forKey: "id") as? String {
                    mSizeId.append(id)
                }
            }
            mSizeCollectionView.reloadData()
        }
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === mPriceRange {
            
            self.mMinPrice.text = "\(Int(minValue))"
            self.mMaxPrice.text = "\(Int(maxValue))"
            self.mMinPrices = "\(Int(minValue))"
            self.mMaxPrices = "\(Int(maxValue))"
            
        }
    }
    
    @IBAction func mBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mGoToWishList(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "catalog", bundle: nil)
        if let mWishList  = storyBoard.instantiateViewController(withIdentifier: "WishlistSearchNew") as? WishlistSearch {
            self.navigationController?.pushViewController(mWishList, animated:true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mSearchCustomerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        var cell =  UITableViewCell()
        
        if tableView == mCustomerSearchTableView {
            
            guard let cells = tableView.dequeueReusableCell(withIdentifier: "CustomerSearchItem") as? CustomerSearchItem else {
                return cell
            }
            
            if let mData =  mSearchCustomerData[indexPath.row] as? NSDictionary {
                
                if let fname = mData.value(forKey: "fname") as? String {
                    cells.mCustomerName.text = fname
                }

                if let lname = mData.value(forKey: "lname") as? String {
                    if let currentText = cells.mCustomerName.text {
                        cells.mCustomerName.text = currentText + " " + lname
                    } else {
                        cells.mCustomerName.text = lname
                    }
                }

                if let phoneCode = mData.value(forKey: "phone_code") as? String {
                    cells.mPhone.text = phoneCode
                }

                if let phone = mData.value(forKey: "phone") as? String {
                    if let currentText = cells.mPhone.text {
                        cells.mPhone.text = currentText + " " + phone
                    } else {
                        cells.mPhone.text = phone
                    }
                }

                if let stateCountry = mData.value(forKey: "stateCountry") as? String {
                    cells.mPlace.text = stateCountry
                }
            }
            
            cell = cells
        }
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        
        return 78
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count = 0
        if collectionView == self.mItemCollectionView {
            count = mItemsData.count
            
        }else if collectionView == self.mCollectCollectionView {
            count = mCollectionData.count
            
            
        }else if collectionView == self.mMetalCollectionView {
            count = mMetalsData.count
            
        }else if collectionView == self.mCatalogCollectionView {
            
            count = mCatalogData.count
            if count == 0 {
                collectionView.setError("No items available!")
            }else{
                collectionView.clearBackground()
            }
            
        }else if collectionView == self.mStoneCollectionView {
            count = mStonesData.count
            
            
        }else if collectionView == self.mSizeCollectionView {
            count = mSizeData.count
            
            
        }
        
        return count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        if collectionView == self.mItemCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
                return cell
            }
            let mData =  mItemsData[indexPath.row] as? NSDictionary

            if let itemName = mData?.value(forKey: "name") as? String {
                cells.mItemName.text = itemName
            }

            if let itemId = mData?.value(forKey: "id") as? String {
                if mItemsId.contains(itemId) {
                    cells.mItemName.backgroundColor =  #colorLiteral(red: 0.7725490196, green: 0.6666666667, blue: 0.5058823529, alpha: 1)
                    cells.backgroundColor =  #colorLiteral(red: 0.7725490196, green: 0.6666666667, blue: 0.5058823529, alpha: 1)
                } else {
                    cells.mItemName.backgroundColor =  #colorLiteral(red: 0.9450980392, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
                    cells.backgroundColor =  #colorLiteral(red: 0.9450980392, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
                }
            }

            cells.layoutSubviews()
            cell = cells
        }else if collectionView == self.mCollectCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else {
                return cell
            }

            let mData =  mCollectionData[indexPath.row] as? NSDictionary

            if let collectionName = mData?.value(forKey: "name") as? String {
                cells.mCollectionName.text = collectionName
            }

            if let collectionId = mData?.value(forKey: "id") as? String {
                if mCollectionId.contains(collectionId) {
                    cells.mCollectionName.backgroundColor =  #colorLiteral(red: 0.7725490196, green: 0.6666666667, blue: 0.5058823529, alpha: 1)
                    cells.backgroundColor =  #colorLiteral(red: 0.7725490196, green: 0.6666666667, blue: 0.5058823529, alpha: 1)
                } else {
                    cells.mCollectionName.backgroundColor =  #colorLiteral(red: 0.9450980392, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
                    cells.backgroundColor =  #colorLiteral(red: 0.9450980392, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
                }
            }

            cells.layoutSubviews()
            cell = cells
            
        }else if collectionView == self.mMetalCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "MetalCell", for: indexPath) as? MetalCell else {
                return cell
            }

            let mData =  mMetalsData[indexPath.row] as? NSDictionary

            if let metalName = mData?.value(forKey: "name") as? String {
                cells.mMetalName.text = metalName
            }

            if let metalId = mData?.value(forKey: "id") as? String {
                if mMetalsId.contains(metalId) {
                    cells.mMetalName.backgroundColor =  #colorLiteral(red: 0.7725490196, green: 0.6666666667, blue: 0.5058823529, alpha: 1)
                    cells.backgroundColor =  #colorLiteral(red: 0.7725490196, green: 0.6666666667, blue: 0.5058823529, alpha: 1)
                } else {
                    cells.mMetalName.backgroundColor =  #colorLiteral(red: 0.9450980392, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
                    cells.backgroundColor =  #colorLiteral(red: 0.9450980392, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
                }
            }

            cells.layoutSubviews()
            cell = cells

            
        }else if collectionView == self.mSizeCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath) as? SizeCell else {
                return cell
            }

            guard let mData = mSizeData[indexPath.row] as? NSDictionary else {
                return cell
            }

            if let sizeName = mData.value(forKey: "name") as? String {
                cells.mSizeName.text = sizeName
            }

            if let sizeId = mData.value(forKey: "id") as? String {
                if mSizeId.contains(sizeId) {
                    cells.mSizeName.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0.6666666667, blue: 0.5058823529, alpha: 1)
                    cells.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0.6666666667, blue: 0.5058823529, alpha: 1)
                } else {
                    cells.mSizeName.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
                    cells.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
                }
            }

            cells.layoutSubviews()
            cell = cells
            
        }
        else if collectionView == self.mStoneCollectionView {
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "StoneCell", for: indexPath) as? StoneCell else {
                return cell
            }

            guard let mData = mStonesData[indexPath.row] as? NSDictionary else {
                return cell
            }

            if let stoneName = mData.value(forKey: "name") as? String {
                cells.mCStone.text = stoneName
            }

            if let stoneId = mData.value(forKey: "id") as? String {
                if mStonesId.contains(stoneId) {
                    cells.mCStone.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0.6666666667, blue: 0.5058823529, alpha: 1)
                    cells.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0.6666666667, blue: 0.5058823529, alpha: 1)
                } else {
                    cells.mCStone.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
                    cells.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9058823529, blue: 0.8509803922, alpha: 1)
                }
            }

            cells.layoutSubviews()
            cell = cells
            
        } else if collectionView == self.mCatalogCollectionView {
            
            guard let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell",for:indexPath) as? CatalogCell else {
                return cell
            }
            
            guard let mData = mCatalogData[indexPath.row] as? NSDictionary else {
                return cell
            }
            
            if "\(mData.value(forKey: "isWishlist") ?? "")" == "0" {
                cells.mHeart.image = UIImage(systemName: "heart")
                cells.mHeart.tintColor = UIColor(named: "themeExtraLightText1")
            }else{
                cells.mHeart.image = UIImage(systemName: "heart.fill")
                cells.mHeart.tintColor = UIColor(named: "themeLightRed")
            }
            
            if let isDesign = mData.value(forKey: "is_design") as? Bool {
                if isDesign {
                    cells.mDesignStatusView.isHidden = false
                }else{
                    cells.mDesignStatusView.isHidden = true
                }
            }else{
                cells.mDesignStatusView.isHidden = true
            }
            
            if mSearchType == "catalog" {
                cells.mStatusDot.isHidden = true
            }else {
                cells.mStatusDot.isHidden = false
            }
            
            if let status = mData.value(forKey: "status_type") as? String {
                switch status {
                case "transit" :
                    cells.mStatusDot.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                case "warehouse" :
                    cells.mStatusDot.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                case "reserve" :
                    cells.mStatusDot.backgroundColor = #colorLiteral(red: 1, green: 0.7386777401, blue: 0.3924969435, alpha: 1)
                case "repair_order" :
                    cells.mStatusDot.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.6078431373, blue: 0.7411764706, alpha: 1)
                case "custom_order" :
                    cells.mStatusDot.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                case "stock" :
                    cells.mStatusDot.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                default :
                    cells.mStatusDot.backgroundColor = #colorLiteral(red: 0.4588235294, green: 0.8, blue: 1, alpha: 1)
                }
            }
            
            let skuAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor(named: "themeColor") ?? UIColor.black ]
            let nameAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: #colorLiteral(red: 0.3181298765, green: 0.3326592986, blue: 0.328506533, alpha: 1) ]
            
            let finalName = NSMutableAttributedString()
            finalName.append(NSAttributedString(string: "\(mData.value(forKey: "name")  as? String ?? "")\n", attributes: nameAttributes))
            finalName.append(NSAttributedString(string: "\(mData.value(forKey: "SKU")  as? String ?? "")", attributes: skuAttributes))
            
            cells.mProductName.attributedText = finalName
            cells.mProductLikeButt.tag = indexPath.row
            cells.mAddtoCart.tag = indexPath.row
            cells.mPrice.text = "\(mData.value(forKey: "price") ?? "")"
            cells.mProductImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "main_image") ?? "")")
            cell = cells
            
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mCatalogCollectionView {
            
            if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    return CGSize(width: mCatalogCollectionView.bounds.width/3 , height: 350)
                } else {
                    layout.minimumInteritemSpacing = 0
                    return CGSize(width: mCatalogCollectionView.bounds.width/2  , height: 350)
                }
            } else {
                return CGSize(width: mCatalogCollectionView.bounds.width/2  , height: 350)
            }
        }

        return CGSize(width: view.frame.size.width/2 - 30 , height:50)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == self.mStoneCollectionView {
            
            guard let mData = mStonesData[indexPath.row] as? NSDictionary else {
                return
            }
            
            if let stoneId = mData.value(forKey: "id") as? String {
                if mStonesId.contains(stoneId) {
                    mStonesId.removeAll { $0 == stoneId }
                } else {
                    mStonesId.append(stoneId)
                }
                
                self.mStoneCollectionView.reloadData()
            }
        }
        if collectionView == self.mLocationCollectionView {
            
            guard let mData = mLocationsData[indexPath.row] as? NSDictionary else {
                return
            }
            if let locationid = mData.value(forKey: "id") as? String {
                if mLocationsId.contains(locationid) {
                    mLocationsId = mLocationsId.filter {$0 != locationid }
                } else {
                    mLocationsId.append(locationid)
                }
                self.mLocationCollectionView.reloadData()
            }
        }
        
        if collectionView == self.mMetalCollectionView {
            
            guard let mData = mMetalsData[indexPath.row] as? NSDictionary else {
                return
            }
            if let metalId = mData.value(forKey: "id") as? String {
                if mMetalsId.contains(metalId) {
                    mMetalsId = mMetalsId.filter {$0 != metalId }
                }else{
                    mMetalsId.append(metalId)
                }
                self.mMetalCollectionView.reloadData()
            }
        }
        
        if collectionView == self.mItemCollectionView {
            
            guard let mData = mItemsData[indexPath.row] as? NSDictionary else {
                return
            }
            if let itemId = mData.value(forKey: "id") as? String {
                if mItemsId.contains(itemId) {
                    mItemsId = mItemsId.filter {$0 != itemId }
                }else{
                    mItemsId.append(itemId)
                }
                self.mItemCollectionView.reloadData()
            }
        }
        if collectionView == self.mCollectCollectionView {
            
            guard let mData = mCollectionData[indexPath.row] as? NSDictionary else {
                return
            }
            if let collectionId = mData.value(forKey: "id") as? String {
                if mCollectionId.contains(collectionId) {
                    mCollectionId = mCollectionId.filter {$0 != collectionId }
                }else{
                    mCollectionId.append(collectionId)
                }
                self.mCollectCollectionView.reloadData()
            }
        }
        if collectionView == self.mSizeCollectionView {
            
            guard let mData = mSizeData[indexPath.row] as? NSDictionary else {
                return
            }
            if let sizeId = mData.value(forKey: "id") as? String {
                if mSizeId.contains(sizeId) {
                    mSizeId = mSizeId.filter {$0 != sizeId }
                }else{
                    mSizeId.append(sizeId)
                }
                self.mSizeCollectionView.reloadData()
            }
        }
        
        if collectionView == mCatalogCollectionView {
            
            
            if mCustomerId == "" {
                let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
                if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
                    home.delegate = self
                    home.modalPresentationStyle = .automatic
                    home.transitioningDelegate = self
                    self.present(home,animated: true)
                }
                return
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "catalog", bundle: nil)
            if let mProfile = storyBoard.instantiateViewController(withIdentifier: "POSAddToCartNew") as? POSAddToCart {
                if let data = mCatalogData[indexPath.row] as? NSDictionary {
                    mProfile.mData = data
                }
                mProfile.mType = mSearchType
                mProfile.mCustomerId = mCustomerId
                self.navigationController?.pushViewController(mProfile, animated:true)
            }
        }
        
        
        
    }
    
    @IBAction func mAddToCart(_ sender: UIButton) {
        
        if mCustomerId == "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "common", bundle: nil)
            if let home = storyBoard.instantiateViewController(withIdentifier: "CustomerPicker") as? CustomerPicker {
                home.delegate = self
                home.modalPresentationStyle = .automatic
                home.transitioningDelegate = self
                self.present(home,animated: true)
            }
            return
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "catalog", bundle: nil)
        if let mProfile = storyBoard.instantiateViewController(withIdentifier: "POSAddToCartNew") as? POSAddToCart {
            if let data = mCatalogData[sender.tag] as? NSDictionary {
                mProfile.mData = data
            }
            mProfile.mType = mSearchType
            mProfile.mCustomerId = mCustomerId
            self.navigationController?.pushViewController(mProfile, animated:true)
        }
    }
    
    @IBAction func mLikeDislike(_ sender: UIButton) {
        
        if mCustomerId != "" {
            guard let mData = mCatalogData[sender.tag] as? NSDictionary else {
                return
            }
            CommonClass.showFullLoader(view: self.view)
            let mLocation = UserDefaults.standard.string(forKey: "location") ?? ""
            let mSKU = "\(mData.value(forKey: "SKU") ?? "")"
            let mProductId = "\(mData.value(forKey: "product_id") ?? "")"
            let isWishListed = "\(mData.value(forKey: "isWishlist") ?? "0")"
            
            let params = ["location":mLocation,"customer_id":mCustomerId, "isWishlist":isWishListed,"SKU":mSKU, "type":mSearchType, "product_id": mProductId]
            
            mUserLoginToken = UserDefaults.standard.string(forKey: "token")
            mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
            
            mGetData(url: mAddToFav,headers: sGisHeaders,  params: params) { response , status in
                CommonClass.stopLoader()
                if status {
                    if "\(response.value(forKey: "code") ?? "")" == "200" {
                        
                        if response.value(forKey: "data") == nil {
                            return
                        }
                        
                        guard let catalogData = self.mCatalogData[sender.tag] as? NSDictionary,
                              let newData = catalogData.mutableCopy() as? NSMutableDictionary else {
                            return
                        }

                        if let isWishListed = catalogData.value(forKey: "isWishlist") as? Int {
                            newData.setValue((isWishListed == 0) ? 1 : 0, forKey: "isWishlist")
                            self.mCatalogData[sender.tag] = newData
                            self.mCatalogCollectionView.reloadData()
                        }
                    }
                    
                }
            }
            
        }else{
            
            CommonClass.showSnackBar(message: "Please choose Customer!")
        }
        
    }
    
    func mGetCatalogs(key : String){
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        let urlPath = mGetCatalogue
        mFilterData = [
            "price": [
                "min": mMinPrices,
                "max": mMaxPrices
            ],
            "item": mItemsId,
            "collection": mCollectionId,
            "metal": mMetalsId,
            "stone": mStonesId,
            "size": mSizeId,
            "specifiedOccasion": [] as [String],
            "gender": [] as [String],
            "consumerLifestage": [] as [String],
            "StockId": [] as [String]
        ]
        
        if mSearchType == "inventory" {
            mFilterData["status_type"] = mStatusId
        }
        
        var params = ["search":key,"type":mSearchType, "filter" : self.mFilterData, "customer_id": mCustomerId] as [String : Any]
        if mSearchType == "inventory" && key.isEmpty{
            params["skip"] = mSkipCount
            params["limit"] = mDataFetchLimit
            
        }
        
        if Reachability.isConnectedToNetwork() == true {
            
            AF.request(urlPath, method:.post, parameters:params, encoding: JSONEncoding.default,headers: sGisHeaders).responseJSON
            { response in
                
                guard response.error == nil else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                guard let jsonData = response.data else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                
                guard let jsonResult = json as? NSDictionary else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                if jsonResult.value(forKey: "code") as? Int == 200 {
                    
                    guard let data = jsonResult.value(forKey: "data") as? NSArray else {
                        CommonClass.showSnackBar(message: "OOP's something went wrong!")
                        return
                    }
                    
                    if let total = jsonResult.value(forKey: "totoal") as? Int {
                        self.mTotalData = total
                    }
                    
                    if data.count > 0 {
                        
                        if !key.trim().isEmpty || self.mSkipCount == 0 {
                            self.mCatalogData.removeAllObjects()
                        }
                        
                        let mDataAsAny = data.compactMap { $0 as Any }
                        self.mCatalogData.addObjects(from: mDataAsAny)
                        
                        self.mCatalogCollectionView.reloadData()
                        
                        if key.trim().isEmpty && self.mSearchType == "inventory" {
                            self.mSkipCount += 20
                        } else {
                            self.mSkipCount = 0
                        }
                    }else{
                        self.mCatalogData = NSMutableArray()
                        self.mCatalogCollectionView.reloadData()
                    }
                    
                }else{
                    if let error = jsonResult.value(forKey: "error") as? String {
                        if error == "Authorization has been expired" {
                            CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                        }
                    }
                }
                
            }
        }else{
            CommonClass.showSnackBar(message: "No Internet Connection")
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.bounds.size.height
        
        // Check if you are near the bottom of the UICollectionView
        if contentOffsetY + scrollViewHeight >= contentHeight && mSearchType == "inventory"{
            // You have reached the bottom of the UICollectionView
            // Add your code here to perform any actions when scrolled to the bottom.
            if self.mSkipCount < self.mTotalData{
                mShowMoreButton.isHidden = false
            }
        }else{
            mShowMoreButton.isHidden = true
        }
    }
    
    @IBAction func mShowMore(_ sender: Any) {
        mShowMoreButton.isHidden = true
        mGetCatalogs(key: "")
    }
    
    @IBAction func mLeft(_ sender: Any) {
        mCount = mCount - 1
        if mCount == 1 {
            mLeftView.isHidden = true
        }
        mPageNo.text = "\(mCount)"
        mGetCatalogs(key: "")
    }
    @IBAction func mRight(_ sender: Any) {
        
        mCount =  mCount + 1
        mLeftView.isHidden = false
        mPageNo.text = "\(mCount)"
        mGetCatalogs(key: "")
    }
            
    //Clear Cart API
    func mClearCart(){
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        let urlPath =  mClearDataApi
        
        if Reachability.isConnectedToNetwork() == true {
            AF.request(urlPath, method:.post, headers: sGisHeaders2).responseJSON
            { response in
                
                guard response.error == nil else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                guard let jsonData = response.data else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                
                guard let jsonResult = json as? NSDictionary else {
                    CommonClass.showSnackBar(message: "OOP's something went wrong!")
                    return
                }
                
                if jsonResult.value(forKey: "code") as? Int == 200 {
                    
                    
                }else{
                    if let error = jsonResult.value(forKey: "error") as? String {
                        if error == "Authorization has been expired" {
                            CommonClass.sessionExpired(isExpired: true, navigation: self.navigationController)
                        }
                    }
                }
            }
        }else{
        }
        
    }
    
}
