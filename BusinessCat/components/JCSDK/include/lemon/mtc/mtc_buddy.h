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
  File name     : mtc_buddy.h
  Module        : multimedia talk client
  Author        : xiangbo.hui
  Created on    : 2015-03-27
  Description   :
      Data structure and function declare required by MTC statistics

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_BUDDY_H__
#define _MTC_BUDDY_H__

#include <avatar/zos/zos_type.h>

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
 * @file mtc_buddy.h
 * @brief MTC Buddy Interface Functions
 *
 * This file includes buddy interface function.
 */

/** @brief Failure reasons. */
typedef enum EN_MTC_BUDDY_REASON_TYPE
{
    EN_MTC_BUDDY_REASON_BASE = 7000,                  /**< @brief Base of reason number. */
    EN_MTC_BUDDY_REASON_GET_AGENT,                    /**< @brief Internal error get agent failed. */
    EN_MTC_BUDDY_REASON_SERVER,                       /**< @brief Server error. */
    EN_MTC_BUDDY_REASON_SERVER_UPDATE_TIME_INVALID,   /**< @brief Server error update time invalid. */
    EN_MTC_BUDDY_REASON_SERVER_PERMISSION_DENIED,     /**< @brief Server error permission denied. */
    EN_MTC_BUDDY_REASON_SERVER_UID_NOT_FOUND,         /**< @brief Server error uid is not found. */
    EN_MTC_BUDDY_REASON_SERVER_CHANGE_NOT_EXISTS,     /**< @brief Server error change relation that not exists. */
    EN_MTC_BUDDY_REASON_SERVER_ADD_ALREADY_EXISTS,    /**< @brief Server error add relation that already exists. */
} EN_MTC_BUDDY_REASON_TYPE;

/** @brief Relation type. */
typedef enum EN_MTC_BUDDY_RELATION_TYPE
{
    EN_MTC_BUDDY_RELATION_WITH_PERSON = 0,
    EN_MTC_BUDDY_RELATION_CONTACT,          /**< @brief Contact. */
    EN_MTC_BUDDY_RELATION_FRIEND,           /**< @brief Friend. */
    EN_MTC_BUDDY_RELATION_BLACKLIST,        /**< @brief Blacklist. */
    EN_MTC_BUDDY_RELATION_STRANGER,         /**< @brief Stragner. */
    EN_MTC_BUDDY_RELATION_CLOSE_FRIEND,     /**< @brief Close friend. */
    EN_MTC_BUDDY_RELATION_FOLLOW,           /**< @brief Follow. */
} EN_MTC_BUDDY_RELATION_TYPE;

/**
 * @defgroup MtcBuddyKey MTC notification key for buddy.
 * @{
 */

/**
 * @brief A key whose value is a string object reflecting
 * the buddy's URI.
 */
#define MtcBuddyUriKey              "MtcBuddyUriKey"

/**
 * @brief A key whose value is a string object reflecting
 * the buddy's UserID.
 */
#define MtcBuddyUidKey              "MtcBuddyUidKey"

/**
 * @brief A key whose value is a string object reflecting
 * the buddy's reason key.
 */
#define MtcBuddyReasonKey           "MtcBuddyReasonKey"

/**
 * @brief A key whose value is a string object reflecting
 * the failure details.
 */
#define MtcBuddyReasonDetailKey     "ReasonDetail"

/**
 * @brief A key whose value is a string object reflecting
 * the property's name
 */
#define MtcBuddyPropertyNameKey     "MtcBuddyPropertyNameKey"

/**
 * @brief A key whose value is a string object reflecting
 * the property's value
 */
#define MtcBuddyPropertyValueKey    "MtcBuddyPropertyValueKey"

/**
 * @brief A key whose value is a number reflecting the account's status,
 * @ref group_def_account_status.
 */
#define MtcBuddyStatusKey           "Status"

/**
 * @brief A key whose value is a number object reflecting
 * the login date time by UNIX timestamp.
 */
#define MtcBuddyPropertyDateKey     "Date"

/**
 * @brief A key whose value is a string object reflecting
 * the brand of device.
 */
#define MtcBuddyPropertyBrandKey    "Brand"

/**
 * @brief A key whose value is a string object reflecting
 * the model of device.
 */
#define MtcBuddyPropertyModelKey    "Model"

/**
 * @brief A key whose value is a string object reflecting
 * the OS version of device.
 */
#define MtcBuddyPropertyVersionKey  "Ver"

/**
 * @brief A key whose value is a string object reflecting
 * the application version.
 */
#define MtcBuddyPropertyAppVersionKey   "AppVer"

/**
 * @brief A key whose value is an integer object reflecting
 * the update time of server change.
 */
#define MtcBuddyUpdateTimeKey "UpdateTime"

/**
 * @brief A key whose value is an integer object reflecting
 * the base time of server change.
 */
#define MtcBuddyBaseTimeKey "BaseTime"

/**
 * @brief A key whose value is an boolean object reflecting
 * the update information is full or partial.
 */
#define MtcBuddyIsPartialUpdateKey "IsPartialUpdate"

/**
 * @brief A key whose value is an integer reflecting
 * the relation type of a relation, @ref EN_MTC_BUDDY_RELATION_TYPE
 */
#define MtcBuddyRelationTypeKey "RelationType"

/**
 * @brief A key whose value is a string object reflecting
 * the display name of a relation.
 */
#define MtcBuddyDisplayNameKey "DisplayName"

/**
 * @brief A key whose value is a string object reflecting
 * the tag of a relation.
 */
#define MtcBuddyTagKey "Tag"

/**
 * @brief A key whose value is a list of relation objects
 * that representing relations.
 * Each object contains several fields:
 * @ref MtcBuddyRelationTypeKey,
 * @ref MtcBuddyUidKey, 
 * @ref MtcBuddyDisplayNameKey.
 * @ref MtcBuddyTagKey.
 */
#define MtcBuddyRelationListKey "RelationList"

/**
 * @brief A key whose value is a array of relation objects
 * that representing new added relations.
 * Each object contains several fields:
 * @ref MtcBuddyRelationTypeKey,
 * @ref MtcBuddyUidKey, 
 * @ref MtcBuddyDisplayNameKey.
 * @ref MtcBuddyTagKey.
 */
#define MtcBuddyAddedRelationListKey "AddedRelationList"

/**
 * @brief A key whose value is a array of relation objects
 * that representing changed relations.
 * Each object contains several fields:
 * @ref MtcBuddyRelationTypeKey,
 * @ref MtcBuddyUidKey, 
 * @ref MtcBuddyDisplayNameKey.
 * @ref MtcBuddyTagKey.
 */
#define MtcBuddyChangedRelationListKey "ChangedRelationList"

/**
 * @brief A key whose value is a array of string objects
 * that representing removed UserIDs
 */
#define MtcBuddyRemovedRelationListKey "RemovedRelationList"

/**
 * @brief A key whose value is a list of relation objects
 * that representing relations.
 * Each object contains several fields:
 * @ref MtcBuddyUidKey, 
 * and other key value set by Mtc_BuddySetMyStatus.
 */
#define MtcBuddyStatusListKey "StatusList"

/** @} */

/**
 * @defgroup MtcBuddyNotification MTC notification names for buddy.
 * @{
 */

/**
 * @brief Posted when query buddy property successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyUriKey, @ref MtcBuddyPropertyNameKey and @ref MtcBuddyPropertyValueKey.
 */
#define MtcBuddyQueryPropertyOkNotification "MtcBuddyQueryPropertyOkNotification"

/**
 * @brief Posted when query buddy property failed.
 *
 * The pcInfo of this notification is contains
 * @ref MtcBuddyUriKey, @ref MtcBuddyReasonKey.
 */
#define MtcBuddyQueryPropertyDidFailNotification "MtcBuddyQueryPropertyDidFailNotification"

/**
 * @brief Posted when query buddy login information successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyUriKey, @ref MtcBuddyStatusKey, @ref MtcBuddyPropertyDateKey,
 * @ref MtcBuddyPropertyBrandKey, @ref MtcBuddyPropertyModelKey,
 * @ref MtcBuddyPropertyVersionKey, @ref MtcBuddyPropertyAppVersionKey.
 */
#define MtcBuddyQueryLoginPropertiesOkNotification "MtcBuddyQueryLoginPropertiesOkNotification"

/**
 * @brief Posted when query buddy login information failed.
 *
 * The pcInfo of this notification is contains
 * @ref MtcBuddyUriKey, @ref MtcBuddyReasonKey.
 */
#define MtcBuddyQueryLoginPropertiesDidFailNotification "MtcBuddyQueryLoginPropertiesDidFailNotification"

/**
 * @brief Posted when query buddy login information successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyUriKey, @ref MtcBuddyStatusKey.
 */
#define MtcBuddyQueryLoginInfoOkNotification "MtcBuddyQueryLoginInfoOkNotification"

/**
 * @brief Posted when query buddy login information failed.
 *
 * The pcInfo of this notification is contains
 * @ref MtcBuddyUriKey, @ref MtcBuddyReasonKey.
 */
#define MtcBuddyQueryLoginInfoDidFailNotification "MtcBuddyQueryLoginInfoDidFailNotification"

/**
 * @brief Posted when query buddys' UserId successfully.
 *
 * The pcInfo of this notification contains an array of UserId map item.
 * Each item is an array of string, the first string is User's URI,
 * the second string is corresponding UserId.
 */
#define MtcBuddyQueryUserIdOkNotification "MtcBuddyQueryUserIdOkNotification"

/**
 * @brief Posted when query buddys' UserId failed.
 *
 * The pcInfo is ZNULL.
 */
#define MtcBuddyQueryUserIdDidFailNotification "MtcBuddyQueryUserIdDidFailNotification"

/**
 * @brief Posted when query buddys' AccountId successfully.
 *
 * The pcInfo of this notification contains an array of AccountId map item.
 * Each item is an array of string, the first string is User's UserId,
 * following string is the AccountId associated with this user.
 */
#define MtcBuddyQueryAccountIdOkNotification "MtcBuddyQueryAccountIdOkNotification"

/**
 * @brief Posted when query buddys' AccountId failed.
 *
 * The pcInfo is ZNULL.
 */
#define MtcBuddyQueryAccountIdDidFailNotification "MtcBuddyQueryAccountIdDidFailNotification"

/**
 * @brief Posted when query users' status successfully.
 *
 * The pcInfo of this notification is an array, each item contains
 * @ref MtcBuddyUriKey, @ref MtcBuddyStatusKey.
 */
#define MtcBuddyQueryUsersStatusOkNotification "MtcBuddyQueryUsersStatusOkNotification"

/**
 * @brief Posted when query users' status failed.
 *
 * The pcInfo is ZNULL.
 */
#define MtcBuddyQueryUsersStatusDidFailNotification "MtcBuddyQueryUsersStatusDidFailNotification"

/**
 * @brief Posted when refresh successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyUpdateTimeKey,
 * @ref MtcBuddyBaseTimeKey,
 * @ref MtcBuddyIsPartialUpdateKey,
 * @ref MtcBuddyRelationListKey,
 * @ref MtcBuddyAddedRelationListKey,
 * @ref MtcBuddyChangedRelationListKey
 * @ref MtcBuddyRemovedRelationListKey.
 */
#define MtcBuddyRefreshOkNotification "MtcBuddyRefreshOkNotification"

/**
 * @brief Posted when failed to refresh.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyReasonKey,
 * @ref MtcBuddyReasonDetailKey.
 */
#define MtcBuddyRefreshDidFailNotification "MtcBuddyRefreshDidFailNotification"

/**
 * @brief Posted when buddy list changed.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyUpdateTimeKey,
 * @ref MtcBuddyBaseTimeKey,
 * @ref MtcBuddyIsPartialUpdateKey,
 * @ref MtcBuddyChangedRelationListKey,
 * @ref MtcBuddyRemovedRelationListKey.
 */
#define MtcBuddyChangedNotification "MtcBuddyChangedNotification"

/**
 * @brief Posted when add relation successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyUpdateTimeKey.
 */
#define MtcBuddyAddRelationOkNotification "MtcBuddyAddRelationOkNotification"

/**
 * @brief Posted when failed to add relation.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyReasonKey,
 * @ref MtcBuddyReasonDetailKey.
 */
#define MtcBuddyAddRelationDidFailNotification "MtcBuddyAddRelationDidFailNotification"

/**
 * @brief Posted when update relation successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyUpdateTimeKey.
 */
#define MtcBuddyUpdateRelationOkNotification "MtcBuddyUpdateRelationOkNotification"

/**
 * @brief Posted when failed to update relation.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyReasonKey,
 * @ref MtcBuddyReasonDetailKey.
 */
#define MtcBuddyUpdateRelationDidFailNotification "MtcBuddyUpdateRelationDidFailNotification"

/**
 * @brief Posted when remove relation successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyUpdateTimeKey.
 */
#define MtcBuddyRemoveRelationOkNotification "MtcBuddyRemoveRelationOkNotification"

/**
 * @brief Posted when failed to remove relation.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyReasonKey,
 * @ref MtcBuddyReasonDetailKey.
 */
#define MtcBuddyRemoveRelationDidFailNotification "MtcBuddyRemoveRelationDidFailNotification"

/**
 * @brief Posted when set relation status successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyUidKey, 
 */
#define MtcBuddySetMyStatusOkNotification "MtcBuddySetMyStatusOkNotification"

/**
 * @brief Posted when failed to set relation status.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyUidKey, 
 * @ref MtcBuddyReasonKey, 
 * @ref MtcBuddyReasonDetailKey.
 */
#define MtcBuddySetMyStatusDidFailNotification "MtcBuddySetMyStatusDidFailNotification"

/**
 * @brief Posted when get relation status successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyStatusListKey.
 */
#define MtcBuddyGetRelationStatusOkNotification "MtcBuddyGetRelationStatusOkNotification"

/**
 * @brief Posted when failed to get relation status.
 *
 * The pcInfo of this notification contains
 * @ref MtcBuddyReasonKey, 
 * @ref MtcBuddyReasonDetailKey.
 */
#define MtcBuddyGetRelationStatusDidFailNotification "MtcBuddyGetRelationStatusDidFailNotification"

/**
 * @brief Posted when set relations successfully.
 *
 * The pcInfo of this notification contains @ref MtcBuddyUpdateTimeKey.
 */
#define MtcBuddySetRelationsOkNotification "MtcBuddySetRelationsOkNotification"

/**
 * @brief Posted when failed to set relations.
 *
 * The pcInfo of this notification contains @ref MtcBuddyReasonKey, @ref MtcBuddyReasonDetailKey.
 */
#define MtcBuddySetRelationsDidFailNotification "MtcBuddySetRelationsDidFailNotification"

/**
 * @brief Posted when add batch relations successfully.
 *
 * The pcInfo of this notification contains @ref MtcBuddyUpdateTimeKey, 
 * @ref MtcBuddyAddedRelationListKey.
 */
#define MtcBuddyAddBatchRelationsOkNotification "MtcBuddyAddBatchRelationsOkNotification"

/**
 * @brief Posted when failed to add batch relations.
 *
 * The pcInfo of this notification contains @ref MtcBuddyReasonKey, @ref MtcBuddyReasonDetailKey.
 */
#define MtcBuddyAddBatchRelationsDidFailNotification "MtcBuddyAddBatchRelationsDidFailNotification"

/** @} */

/**
 * @defgroup MtcBuddyReason MTC reason string.
 * @{
 */

#define MTC_ERROR_BUDDY_NOT_FOUND       "MtcBuddy.NotFound"
#define MTC_ERROR_BUDDY_NO_PROPERTY     "MtcBuddy.NoProperty"
#define MTC_ERROR_BUDDY_TIMEOUT         "MtcBuddy.Timeout"

/** @} */


#ifdef __cplusplus
extern "C" {
#endif

/** 
 * @brief Query buddy's property.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] pcUri The query user's URI.
 * @param [in] pcName The query property's name.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyQueryPropertyOkNotification 
 * or @ref MtcBuddyQueryPropertyDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyQueryProperty(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcUri, ZCONST ZCHAR *pcName);

/** 
 * @brief Query buddy's login information.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] pcUri The query user's URI.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyQueryLoginPropertiesOkNotification 
 * or @ref MtcBuddyQueryLoginPropertiesDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyQueryLoginProperties(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcUri);

/** 
 * @brief Query buddy's login information.
 *
 * @param [in] zCookie The cookie which you want to set.
 * @param [in] pcUri The query user's URI.
 * @param [in] iExpireSeconds The expiration seconds for query.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyQueryLoginInfoOkNotification 
 * or @ref MtcBuddyQueryLoginInfoDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyQueryLoginInfo(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcUri, ZINT iExpireSeconds);

/**
 * @brief Query buddy's UserId information.
 * 
 * @param  zCookie The cookie value.
 * @param  pcInfo  The query information. For just one user, using its URI directily.
 *                 For multiple users, it must be a string in JSON format,
 *                 which contains an array of string. Each string is the user's URI
 *                 which wants be queried.
 *                 
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyQueryUserIdOkNotification 
 * or @ref MtcBuddyQueryUserIdDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyQueryUserId(ZCOOKIE zCookie, ZCONST ZCHAR *pcInfo);

/**
 * @brief Query buddy's AccountId information.
 * 
 * @param  zCookie The cookie value.
 * @param  pcInfo  The query information. For just one user, using its UserId directily.
 *                 For multiple users, it must be a string in JSON format,
 *                 which contains an array of string. Each string is the user's UserId
 *                 which wants be queried.
 *                 
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyQueryAccountIdOkNotification 
 * or @ref MtcBuddyQueryAccountIdDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyQueryAccountId(ZCOOKIE zCookie, ZCONST ZCHAR *pcInfo);

/**
 * @brief Query users' login status.
 * 
 * @param  zCookie The cookie value
 * @param  pcInfo  For just one user, using its URI directily. 
 *                 For multiple users, it is a JSON array, each item is the string of user's URI.
 * 
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyQueryUsersStatusOkNotification
 * or @ref MtcBuddyQueryUsersStatusDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyQueryUsersStatus(ZCOOKIE zCookie, ZCONST ZCHAR *pcInfo);

/**
 * @brief Refresh all relations
 *
 * @param  zCookie The cookie value.
 * @param  qwUpdateTime The start time point to refresh
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyRefreshOkNotification
 * or @ref MtcBuddyRefreshDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyRefresh(ZCOOKIE zCookie, ZINT64 qwUpdateTime);

/**
 * @brief Add relation
 *
 * @param  zCookie The cookie value.
 * @param  iRelationType The relation type, @ref EN_MTC_BUDDY_RELATION_TYPE
 * @param  pcUid The UserID
 * @param  pcDisplayName The display name of the relation
 * @param  pcTag The tag info of the relation.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyAddRelationOkNotification
 * or @ref MtcBuddyAddRelationDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyAddRelation(ZCOOKIE zCookie, ZINT iRelationType,
    ZCONST ZCHAR *pcUid, ZCONST ZCHAR *pcDisplayName, ZCONST ZCHAR *pcTag);

/**
 * @brief Update relation
 *
 * @param  zCookie The cookie value.
 * @param  iRelationType The relation type, @ref EN_MTC_BUDDY_RELATION_TYPE
 * @param  pcUid The UserID
 * @param  pcDisplayName The display name of the relation
 * @param  pcTag The tag info of the relation.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyUpdateRelationOkNotification
 * or @ref MtcBuddyUpdateRelationDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyUpdateRelation(ZCOOKIE zCookie, ZINT iRelationType,
    ZCONST ZCHAR *pcUid, ZCONST ZCHAR *pcDisplayName, ZCONST ZCHAR *pcTag);

/**
 * @brief Remove relation
 *
 * @param  zCookie The cookie value.
 * @param  pcUid The UserID
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyRemoveRelationOkNotification
 * or @ref MtcBuddyRemoveRelationDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyRemoveRelation(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcUid);

/**
 * @brief Set status of mine to one buddy.
 *
 * @param  zCookie The cookie value.
 * @param  pcUid The uid of the user
 * @param  pcKey The status key
 * @param  pcValue The status value
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddySetMyStatusOkNotification
 * or @ref MtcBuddySetMyStatusDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddySetMyStatus(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcUid, ZCONST ZCHAR *pcKey, ZCONST ZCHAR *pcValue);

/**
 * @brief Get status of my buddies.
 *
 * @param  zCookie The cookie value.
 * @param  pcUids The uid of the user, or a string which is a JSON array, each item
 *              is the uid of the user.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyGetRelationStatusOkNotification
 * or @ref MtcBuddyGetRelationStatusDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyGetRelationStatus(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcUids);

/**
 * @brief Set batch relations
 *
 * @param  zCookie The cookie value.
 * @param  pcRelationsToAdd The string in JSON, which is an array. Each item must contains
 *                 @ref MtcBuddyUidKey, @ref MtcBuddyRelationTypeKey
 *                 @ref MtcBuddyDisplayNameKey.
 * @param  pcRelationsToChange The string in JSON, which is an array. Each item must contains
 *                 @ref MtcBuddyUidKey, @ref MtcBuddyRelationTypeKey
 *                 @ref MtcBuddyDisplayNameKey, @ref MtcBuddyTagKey.
 * @param  pcUidsToRemove The string of JSON, which is an array. Each item is
 *                 UID of user.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddySetRelationsOkNotification
 * or @ref MtcBuddySetRelationsDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddySetRelations(ZCOOKIE zCookie, ZCONST ZCHAR *pcRelationsToAdd, 
    ZCONST ZCHAR *pcRelationsToChange, ZCONST ZCHAR *pcUidsToRemove);

/**
 * @brief Add batch relations
 *
 * @param  zCookie The cookie value.
 * @param  pcInfo The string of JSON, which is an array. Each item must contains
 *                 @ref MtcBuddyUidKey, @ref MtcBuddyRelationTypeKey
 *                 @ref MtcBuddyDisplayNameKey, @ref MtcBuddyTagKey.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcBuddyAddBatchRelationsOkNotification
 * or @ref MtcBuddyAddBatchRelationsDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_BuddyAddBatchRelations(ZCOOKIE zCookie, ZCONST ZCHAR *pcInfo);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_BUDDY_H__ */

