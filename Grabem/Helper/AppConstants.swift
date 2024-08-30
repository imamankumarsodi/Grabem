//
//  AppConstants.swift
//   Travolong
//
//  Created By Saurabh  Pandey on 10/25/16.
//  Copyright © 2017 IT Rental India.com. All rights reserved.

import Foundation

class AppConstants {
    
    // MARK: API Keys
     static let kSimulatorDeviceToken = "b1e2d3bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
    
     static let kUserLogin            = "user_login"
     static let kUserContact          = "user_contact"
     static let kViewRestaurantList   = "view_restaurant_list1"
     static let kDeviceType           = "iphone"
     static let kChangePassword       = "changePass"
     static let kProfile              = "user_profile"
     static let kRankList             = "ranking"
     static let kUserSignUp           = "user_signup"
     static let ksocialSignUp         = "social_login"
     static let kPublishStory         = "post_story"
     static let kBookData             = "book"
     static let kFBLogin              = "fb_login"
     static let kBookContain          = "book_contain"
     static let kChapterRating        = "chapter_rating"
     static let kReportStry           = "story_complain"
     static let kBlockUser            = "block_user"
     static let kUserMuteUnmute       = "mute_user"
     static let kLogout               = "logout"
     static let kDeleteAccount        = "delete_account"
     static let kForgetPassword       = "forgot_password"
     static let kVerifyMobile         = "check_contact_number"
     static let kVerifyEmail          = "check_email"
     static let kSearchHistory        = "search_history"
     static let kCityList             = "city"
     static let kInstituteList        = "institue_name"
     static let kOrgTypeList          = "organisation_types"
     static let kHobbyList            = "hobby_list"
     static let kForgotPassword       = "forgotPassword"
     static let kForgetPassContactNo  = "forgot_password_contact_number"
     static let kEditProfile          = "edit_profile"
     static let kprofileStatusList    = "profile_status_list"
     static let kViewProfile          = "view_profile"
     static let kUserProfile          = "user_profile"
     static let kCreateGroup          = "create_group"
     static let kOrgDetail            = "OrgDescription"
     static let kOrgList              = "organisation_list"
     static let kOrgStatus            = "organisation_check_status"
     static let kLike                 = "event_like"
     static let kOrgFollow            = "organisation_follow"
     static let kEventDetail          = "event_detail"
     static let kEventComments        = "event_comment_list"
     static let kNotiListing          = "notification_listing"
     static let kcomemnt              = "event_comment"
     static let kuserFollow           = "user_follow"
     static let kchngePassword        = "change_password"
     static let kPostedEvents         = "manage_event"
     static let kDeleteEvent          = "delete_event"
     static let kLeaveOrg             = "leave_organisation"
     static let kLeaveSubAdmin        = "leave_sub_admin"
     static let kSubAdminList         = "my_sub_admins_list"
     static let kCustomerList         = "customer_list"
     static let kCreateSubAdmin       = "create_sub_admin"
     static let kEventTickets         = "event_tickets"
     static let kPassCodeVarification = "login_by_passcode"
     static let kRateUser             = "rate_user"
     static let kCustomerListing      = "customer_listing"
     static let kFollowerListing      = "my_followers"
     static let kFollowingListing     = "my_following"
     static let kDeleteUser           = "delete_user_follow"
     static let kViewBankDetail       = "view_bank_detail"
     static let kSaveBankDetail       = "add_bank_detail"
     static let kAddMemberInGroup     = "add_in_group"
     static let kRequestJoinGroup     = "request_to_join_group"
     static let kUserList             = "user_list"
     static let kUserMapList          = "user_map_list"
     static let kChatHistory          = "chat_history"
     static let kSaveChatHistory      = "save_chat_history"
     static let kUserContactList      = "user_contact_list"
     static let kUpdateLocation       = "update_location"
     static let kGroupList            = "group_list"
     static let kGroupInfo            = "group_info"
     static let kExitGroup            = "exit_group"
     static let kEditGroup            = "edit_group"
     static let kUserBlockedList      = "block_list"
     static let kDeleteChat           = "delete_chat"
     static let kDeleteHistory        = "delete_search_history"
     static let kchangeOnlineStatus   = "change_online_status"
     static let kchangeSoundStatus    = "change_sound_status"
     static let kRequestList          = "request_list"
     static let kRejectRequest        = "reject_request"
     static let kAcceptRequest        = "accept_request"
     static let kQrcodeVerification   = "qrcodeverification"
     static let krestDescription      = "description"
     static let kQRscanbyuser      = "qrscanbyuser"
    
     static let kinstaURL             = "https://api.instagram.com/v1/users/self/?access_token="
     static let kAboutUsURL           = "http://mobulous.co.in/unisocial/services/about_us"
    
     // MARK: Messages
     static let kNoEventMessage        = "No Record Found."
     static let kNoAuthority           = "You do not have authority to access it"
     static let kAlreadyLoginMsg       = "Your session expire. Please login."
     static let kAlredyLoginMsgDisplay = "This account already logged in from other device."
     static let kNoHappeningEventsMsg  = "No events available at the moment"
     static let kNoTrendingEventsMsg   = "No events available at the moment"
     static let kNoFollowingEventsMsg   = "No events available at the moment"
     static let kNoAuthorityforOrgMsg   = "You can not create new orgnazition"
    
    // MARK: Action Sheet & Alert Constants
    
    static let kLoginType               = "loginType"
    static let kTitle                   = ""

    
    
    // MARK: Action Sheet & Alert Constants
    
    static let kChoosePicture           = "Choose Picture"
    static let kReportStory             = "Report This Story"
    static let kReportUser              = "Block user"
    static let kPhotoLibrary            = "Photo Library"
    static let kCamera                  = "Camera"
    static let kCancel                  = "Cancel"
    static let kTakePicture             = "Take Picture"
    static let kReport                  = "Block"
    static let kReportUserStory         = "Report this story"
    static let kOk                      = "OK"
    
    
    
    // MARK: APIs Module URLs and Module Keys
    static let kBASE_SERVICE_URL             = "http://fireaway.co.uk/Grabem/index.php/api/ApiController/"
    static let kBASE_SERVICE_URL_Test        = "http://fireaway.co.uk/Grabem/index.php/api/ApiController/"
   
    // MARK: DateFormater types
    
    static let kDateFormarer            = "dd/MM/yyyy"
    static let kDateFormarer24Hour      = "HH:mm"
    static let kDateTimeDateFormatter   = "dd/MM/yyyy HH:mm"

   
    // MARK: WEEK DAYS Keys

    
    static let kSunday                         = "Sunday"
    static let kMonday                         = "Monday"
    static let kTuesday                        = "Tuesday"
    static let kWednusday                      = "Wednusday"
    static let kThursday                       = "Thursday"
    static let kFriday                         = "Friday"
    static let kSaturday                       = "Saturday"
    
    
    // MARK: Internet & Server Connection Keys

    static let kInternetNotAvailable                    = "Check your Internet Connection"
    static let kInternetServerNotResponding             = "Server Not Responding"
    static let kNotAvailable                            = "Not Available"
    static var userID = ""
    
    
}
