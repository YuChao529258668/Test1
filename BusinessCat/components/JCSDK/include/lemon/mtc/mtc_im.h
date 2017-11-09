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
  File name     : mtc_im.h
  Module        : rich session enabler
  Author        : bob.liu
  Created on    : 2015-06-17
  Description   :
      Data structure and function declare required by mtc conference 

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_IM_H__
#define _MTC_IM_H__

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
 * @file
 * @brief MTC Instant Message Interfaces
 *
 * This file includes instant message interface function.
 */
#ifdef __cplusplus
extern "C" {
#endif

/**
 * @defgroup MtcImIdType MTC ID type.
 * @{
 */
/** @brief The ID is user's UID */
#define MTC_IM_ID_UID 1
/** @brief The ID is group's ID */
#define MTC_IM_ID_GROUP 2
/** @} */

/**
 * @defgroup MtcImKey MTC notification key of conference event.
 * @{
 */

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the unique ID of IM message.
 */
#define MtcImMsgIdKey                 "MtcImMsgIdKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the disposition notification ID of IM message.
 */
#define MtcImImdnIdKey                "MtcImImdnIdKey"

/**
 * @brief A key whose value is a string object in json format reflecting
 * the sender's UID.
 */
#define MtcImSenderUidKey             "MtcImSenderUidKey"

/**
 * @brief A key whose value is a string object in json format reflecting
 * the ID of source object where the message received from.
 */
#define MtcImLabelKey                "MtcImLabelKey"

/**
 * @brief A key whose value is a number object in json format reflecting
 * the type of the value of MtcImLabelKey, @ref MtcImIdType.
 */
#define MtcImCategoryKey            "MtcImCategoryKey"

/**
 * @brief A key whose value is a string object in json format reflecting
 * the user's URI.
 */
#define MtcImUserUriKey               "MtcImUserUriKey"

/**
 * @brief A key whose value is a number object in json format reflecting
 * the seconds from 00:00:00 Jun. 1st, 1970.
 */
#define MtcImTimeKey                  "MtcImTimeKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the conversation ID of message.
 */
#define MtcImConversationIdKey        "MtcImConversationIdKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the content text of message.
 */
#define MtcImTextKey                  "MtcImTextKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the digest of text message.
 */
#define MtcImDigestKey                "MtcImDigestKey"

/**
 * @brief A key whose value is a string object reflecting the information
 *  content.
 */
#define MtcImInfoContentKey           "MtcImInfoContentKey"

/**
 * @brief A key whose value is a string object reflecting the information
 *  type.
 */
#define MtcImInfoTypeKey              "MtcImInfoTypeKey"

/**
 * @brief A key whose value is a string object in json format reflecting
 * the display name.
 */
#define MtcImDisplayNameKey           "MtcImDisplayNameKey"

/**
 * @brief A key whose value is a string object in json format reflecting
 * the user data.
 */
#define MtcImUserDataKey              "MtcImUserDataKey"

/**
 * @brief A key whose value is array in JSON format. Each item is a string
 * reflecting the attachment file path.
 */
#define MtcImAttachmentKey            "MtcImAttachmentKey"

/**
 * @brief A key whose value is array in JSON format. Each item is a string
 * reflecting the attachment file path.
 */
#define MtcImAttachmentTagKey            "MtcImAttachmentTagKey"

/**
 * @brief A key whose value is array in JSON format. Each item is a string
 * reflecting the attachment file path.
 */
#define MtcImAttachmentFileKey            "MtcImAttachmentFileKey"
/** @} */

/**
 * @defgroup MtcImNotification MTC notification of conference event.
 * @{
 */

/**
 * @brief Posted when message send OK.
 *
 * The pcInfo of this notification contains @ref MtcImMsgIdKey.
 */
#define MtcImSendTextOkNotification         "MtcImSendTextOkNotification"

/**
 * @brief Posted when message send fail.
 *
 * The pcInfo is ZNULL.
 */
#define MtcImSendTextDidFailNotification    "MtcImSendTextDidFailNotification"

/**
 * @brief Posted when message send OK.
 *
 * The pcInfo of this notification contains @ref MtcImMsgIdKey.
 */
#define MtcImSendInfoOkNotification         "MtcImSendInfoOkNotification"

/**
 * @brief Posted when message send fail.
 *
 * The pcInfo is ZNULL.
 */
#define MtcImSendInfoDidFailNotification    "MtcImSendInfoDidFailNotification"

/**
 * @brief Posted when a text message received.
 *
 * The pcInfo of this notification contains @ref MtcImUserUriKey,
 * @ref MtcImMsgIdKey, @ref MtcImTimeKey, @ref MtcImTextKey.
 */
#define MtcImTextDidReceiveNotification "MtcImTextDidReceiveNotification"

/**
 * @brief Posted when a infomation message received.
 *
 * The pcInfo of this notification contains @ref MtcImMsgIdKey,
 * @ref MtcImUserUriKey, @ref MtcImTimeKey, @ref MtcImInfoTypeKey,
 * @ref MtcImInfoContentKey
 */
#define MtcImInfoDidReceiveNotification "MtcImInfoDidReceiveNotification"

/**
 * @brief Posted when all message has reported.
 *
 * The pcInfo is ZNULL.
 */
#define MtcImRefreshOkNotification         "MtcImRefreshOkNotification"

/**
 * @brief Posted when refresh message failed.
 *
 * The pcInfo is ZNULL.
 */
#define MtcImRefreshDidFailNotification    "MtcImRefreshDidFailNotification"

/** @} */

/**
 * @brief Send text message to peer.
 *
 * When the message has been sent successfully, @ref MtcImSendTextOkNotification will
 * be reported.
 * When the mssage sent fail, @ref MtcImSendTextDidFailNotification will be reported.
 *
 * The peer user will be notified by @ref MtcImTextDidReceiveNotification.
 *
 * @param  zCookie   The user defined cookie.
 * @param  pcToId    The target user's URI, or user's UserId, or group ID.
 * @param  pcText    The content text of the message.
 * @param  pcInfo    The more info in JSON format, which may contain
 *                   @ref MtcImDisplayNameKey, @ref MtcImUserDataKey.
 *
 * @retval ZOK       The request has been sent successfully.
 * @retval ZFAILED   Failed to send the request.
 */
MTCFUNC ZINT Mtc_ImSendText(ZCOOKIE zCookie, ZCONST ZCHAR *pcToId,
    ZCONST ZCHAR *pcText, ZCONST ZCHAR *pcInfo);

/**
 * @brief Send information to peer.
 *
 * When the message has been sent successfully, @ref MtcImSendInfoOkNotification will
 * be reported.
 * When the mssage sent fail, @ref MtcImSendInfoDidFailNotification will be reported.
 *
 * The peer user will be notified by @ref MtcImInfoDidReceiveNotification.
 *
 * @param  zCookie      The user defined cookie.
 * @param  pcToId       The target user's URI, or user's UserId, or group ID.
 * @param  pcInfoType   The information type string.
 * @param  pcContent    The information content.
 * @param  pcInfo       The more info in JSON format, which may contain
 *                      @ref MtcImDisplayNameKey, @ref MtcImUserDataKey.
 *
 * @retval ZOK       The request has been sent successfully.
 * @retval ZFAILED   Failed to send the request.
 */
MTCFUNC ZINT Mtc_ImSendInfo(ZCOOKIE zCookie, ZCONST ZCHAR *pcToId, 
    ZCONST ZCHAR *pcInfoType, ZCONST ZCHAR *pcContent, ZCONST ZCHAR *pcInfo);

/**
 * @brief Refresh unreceived messages.
 * 
 * Un-received message will be notified by 
 * @ref MtcImTextDidReceiveNotification or
 * @ref MtcImInfoDidReceiveNotification.
 * Then @ref MtcImRefreshOkNotification will be reported.
 *
 * If there is error during refresh, @ref MtcImRefreshDidFailNotification
 * will be reported.
 *
 * @param  zCookie      The user defined cookie.
 * 
 * @retval ZOK       The refresh request has been sent successfully.
 * @retval ZFAILED   Failed to refresh messages.
 */
MTCFUNC ZINT Mtc_ImRefresh(ZCOOKIE zCookie);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_IM_H__ */

