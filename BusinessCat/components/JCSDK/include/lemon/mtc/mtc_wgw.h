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
  File name     : mtc_wgw.h
  Module        : multimedia talk client
  Author        : bob.liu
  Created on    : 2017-06-13
  Description   :
    Marcos and structure definitions required by the mtc webrtc gateway.

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_WGW_H__
#define _MTC_WGW_H__

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
 * @file mtc_wgw.h
 * @brief MTC WebRTC Gateway Interface Functions
 */
 
/**
 * @defgroup MtcWgwKey MTC notification key of media event.
 * @{
 */

/**
 * @brief A key whose value is a string object in JSON format reflecting 
 * the configuration of ICE servers.
 */
#define MtcWgwIceServersKey                 "iceServers"

/**
 * @brief A key whose value is a string object in JSON format reflecting
 * the fail reason.
 */
#define MtcWgwFailReasonKey                 "MtcWgwFailReasonKey"

/** @} */


/**
 * @defgroup MtcWgwNotification MTC notification of session event.
 * @{
 */

/**
 * @brief Posted when initialize OK.
 *
 * The pcInfo of this notification contains
 * @ref MtcWgwIceServersKey.
 */
#define MtcWgwInitOkNotification "MtcWgwInitOkNotification"

/**
 * @brief Posted when initialize failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcWgwInitDidFailNotification "MtcWgwInitDidFailNotification"

/**
 * @brief Posted when send data OK.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcWgwSendDataOkNotification "MtcWgwSendDataOkNotification"

/**
 * @brief Posted when send data failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcWgwSendDataDidFailNotification "MtcWgwSendDataDidFailNotification"

/**
 * @brief Posted when receive data OK.
 *
 * The pcInfo of this notification is an array of string.
 */
#define MtcWgwRecvDataOkNotification "MtcWgwRecvDataOkNotification"

/**
 * @brief Posted when receive data failed.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcWgwRecvDataDidFailNotification "MtcWgwRecvDataDidFailNotification"

/**
 * @brief Posted when receive data.
 *
 * The pcInfo of this notification is an array of string.
 */
#define MtcWgwDataReceivedNotification "MtcWgwDataReceivedNotification"

/** @} */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief MTC init webrtc gateway session.
 *
 * @param  zCookie Cookie.
 * @param  pcServiceId The service ID.
 * @param  pcSessId The session ID, use conference number for conference.
 * @param  pcInstanceId Instance ID string.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 */
MTCFUNC ZINT Mtc_WgwInit(ZCOOKIE zCookie, ZCONST ZCHAR *pcServiceId,
    ZCONST ZCHAR *pcSessId, ZCONST ZCHAR *pcInstanceId);

/**
 * @brief MTC destroy session.
 */
MTCFUNC ZVOID Mtc_WgwDestroy(ZFUNC_VOID);

/**
 * @brief MTC send data to peer.
 *
 * @param  zCookie Cookie.
 * @param  pcData Data string.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 */
MTCFUNC ZINT Mtc_WgwSend(ZCOOKIE zCookie, ZCONST ZCHAR *pcData);

/**
 * @brief MTC receive data from peer.
 *
 * @param  zCookie Cookie.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 */
MTCFUNC ZINT Mtc_WgwRecv(ZCOOKIE zCookie);

#ifdef __cplusplus
}
#endif

#endif

