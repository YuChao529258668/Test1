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
  File name     : mtc_group.h
  Module        : multimedia talk client
  Author        : Junjie Wang
  Created on    : 2016-08-23
*************************************************/
#ifndef _MTC_GROUP_H__
#define _MTC_GROUP_H__

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
 * @file mtc_group.h
 * @brief MTC Group Interface Functions
 *
 * This file includes group interface function.
 */

/** @brief Failure reasons. */
typedef enum EN_MTC_GROUP_REASON_TYPE
{
    EN_MTC_GROUP_REASON_BASE = 2000,                  /**< @brief Base of reason number. */
    EN_MTC_GROUP_REASON_GET_AGENT,                    /**< @brief Internal error get agent failed. */
    EN_MTC_GROUP_REASON_SERVER,                       /**< @brief Server error. */
    EN_MTC_GROUP_REASON_SERVER_UPDATE_TIME_INVALID,   /**< @brief Server error update time invalid. */
    EN_MTC_GROUP_REASON_SERVER_PERMISSION_DENIED,     /**< @brief Server error permission denied. */
    EN_MTC_GROUP_REASON_SERVER_UID_NOT_FOUND,         /**< @brief Server error uid is not found. */
    EN_MTC_GROUP_REASON_SERVER_CHANGE_NOT_EXISTS,     /**< @brief Server error change relation that not exists. */
    EN_MTC_GROUP_REASON_SERVER_ADD_ALREADY_EXISTS,    /**< @brief Server error add relation that already exists. */
} EN_MTC_GROUP_REASON_TYPE;

/** @brief Group type. */
typedef enum EN_MTC_GROUP_TYPE
{
    EN_MTC_GROUP_DISCUSSION = 0,            /**< @brief Discussion group. */
    EN_MTC_GROUP_NORMAL,                    /**< @brief Normal group. */
    EN_MTC_GROUP_LARGE,                     /**< @brief Group contains large number of members. */
    EN_MTC_GROUP_ROOM,                      /**< @brief Temporary group. */
    EN_MTC_GROUP_LARGE_ROOM                 /**< @brief Temporary group contains large number of members. */
} EN_MTC_GROUP_TYPE;

/** @brief Type of how to get updated information of group. */
typedef enum EN_MTC_GROUP_UPATE_METHOD_TYPE
{
    EN_MTC_GROUP_NOTIFICATION = 0,   /**< @brief Server initiates a notification when changed. */
    EN_MTC_GROUP_FETCH,              /**< @brief Client fetch information. */
    EN_MTC_GROUP_MIXED               /**< @brief Use mixing methods. */
} EN_MTC_GROUP_UPATE_METHOD_TYPE;

/** @brief Permission control type of join into the group. */
typedef enum EN_MTC_GROUP_PERMISSION_TYPE
{
    EN_MTC_GROUP_ADMIN_AUTHORIZATION = 0,   /**< @brief Requires authorization by manager or owner of group. */
    EN_MTC_GROUP_MEMBER_AUTHORIZATION,      /**< @brief Requires authorization by member of group. */
    EN_MTC_GROUP_NO_CONTROL,                /**< @brief No permission control. */
    EN_MTC_GROUP_PASSWORD                   /**< @brief Requires password. */
} EN_MTC_GROUP_PERMISSION_TYPE;

/** @brief Relation type. */
typedef enum EN_MTC_GROUP_RELATION_TYPE
{
    EN_MTC_GROUP_RELATION_IN_GROUP = 0x100,
    EN_MTC_GROUP_RELATION_OWNER,            /**< @brief Owner. */
    EN_MTC_GROUP_RELATION_MANAGER,          /**< @brief Manager. */
    EN_MTC_GROUP_RELATION_MEMBER,           /**< @brief Member. */

    EN_MTC_GROUP_RELATION_WITH_GROUP = 0x1000,
    EN_MTC_GROUP_RELATION_BELONGS_TO,       /**< @brief Belongs to group. */
} EN_MTC_GROUP_RELATION_TYPE;

/** @brief Resource ID type. */
typedef enum EN_MTC_GROUP_RESOURCE_ID_TYPE
{
    EN_MTC_GROUP_RESOURCE_ID_GROUP = 0,     /**< @brief Type for Group ID. */
    EN_MTC_GROUP_RESOURCE_ID_UID,           /**< @brief Type for User ID. */
} EN_MTC_GROUP_RESOURCE_ID_TYPE;

/** @brief Property permission type. */
typedef enum EN_MTC_GROUP_PROPERTY_CONTROL_TYPE
{
    EN_MTC_GROUP_PROPERTY_CONTROL_OWNER = 0,     /**< @brief Only writeable to owner. */
    EN_MTC_GROUP_PROPERTY_CONTROL_MANAGER,       /**< @brief Writeable to manager and owner. */
    EN_MTC_GROUP_PROPERTY_CONTROL_MEMBER,        /**< @brief Writeable to all members. */
} EN_MTC_GROUP_PROPERTY_CONTROL_TYPE;

/**
 * @defgroup MtcGroupPropKey Keys for property of group.
 * @{
 */

/**
 * @brief A key whose value is string object reflecting
 * the name of group.
 */
#define MtcGroupPropNameKey "Name"

/**
 * @brief A key whose value is number object reflecting
 * the type of group, @ref EN_MTC_GROUP_TYPE.
 */
#define MtcGroupPropTypeKey "Type"

/**
 * @brief A key whose value is number object reflecting
 * the type of how to get updated information of group,
 * @ref EN_MTC_GROUP_UPATE_METHOD_TYPE.
 */
#define MtcGroupPropUpdateMethodKey "UpdateMethod"

/**
 * @brief A key whose value is boolean object reflecting
 * if there is a link to group in personal list.
 */
#define MtcGroupPropLinkedKey "Linked"

/**
 * @brief A key whose value is number object reflecting
 * the permission control type of join into the group,
 * @ref EN_MTC_GROUP_PERMISSION_TYPE.
 */
#define MtcGroupPropPermissionKey "Permission"

/**
 * @brief A key whose value is boolean object reflecting
 * whether requires the invitee must to confirm the invitation 
 * before join into the group.
 */
#define MtcGroupPropInviteeConfirmKey "InviteeConfirm"

/**
 * @brief A key whose value is number object reflecting
 * the write permission level of group property, 
 * @ref EN_MTC_GROUP_PROPERTY_CONTROL_TYPE.
 */
#define MtcGroupPropControlKey "PropertyControl"

/**
 * @}
 */

/**
 * @defgroup MtcGroupKey MTC notification key for group.
 * @{
 */

/**
 * @brief A key whose value is a number object reflecting
 * the failure reason, @ref EN_MTC_GROUP_REASON_TYPE.
 */
#define MtcGroupReasonCodeKey "ReasonCode"

/**
 * @brief A key whose value is a string object reflecting
 * the failure details.
 */
#define MtcGroupReasonDetailKey "ReasonDetail"

/**
 * @brief A key whose value is a object contains
 * the properties of group, @ref MtcGroupPropKey.
 */
#define MtcGroupPropertiesKey "Properties"

/**
 * @brief A key whose value is number object indicates
 * the type of resource ID @ref EN_MTC_GROUP_RESOURCE_ID_TYPE.
 */
#define MtcGroupRidTypeKey "RidType"

/**
 * @brief A key whose value is a string object reflecting
 * the id of a group.
 */
#define MtcGroupRidKey "Rid"

/**
 * @brief A key whose value is a string object reflecting
 * the UID of a user.
 */
#define MtcGroupUserUidKey "UserUid"

/**
 * @brief A key whose value is a string object reflecting
 * the user uri.
 */
#define MtcGroupUserUriKey "UserUri"

/**
 * @brief A key whose value is a list of relation objects
 * that representing relations.
 * Each object contains several fields:
 * Required: @ref MtcGroupRelationTypeKey, @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey, @ref MtcGroupDisplayNameKey.
 * Optional: @ref MtcGroupTagKey.
 */
#define MtcGroupRelationListKey "RelationList"

/**
 * @brief A key whose value is a list of relation objects
 * that representing new added relations.
 * Each object contains several fields:
 * Required: @ref MtcGroupRelationTypeKey, @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey, @ref MtcGroupDisplayNameKey.
 * Optional: @ref MtcGroupTagKey.
 */
#define MtcGroupAddedRelationListKey "AddedRelationList"

/**
 * @brief A key whose value is a list of relation objects
 * that representing changed relations.
 * Each object contains several fields:
 * Required: @ref MtcGroupRelationTypeKey, @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey, @ref MtcGroupDisplayNameKey.
 * Optional: @ref MtcGroupTagKey.
 */
#define MtcGroupChangedRelationListKey "ChangedRelationList"

/**
 * @brief A key whose value is a list of string objects
 * that representing removed uids
 */
#define MtcGroupRemovedRelationListKey "RemovedRelationList"

/**
 * @brief A key whose value is a list of relation objects
 * that representing relations.
 * Each object contains several fields:
 * @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey, 
 * and other key value set by Mtc_GroupSetRelationStatus.
 */
#define MtcGroupStatusListKey "StatusList"

/**
 * @brief A key whose value is an integer reflecting
 * the relation type of a relation, @ref EN_MTC_GROUP_RELATION_TYPE
 */
#define MtcGroupRelationTypeKey "RelationType"

/**
 * @brief A key whose value is an integer object reflecting
 * the update time of server change.
 */
#define MtcGroupUpdateTimeKey "UpdateTime"

/**
 * @brief A key whose value is an integer object reflecting
 * the base time of server change.
 */
#define MtcGroupBaseTimeKey "BaseTime"

/**
 * @brief A key whose value is an boolean object reflecting
 * the update information is full or partial.
 */
#define MtcGroupIsPartialUpdateKey "IsPartialUpdate"

/**
 * @brief A key whose value is a string object reflecting
 * the display name of a relation.
 */
#define MtcGroupDisplayNameKey "DisplayName"

/**
 * @brief A key whose value is a string object reflecting
 * the tag of a relation.
 */
#define MtcGroupTagKey "Tag"

/** @} */

/**
 * @defgroup MtcGroupNotification MTC notification names for group.
 * @{
 */

/**
 * @brief Posted when create successfully.
 *
 * The pcInfo of this notification contains @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey,
 * @ref MtcGroupPropertiesKey.
 */
#define MtcGroupCreateOkNotification "MtcGroupCreateOkNotification"

/**
 * @brief Posted when failed to create.
 *
 * The pcInfo of this notification contains @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey,
 * @ref MtcGroupReasonCodeKey, @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupCreateDidFailNotification "MtcGroupCreateDidFailNotification"

/**
 * @brief Posted when remove successfully.
 *
 * The pcInfo of this notification contains @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey.
 */
#define MtcGroupRemoveOkNotification "MtcGroupRemoveOkNotification"

/**
 * @brief Posted when failed to remove.
 *
 * The pcInfo of this notification contains @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey,
 * @ref MtcGroupReasonCodeKey, @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupRemoveDidFailNotification "MtcGroupRemoveDidFailNotification"

/**
 * @brief Posted when set properties successfully.
 *
 * The pcInfo of this notification contains @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey.
 */
#define MtcGroupSetPropertiesOkNotification "MtcGroupSetPropertiesOkNotification"

/**
 * @brief Posted when failed to set properties.
 *
 * The pcInfo of this notification contains @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey,
 * @ref MtcGroupReasonCodeKey, @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupSetPropertiesDidFailNotification "MtcGroupSetPropertiesDidFailNotification"

/**
 * @brief Posted when get properties successfully.
 *
 * The pcInfo of this notification contains @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey.
 */
#define MtcGroupGetPropertiesOkNotification "MtcGroupGetPropertiesOkNotification"

/**
 * @brief Posted when failed to get properties.
 *
 * The pcInfo of this notification contains @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey,
 * @ref MtcGroupReasonCodeKey, @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupGetPropertiesDidFailNotification "MtcGroupGetPropertiesDidFailNotification"

/**
 * @brief Posted when refresh successfully.
 *
 * The pcInfo of this notification contains @ref MtcGroupUpdateTimeKey,
 * @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey, @ref MtcGroupAddedRelationListKey,
 * @ref MtcGroupChangedRelationListKey, @ref MtcGroupRemovedRelationListKey.
 */
#define MtcGroupRefreshOkNotification "MtcGroupRefreshOkNotification"

/**
 * @brief Posted when failed to refresh.
 *
 * The pcInfo of this notification contains @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey,
 * @ref MtcGroupReasonCodeKey, @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupRefreshDidFailNotification "MtcGroupRefreshDidFailNotification"

/**
 * @brief Posted when group list changed.
 *
 * The pcInfo of this notification contains @ref MtcGroupUpdateTimeKey,
 * @ref MtcGroupRidTypeKey, @ref MtcGroupRidKey, @ref MtcGroupAddedRelationListKey,
 * @ref MtcGroupChangedRelationListKey, @ref MtcGroupRemovedRelationListKey.
 */
#define MtcGroupChangedNotification "MtcGroupChangedNotification"

/**
 * @brief Posted when add relation successfully.
 *
 * The pcInfo of this notification contains @ref MtcGroupUpdateTimeKey.
 */
#define MtcGroupAddRelationOkNotification "MtcGroupAddRelationOkNotification"

/**
 * @brief Posted when failed to add relation.
 *
 * The pcInfo of this notification contains @ref MtcGroupReasonCodeKey, @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupAddRelationDidFailNotification "MtcGroupAddRelationDidFailNotification"

/**
 * @brief Posted when update relation successfully.
 *
 * The pcInfo of this notification contains @ref MtcGroupUpdateTimeKey.
 */
#define MtcGroupUpdateRelationOkNotification "MtcGroupUpdateRelationOkNotification"

/**
 * @brief Posted when failed to update relation.
 *
 * The pcInfo of this notification contains @ref MtcGroupReasonCodeKey, @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupUpdateRelationDidFailNotification "MtcGroupUpdateRelationDidFailNotification"

/**
 * @brief Posted when remove relation successfully.
 *
 * The pcInfo of this notification contains @ref MtcGroupUpdateTimeKey.
 */
#define MtcGroupRemoveRelationOkNotification "MtcGroupRemoveRelationOkNotification"

/**
 * @brief Posted when failed to remove relation.
 *
 * The pcInfo of this notification contains @ref MtcGroupReasonCodeKey, @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupRemoveRelationDidFailNotification "MtcGroupRemoveRelationDidFailNotification"

/**
 * @brief Posted when set relations successfully.
 *
 * The pcInfo of this notification contains @ref MtcGroupUpdateTimeKey.
 */
#define MtcGroupSetRelationsOkNotification "MtcGroupSetRelationsOkNotification"

/**
 * @brief Posted when failed to set relations.
 *
 * The pcInfo of this notification contains @ref MtcGroupReasonCodeKey, @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupSetRelationsDidFailNotification "MtcGroupSetRelationsDidFailNotification"

/**
 * @brief Posted when set relation status successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcGroupRidTypeKey, 
 * @ref MtcGroupRidKey,
 * @ref MtcGroupUserUidKey.
 */
#define MtcGroupSetRelationStatusOkNotification "MtcGroupSetRelationStatusOkNotification"

/**
 * @brief Posted when failed to set relation status.
 *
 * The pcInfo of this notification contains
 * @ref MtcGroupReasonCodeKey, 
 * @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupSetRelationStatusDidFailNotification "MtcGroupSetRelationStatusDidFailNotification"

/**
 * @brief Posted when get relation status successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcGroupRidTypeKey, 
 * @ref MtcGroupRidKey,
 * @ref MtcGroupRelationListKey.
 */
#define MtcGroupGetRelationStatusOkNotification "MtcGroupGetRelationStatusOkNotification"

/**
 * @brief Posted when failed to get relation status.
 *
 * The pcInfo of this notification contains
 * @ref MtcGroupReasonCodeKey, 
 * @ref MtcGroupReasonDetailKey.
 */
#define MtcGroupGetRelationStatusDidFailNotification "MtcGroupGetRelationStatusDidFailNotification"

/** @} */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Create group.
 *
 * @param  zCookie The cookie value.
 * @param  iType The group type, @ref EN_MTC_GROUP_TYPE.
 * @param  pcName The group name.
 * @param  pcInfo The properties information in JSON, @ref MtcGroupPropKey.
 * @param  pcRelationsToAdd The string in JSON, which is an array. Each item must contains
 *                 @ref MtcGroupUserUidKey, @ref MtcGroupRelationTypeKey
 *                 @ref MtcGroupDisplayNameKey, @ref MtcGroupTagKey.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupCreateOkNotification
 * or @ref MtcGroupCreateDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupCreate(ZCOOKIE zCookie, ZUINT iType, ZCONST ZCHAR *pcName,
    ZCONST ZCHAR *pcInfo, ZCONST ZCHAR *pcRelationsToAdd);

/**
 * @brief Remove group.
 *
 * @param  zCookie The cookie value.
 * @param  pcGroupId The group ID.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupRemoveOkNotification
 * or @ref MtcGroupRemoveDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupRemove(ZCOOKIE zCookie, ZCONST ZCHAR *pcGroupId);

/**
 * @brief Update group properties.
 *
 * @param  zCookie The cookie value.
 * @param  pcGroupId The group ID.
 * @param  pcInfo The properties information in JSON, contains
 * @ref MtcGroupPropNameKey, @ref MtcGroupPropPermissionKey
 * @ref MtcGroupPropInviteeConfirmKey.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupSetPropertiesOkNotification
 * or @ref MtcGroupSetPropertiesDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupSetProperties(ZCOOKIE zCookie, ZCONST ZCHAR *pcGroupId,
    ZCONST ZCHAR *pcInfo);

/**
 * @brief Get group properties.
 *
 * @param  zCookie The cookie value.
 * @param  pcGroupId The group ID.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupGetPropertiesOkNotification
 * or @ref MtcGroupGetPropertiesDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupGetProperties(ZCOOKIE zCookie, ZCONST ZCHAR *pcGroupId);

/**
 * @brief Refresh all relations
 *
 * @param  zCookie The cookie value.
 * @param  pcGroupId The string of GroupID, ZNULL to refresh self group list.
 * @param  qwUpdateTime The start time point to refresh
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupRefreshOkNotification
 * or @ref MtcGroupRefreshDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupRefresh(ZCOOKIE zCookie, ZCONST ZCHAR *pcGroupId,
    ZINT64 qwUpdateTime);

/**
 * @brief Add relation
 *
 * @param  zCookie The cookie value.
 * @param  pcGroupId The string of GroupID, ZNULL to operate on self group list.
 * @param  iRelationType The relation type, @ref EN_MTC_GROUP_RELATION_TYPE
 * @param  pcUriOrUid The uri or uid of the user
 * @param  pcDisplayName The display name of the relation
 * @param  pcTag The tag info of the relation that may contains 
 *         @ref MtcGroupTagKey
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupAddRelationOkNotification
 * or @ref MtcGroupAddRelationDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupAddRelation(ZCOOKIE zCookie, ZCONST ZCHAR *pcGroupId,
    ZINT iRelationType, ZCONST ZCHAR *pcUriOrUid, ZCONST ZCHAR *pcDisplayName,
    ZCONST ZCHAR *pcTag);

/**
 * @brief Update relation
 *
 * @param  zCookie The cookie value.
 * @param  pcGroupId The string of GroupID, ZNULL to operate on self group list.
 * @param  iRelationType The relation type, @ref EN_MTC_GROUP_RELATION_TYPE
 * @param  pcUriOrUid The uri or uid of the user
 * @param  pcDisplayName The display name of the relation
 * @param  pcTag The tag info of the relation that may contains 
 *         @ref MtcGroupTagKey
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupUpdateRelationOkNotification
 * or @ref MtcGroupUpdateRelationDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupUpdateRelation(ZCOOKIE zCookie, ZCONST ZCHAR *pcGroupId,
    ZINT iRelationType, ZCONST ZCHAR *pcUriOrUid, ZCONST ZCHAR *pcDisplayName,
    ZCONST ZCHAR *pcTag);

/**
 * @brief Remove relation
 *
 * @param  zCookie The cookie value.
 * @param  pcGroupId The string of GroupID, ZNULL to operate on self group list.
 * @param  pcUriOrUid The uri or uid of the user
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupRemoveRelationOkNotification
 * or @ref MtcGroupRemoveRelationDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupRemoveRelation(ZCOOKIE zCookie, ZCONST ZCHAR *pcGroupId,
    ZCONST ZCHAR *pcUriOrUid);

/**
 * @brief Set batch relations
 *
 * @param  zCookie The cookie value.
 * @param  pcGroupId The string of GroupID, ZNULL to operate on self group list.
 * @param  pcRelationsToAdd The string in JSON, which is an array. Each item must contains
 *                 @ref MtcGroupUserUidKey, @ref MtcGroupRelationTypeKey
 *                 @ref MtcGroupDisplayNameKey.
 * @param  pcRelationsToChange The string in JSON, which is an array. Each item must contains
 *                 @ref MtcGroupUserUidKey, @ref MtcGroupRelationTypeKey
 *                 @ref MtcGroupDisplayNameKey.
 * @param  pcUidsToRemove The string of JSON, which is an array. Each item is
 *                 UID of user.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupSetRelationsOkNotification
 * or @ref MtcGroupSetRelationsDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupSetRelations(ZCOOKIE zCookie, ZCONST ZCHAR *pcGroupId,
    ZCONST ZCHAR *pcRelationsToAdd, ZCONST ZCHAR *pcRelationsToChange, ZCONST ZCHAR *pcUidsToRemove);

/**
 * @brief Set relation status.
 *
 * @param  zCookie The cookie value.
 * @param  pcGroupId The string of GroupID, ZNULL to operate on self group list.
 * @param  pcUid The uid of the user
 * @param  pcKey The status key
 * @param  pcValue The status value
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupSetRelationStatusOkNotification
 * or @ref MtcGroupSetRelationStatusDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupSetRelationStatus(ZCOOKIE zCookie, ZCONST ZCHAR *pcGroupId,
    ZCONST ZCHAR *pcUid, ZCONST ZCHAR *pcKey, ZCONST ZCHAR *pcValue);

/**
 * @brief Get relation status.
 *
 * @param  zCookie The cookie value.
 * @param  pcGroupId The string of GroupID, ZNULL to operate on self group list.
 * @param  pcUids The uid of the user, or a string which is a JSON array, each item
 *              is the uid of the user.
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcGroupGetRelationStatusOkNotification
 * or @ref MtcGroupGetRelationStatusDidFailNotification.
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_GroupGetRelationStatus(ZCOOKIE zCookie, ZCONST ZCHAR *pcGroupId,
    ZCONST ZCHAR *pcUids);

/**
 * @brief Get self uid
 *
 * @retval The uid of the logined user
 */
MTCFUNC ZCONST ZCHAR * Mtc_GroupGetUid();

/**
 * @brief Check is valid group ID.
 *
 * @return ZTRUE, the string is valid group ID.
 */
MTCFUNC ZBOOL Mtc_GroupIsValidGroupId(ZCONST ZCHAR *pcStr);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_GROUP_H__ */

