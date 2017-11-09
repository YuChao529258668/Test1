/************************************************************************

        Copyright (c) 2005-2011 by Juphoon System Software, Inc.
                       All rights reserved.

     This software is confidential and proprietary to Juphoon System,
     Inc. No part of this software may be reproduced, stored, transmitted,
     disclosed or used in any form or by any means other than as expressly
     provided by the written license agreement between Juphoon and its
     licensee.

     THIS SOFTWARE IS PROVIDED BY JUPHOON "AS IS" AND ANY EXPRESS OR 
     IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
     ARE DISCLAIMED. IN NO EVENT SHALL JUPHOON BE LIABLE FOR ANY DIRECT, 
     INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
     (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
     OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
     STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
     IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
     POSSIBILITY OF SUCH DAMAGE. 

                    Juphoon System Software, Inc.
                    Email: support@juphoon.com
                    Web: http://www.juphoon.com

************************************************************************/
/*************************************************
  File name     : mtc_ue.h
  Module        : multimedia talk client
  Author        : xiangbo.hui
  Created on    : 2015-03-27
  Description   :
      Data structure and function declare required by MTC statistics

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_UE_H__
#define _MTC_UE_H__

#ifndef MTCFUNC
#if defined(MTC_DLL_EXPORT)
#define MTCFUNC ZFUNC_EXPORT
#elif defined(MTC_DLL_IMPORT)
#define MTCFUNC ZFUNC_IMPORT
#else
#define MTCFUNC
#endif
#endif

/**
 * @file mtc_ue.h
 * @brief MTC User Entry Interface Functions
 *
 * This file includes use entry interface function.
 */

/**
 * @defgroup MtcUeKey MTC notification key for user entry.
 * @{
 */

/**
 * @brief A key whose value is a number object reflecting the reason type.
 * @ref EN_MTC_UE_REASON_TYPE
 */
#define MtcUeReasonKey              "MtcUeReasonKey"

/**
 * @brief A key whose value is a string object reflecting the auth code.
 */
#define MtcUeAuthCodeKey            "MtcUeAuthCodeKey"

/**
 * @brief A key whose value is a string object reflecting the auth nonce.
 */
#define MtcUeAuthNonceKey           "MtcUeAuthNonceKey"

/**
 * @brief A key whose value is a string object reflecting the user's URI.
 */
#define MtcUeUriKey                 "MtcUeUriKey"

/**
 * @brief A key whose value is a string object reflecting the property's name.
 */
#define MtcUePropertyNameKey        "MtcUePropertyNameKey"

/**
 * @brief A key whose value is a string object reflecting the property's value.
 */
#define MtcUePropertyValueKey       "MtcUePropertyValueKey"

/**
 * @brief A key whose value is a string object reflecting the count.
 */
#define MtcUeCountKey               "MtcUeCountKey"

/**
 * @brief A key whose value is a string object reflecting the type of ID.
 */
#define MtcUeIdTypeKey              "MtcUeIdTypeKey"

/**
 * @brief A key whose value is a string object relecting the ID.
 */
#define MtcUeIdKey                  "MtcUeIdKey"

/** @} */

/**
 * @defgroup MtcUeNotification MTC notification names for user entry.
 * @{
 */

/**
 * @brief Posted when the account created successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeCreateOkNotification "MtcUeCreateOkNotification"

/**
 * @brief Posted when the account created failed.
 *
 * The pcInfo of this notification contains @ref MtcUeReasonKey 
 * which provide reflects the cause of the failure.
 */
#define MtcUeCreateDidFailNotification "MtcUeCreateDidFailNotification"

/**
 * @brief Posted when the authentication code requested successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeRequestAuthCodeOkNotification "MtcUeRequestAuthCodeOkNotification"

/**
 * @brief Posted when the authentication code requested failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeRequestAuthCodeDidFailNotification "MtcUeRequestAuthCodeDidFailNotification"

/**
 * @brief Posted when the authentication code requested successfully from server.
 *
 * The pcInfo of this notification contains @ref MtcUeAuthCodeKey
 * which provide reflects the auth code.
 */
#define MtcUeRequestClientAuthCodeOkNotification "MtcUeRequestClientAuthCodeOkNotification"

/**
 * @brief Posted when the authentication code requested failed from server.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeRequestClientAuthCodeDidFailNotification "MtcUeRequestClientAuthCodeDidFailNotification"

/**
 * @brief Posted when the encrypted password fetched successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeFetchPasswordOkNotification "MtcUeFetchPasswordOkNotification"

/**
 * @brief Posted when the encrypted password fetched failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeFetchPasswordDidFailNotification "MtcUeFetchPasswordDidFailNotification"

/**
 * @brief Posted when the new password reset successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeResetPasswordOkNotification "MtcUeResetPasswordOkNotification"

/**
 * @brief Posted when the new password reset failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeResetPasswordDidFailNotification "MtcUeResetPasswordDidFailNotification"

/**
 * @brief Posted when the password changed successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeChangePasswordOkNotification "MtcUeChangePasswordOkNotification"

/**
 * @brief Posted when the password changed failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeChangePasswordDidFailNotification "MtcUeChangePasswordDidFailNotification"

/**
 * @brief Posted when the mailbox or phone number associated with an account
 * bind successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeBindRelationshipOkNotification "MtcUeBindRelationshipOkNotification"

/**
 * @brief Posted when the mailbox or phone number associated with an account
 * bind failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeBindRelationshipDidFailNotification "MtcUeBindRelationshipDidFailNotification"

/**
 * @brief Posted when the mailbox or phone number associated with an account
 * unbind successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeUnbindRelationshipOkNotification "MtcUeUnbindRelationshipOkNotification"

/**
 * @brief Posted when the mailbox or phone number associated with an account
 * unbind failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeUnbindRelationshipDidFailNotification "MtcUeUnbindRelationshipDidFailNotification"

/**
 * @brief Posted when the binding relationship of an account has been released.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeRelationshipReleasedNotification "MtcUeRelationshipReleasedNotification"

/**
 * @brief Posted when the account query ok.
 *
 * The pcInfo of this notification contains @ref MtcUeReasonKey 
 * which provide reflects the relation status.
 */
#define MtcUeQueryAccountOkNotification "MtcUeQueryAccountOkNotification"

/**
 * @brief Posted when the account query failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeQueryAccountDidFailNotification "MtcUeQueryAccountDidFailNotification"

/**
 * @brief Posted when get relations successfully.
 *
 * The pcInfo of this notification is array of relations.
 * Each item contains @ref MtcUeIdTypeKey, @ref MtcUeIdKey, @ref MtcUeUriKey.
 */
#define MtcUeGetAllRelationsOkNotifcation "MtcUeGetAllRelationsOkNotifcation"

/**
 * @brief Posted when failed to get relations.
 *
 * The pcInfo of this notification contains @ref MtcUeReasonKey.
 */
#define MtcUeGetAllRelationsDidFailNotification "MtcUeGetAllRelationsDidFailNotification"

/**
 * @brief Posted when authoization required by server.
 *
 * The pcInfo of this notificaiton contains @ref MtcUeAuthNonceKey, @ref MtcUeUriKey.
 */
#define MtcUeAuthorizationRequireNotification "MtcUeAuthorizationRequireNotification"

/**
 * @brief Posted when authoization expired.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcUeAuthorizationExpiredNotification "MtcUeAuthorizationExpiredNotification"

/**
 * @brief Posted when authoization refreshed OK.
 *
 * The pcInfo of this notificaiton is ZNULL.
 */
#define MtcUeAuthorizationRefreshOkNotification "MtcUeAuthorizationRefreshOkNotification"

/**
 * @brief Posted when authoization refreshed failed.
 *
 * The pcInfo of this notificaiton contains @ref MtcUeReasonKey.
 */
#define MtcUeAuthorizationRefreshDidFailNotification "MtcUeAuthorizationRefreshDidFailNotification"

/**
 * @brief Posted when set property OK.
 *
 * The pcInfo of this notificaiton is ZNULL.
 */
#define MtcUeSetPropertyOkNotification "MtcUeSetPropertyOkNotification"

/**
 * @brief Posted when set property failed.
 *
 * The pcInfo of this notificaiton contains @ref MtcUeReasonKey.
 */
#define MtcUeSetPropertyDidFailNotification "MtcUeSetPropertyDidFailNotification"

/**
 * @brief Posted when get property OK.
 *
 * The pcInfo of this notificaiton is ZNULL.
 */
#define MtcUeGetPropertyOkNotification "MtcUeGetPropertyOkNotification"

/**
 * @brief Posted when get property failed.
 *
 * The pcInfo of this notificaiton contains @ref MtcUeReasonKey.
 */
#define MtcUeGetPropertyDidFailNotification "MtcUeGetPropertyDidFailNotification"

/**
 * @brief Posted when set properties OK.
 *
 * The pcInfo of this notificaiton is ZNULL.
 */
#define MtcUeSetPropertiesOkNotification "MtcUeSetPropertiesOkNotification"

/**
 * @brief Posted when set properties failed.
 *
 * The pcInfo of this notificaiton contains @ref MtcUeReasonKey.
 */
#define MtcUeSetPropertiesDidFailNotification "MtcUeSetPropertiesDidFailNotification"

/**
 * @brief Posted when get properties OK.
 *
 * The pcInfo of this notificaiton contains an JSON array.
 */
#define MtcUeGetPropertiesOkNotification "MtcUeGetPropertiesOkNotification"

/**
 * @brief Posted when get properties failed.
 *
 * The pcInfo of this notificaiton contains @ref MtcUeReasonKey.
 */
#define MtcUeGetPropertiesDidFailNotification "MtcUeGetPropertiesDidFailNotification"

/**
 * @brief Posted when set status OK.
 *
 * The pcInfo of this notificaiton is ZNULL.
 */
#define MtcUeSetStatusOkNotification "MtcUeSetStatusOkNotification"

/**
 * @brief Posted when set status failed.
 *
 * The pcInfo of this notificaiton contains @ref MtcUeReasonKey.
 */
#define MtcUeSetStatusDidFailNotification "MtcUeSetStatusDidFailNotification"
/** @} */


#ifdef __cplusplus
extern "C" {
#endif

/** @brief MTC user entry reasen type. */
typedef enum EN_MTC_UE_REASON_TYPE
{
    EN_MTC_UE_REASON_ACCOUNT_EXIST,         /**< @brief Account exist. */
    EN_MTC_UE_REASON_ACCOUNT_NOT_EXIST,     /**< @brief Account not exist. */ 
    EN_MTC_UE_REASON_AUTH_CODE_ERROR,       /**< @brief Auth code is error. */
    EN_MTC_UE_REASON_AUTH_CODE_EXPIRED,     /**< @brief Auth code is expired. */
    EN_MTC_UE_REASON_AUTH_TOO_MANY_TIMES,   /**< @brief Try to auth too many times. */
    EN_MTC_UE_REASON_AUTH_BLOCKED,          /**< @brief Auth is blocked. */
    EN_MTC_UE_REASON_UNKNOWN,               /**< @brief Unknown reason. */
    EN_MTC_UE_REASON_NO_USER_ENTRY,         /**< @brief No User Entry. */
    EN_MTC_UE_REASON_NOT_FOUND,
} EN_MTC_UE_REASON_TYPE;

/** @brief MTC user entry requse type. */
typedef enum EN_MTC_UE_REQUEST_TYPE
{
    EN_MTC_UE_REQUEST_FETCH_PASSWORD,       /**< @brief Fetch password. */
    EN_MTC_UE_REQUEST_RESET_PASSWORD,       /**< @brief Reset password. */
    EN_MTC_UE_REQUEST_CREATE_ACCOUNT,       /**< @brief Create account. */
    EN_MTC_UE_REQUEST_ADD_RELATIONSHIP,     /**< @brief Add relationship. */
} EN_MTC_UE_REQUEST_TYPE;

#define MTC_UE_AUTHCODE_BYSMS   "sms"           /**< @brief Indicate the Authenication code is sent by SMS.*/
#define MTC_UE_AUTHCODE_BYCALL  "call"          /**< @brief Indicate the Authenication code is sent by audio.*/
#define MTC_UE_AUTHCODE_IN_ENG  "en"            /**< @brief Indicate the Authenication code is in english.*/
#define MTC_UE_AUTHCODE_IN_CHN  "zh"            /**< @brief Indicate the Authenication code is in chinese.*/

/** 
 * @brief MTC create a user from JustalkCloud.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] pcUserName The Username string.
 * @param [in] pcPassword The password string.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeCreateOkNotification or @ref MtcUeCreateDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeCreate(ZCOOKIE zCookie, ZCONST ZCHAR *pcUserName,
                ZCONST ZCHAR *pcPassword);

/** 
 * @brief MTC create a user with authentic code from JustalkCloud.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] pcAuthCode The Authentic Code string.
 * @param [in] iIdType @ref EN_MTC_USER_ID_TYPE The user entry type.  
 * @param [in] pcLinkedId The Phone number string.
 * @param [in] pcPassword The password string.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeCreateOkNotification or @ref MtcUeCreateDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeCreateWithAuthCode(ZCOOKIE zCookie, 
                ZCONST ZCHAR *pcAuthCode, ZINT iIdType, ZCONST ZCHAR *pcLinkedId, 
                ZCONST ZCHAR *pcPassword);

/** 
 * @brief MTC require an Authentication code from  JustalkCloud.
 *
 * @param [in] iRequestType @ref EN_MTC_UE_REQUEST_TYPE The auth will be used for what?.
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] iIdType @ref EN_MTC_USER_ID_TYPE The auth tool type.
 * @param [in] pcLinkedId The auth tool number string. 
 * @param [in] iExpires The authCode will be work well in iExpires seconds.
 * @param [in] iRetryCount means how many times the message is sent.
 * @param [in] pcBy means whether message is sent by SMS @ref MTC_UE_AUTHCODE_BYSMS  
 *             or audio @ref MTC_UE_AUTHCODE_BYCALL.
 * @param [in] pcTemplate The template of the message with authorization code.
 * 
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeRequestAuthCodeOkNotification or @ref MtcUeRequestAuthCodeDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeRequestAuthCode(ZUINT iRequestType,
                ZCOOKIE zCookie, ZINT iIdType, ZCONST ZCHAR *pcLinkedId,
                ZINT iExpires, ZINT iRetryCount, ZCONST ZCHAR *pcBy,
                ZCONST ZCHAR *pcTemplate);

/** 
 * @brief MTC require an Authentication code from  JustalkCloud.
 *
 * @param [in] iRequestType @ref EN_MTC_UE_REQUEST_TYPE The auth will be used for what?.
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] iIdType @ref EN_MTC_USER_ID_TYPE The auth tool type.
 * @param [in] pcLinkedId The auth tool number string. 
 * @param [in] iExpires The authCode will be work well in iExpires seconds.
 * 
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeRequestClientAuthCodeOkNotification or @ref MtcUeRequestClientAuthCodeDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeRequestClientAuthCode(ZUINT iRequestType, ZCOOKIE zCookie, 
                ZINT iIdType, ZCONST ZCHAR *pcLinkedId, ZINT iExpires);

/** 
 * @brief MTC fetch the encrypted password.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] pcAuthCode The Authentication code string get from the email or phone.
 * @param [in] iIdType The UserId string.
 * @param [in] pcLinkedId The encrypted password string.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeFetchPasswordOkNotification or @ref MtcUeResetPasswordDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeFetchPassword(ZCOOKIE zCookie, ZCONST ZCHAR *pcAuthCode,
                ZINT iIdType, ZCONST ZCHAR *pcLinkedId);

/** 
 * @brief MTC reset password.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] pcAuthCode The Authentication code string get from the email or phone.
 * @param [in] pcPassword The new password string.
 * @param [in] iIdType The UserId string.
 * @param [in] pcLinkedId The encrypted password string.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeResetPasswordOkNotification or @ref MtcUeResetPasswordDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeResetPassword(ZCOOKIE zCookie, ZCONST ZCHAR *pcAuthCode,
    ZCONST ZCHAR *pcPassword, ZINT iIdType, ZCONST ZCHAR *pcLinkedId);

/** 
 * @brief MTC change an old password to a new password.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] pcOldPassword The old password string.
 * @param [in] pcNewPassword The new password string.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeChangePasswordOkNotification or @ref MtcUeChangePasswordDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeChangePassword(ZCOOKIE zCookie, 
                ZCONST ZCHAR *pcOldPassword, ZCONST ZCHAR *pcNewPassword);

/** 
 * @brief MTC bind the mailbox or phone number associated with an account.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] pcAuthCode The Authentication code string get from the email or phone.
 * @param [in] iIdType @ref EN_MTC_USER_ID_TYPE .
 * @param [in] pcLinkedId The phone number string or mainbox string.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeBindRelationshipOkNotification or @ref MtcUeBindRelationshipDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeBindRelationship(ZCOOKIE zCookie, 
                ZCONST ZCHAR *pcAuthCode, ZUINT iIdType,
                ZCONST ZCHAR *pcLinkedId);

/** 
 * @brief MTC unbind the mailbox or phone number associated with an account.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] iIdType @ref EN_MTC_USER_ID_TYPE.
 * @param [in] pcLinkedId The phone number string or mainbox string.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeBindRelationshipOkNotification or @ref MtcUeBindRelationshipDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeUnbindRelationship(ZCOOKIE zCookie, 
                ZINT iIdType, ZCONST ZCHAR *pcLinkedId);

/** 
 * @brief MTC fetch the encrypted password.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] iIdType @ref EN_MTC_USER_ID_TYPE.
 * @param [in] pcLinkedId The username string.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcCliAccountQueryOkNotification or @ref MtcCliAccountQueryDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeQueryStatus(ZCOOKIE zCookie, 
                ZINT iIdType, ZCONST ZCHAR *pcLinkedId);
/** 
 * @brief MTC fetch the encrypted password.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] iIdType @ref EN_MTC_USER_ID_TYPE.
 * @param [in] pcLinkedId The username string.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeQueryAccountOkNotification or @ref MtcUeQueryAccountDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeQueryAccount(ZCOOKIE zCookie, 
                ZINT iIdType, ZCONST ZCHAR *pcLinkedId);

/** 
 * @brief MTC get all relations.
 *
 * @param  zCookie The UI cookie value.
 * 
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcUeGetAllRelationsOkNotifcation or
 * @ref MtcUeGetAllRelationsDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeGetAllRelations(ZCOOKIE zCookie);

/**
 * @brief Check if URI is valid relation.
 *
 * @param [in] pcUri The URI string.
 *
 * @retval ZTRUE The URI is valid relation.
 * @retval ZFALSE The URI is not valid realtion.
 */
MTCFUNC ZBOOL Mtc_UeIsValidRelation(ZCONST ZCHAR *pcUri);

/**
 * @brief MTC get ID of current login URI.
 * 
 * @return The string of ID. ZNULL when failed.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UeGetId(ZFUNC_VOID);

/**
 * @brief MTC get current login URI.
 * 
 * @return The string of URI. ZNULL when failed.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UeGetUri(ZFUNC_VOID);

/**
 * @brief MTC get private unique ID of current login user.
 * 
 * @return The string of ID. ZNULL when failed.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UeGetUid(ZFUNC_VOID);

/**
 * @brief MTC refresh authorization.
 *
 * @retval ZOK on invoke this interface successfully. The result will be notified by
 *         @ref MtcUeAuthorizationRefreshOkNotification or
 *         @ref MtcUeAuthorizationRefreshDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeRefreshAuth(ZFUNC_VOID);

/**
 * @brief Notify the AuthCode to SDK to continue login or refresh authorization process.
 * 
 * @param  pcAuthCode The AuthCode string.
 * 
 * @retval ZOK on invoke this interface successfully. The result will be notified by
 *         the notification of login or refresh authorization process.
 *         Reference @ref Mtc_CliLogin or @ref Mtc_UeRefreshAuth.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UePromptAuthCode(ZCONST ZCHAR *pcAuthCode);

/**
 * @brief Set user property
 * 
 * @param  zCookie The cookie.
 * @param  pcName  The property name.
 * @param  pcValue The property value.
 * 
 * @retval ZOK on invoke this interface successfully. The result will be notified by
 *             @ref MtcUeSetPropertyOkNotification or
 *             @ref MtcUeSetPropertyDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeSetProperty(ZCOOKIE zCookie, ZCONST ZCHAR *pcName,
    ZCONST ZCHAR *pcValue);

/**
 * @brief Get user property
 * 
 * @param  zCookie The cookie.
 * @param  pcName  The property name.
 *
 * @retval ZOK on invoke this interface successfully. The result will be notified by
 *             @ref MtcUeGetPropertyOkNotification or
 *             @ref MtcUeGetPropertyDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeGetProperty(ZCOOKIE zCookie, ZCONST ZCHAR *pcName);

/**
 * @brief Set user properties
 *
 * @param  zCookie      The cookie.
 * @param  pcPropArray  The property name and value in a JSON array.
 *                      Each element in array is a JSON object contains 
 *                      @ref MtcUePropertyNameKey and @ref MtcUePropertyValueKey.
 *
 * @retval ZOK on invoke this interface successfully. The result will be notified by
 *             @ref MtcUeSetPropertiesOkNotification or
 *             @ref MtcUeSetPropertiesDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeSetProperties(ZCOOKIE zCookie, ZCONST ZCHAR *pcPropArray);

/**
 * @brief Get user properties
 *
 * @param  zCookie     The cookie.
 * @param  pcNameArray The property names in a JSON array.
 *                     Each element in array is a string of property's name.
 *
 * @retval ZOK on invoke this interface successfully. The result will be notified by
 *             @ref MtcUeGetPropertiesOkNotification or
 *             @ref MtcUeGetPropertiesDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeGetProperties(ZCOOKIE zCookie, ZCONST ZCHAR *pcNameArray);

/**
 * @brief Set user status
 * 
 * @param  zCookie The cookie.
 * @param  pcType  The status type.
 * @param  pcValue The status value.
 * 
 * @retval ZOK on invoke this interface successfully. The result will be notified by
 *             @ref MtcUeSetStatusOkNotification or
 *             @ref MtcUeSetStatusDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeSetStatus(ZCOOKIE zCookie, ZCONST ZCHAR *pcType,
    ZCONST ZCHAR *pcValue);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_UE_H__ */

