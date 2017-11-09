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
  File name     : mtc_diag.h
  Module        : multimedia talk client
  Author        : xiangbo.hui
  Created on    : 2015-03-27
  Description   :
      Data structure and function declare required by MTC statistics

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_DIAG_H__
#define _MTC_DIAG_H__

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
 * @file mtc_diag.h
 * @brief MTC diagnostic Interface Functions
 *
 * This file includes use diagnostic function.
 */

/**
 * @defgroup MtcDiagMethods MTC method for diagnosis.
 * @{
 */
/** @brief Request to upload log files. */
#define MtcDiagMethodUploadLogs "UploadLogs"
/** @} */

/**
 * @defgroup MtcDiagKey MTC notification key for diagnosis.
 * @{
 */

/**
 * @brief A key whose value is a string object relfecting ID for diagnosis.
 */
#define MtcDiagIdKey "MtcDiagIdKey"

/**
 * @brief A key whose value is a string object relfecting method for diagnosis,
 * possible value are @ref MtcDiagMethods.
 */
#define MtcDiagMethodKey "MtcDiagMethodKey"

/**
 * @brief A key whose value is a number object reflecting the expires time
 * of diagnosis request, which is the value in seconds since
 * 0 hours, 0 minutes, 0 seconds, January 1, 1970, Coordinated Universal Time.
 */
#define MtcDiagExpiresTimeKey "MtcDiagExpiresTimeKey"

/**
 * @brief A key whose value is a string object reflecting
 * the URI.
 */
#define MtcDiagUriKey                    "Uri"

/**
 * @brief A key whose value is a boolean object reflecting
 * if network is reachable.
 */
#define MtcDiagReachableKey              "Reachable"

/**
 * @brief A key whose value is a number object reflecting
 * RTT (round trip time) in milliseconds.
 */
#define MtcDiagRttKey                    "Rtt"

/**
 * @brief A key whose value is a number object reflecting
 * bandwidth of sending direction in kbps.
 */
#define MtcDiagSendBandwidthKey          "SendKbps"

/**
 * @brief A key whose value is a number object reflecting
 * lost ratio of sending direction in percentage.
 */
#define MtcDiagSendLostRatioKey          "SendLostRatio"

/**
 * @brief A key whose value is a number object reflecting
 * delay of sending direction in milliseconds.
 */
#define MtcDiagSendDelayKey              "SendDelay"

/**
 * @brief A key whose value is a number object reflecting
 * bandwidth of receive direction in kbps.
 */
#define MtcDiagReceiveBandwidthKey       "ReceiveKbps"

/**
 * @brief A key whose value is a number object reflecting
 * lost ratio of receive direction in percentage.
 */
#define MtcDiagReceiveLostRatioKey       "ReceiveLostRatio"

/**
 * @brief A key whose value is a number object reflecting
 * delay of receive direction in milliseconds.
 */
#define MtcDiagReceiveDelayKey           "ReceiveDelay"

/** @} */

/**
 * @defgroup MtcDiagNotification MTC notification names for diagnosis.
 * @{
 */

/**
 * @brief Posted when the diagnostic request received.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcDiagRequestReceivedNotification "MtcDiagRequestReceivedNotification"

/**
 * @brief posted when the reachable test has done.
 *
 * the pcinfo of this notification contains
 * @ref MtcDiagUriKey and @ref MtcDiagReachableKey
 */
#define MtcDiagCheckReachableNotification "MtcDiagCheckReachableNotification"

/**
 * @brief posted when the transport testing start successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcDiagTptTestStartOkNotification "MtcDiagTptTestStartOkNotification"

/**
 * @brief posted when the transport testing start successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcDiagTptTestStartDidFailNotification "MtcDiagTptTestStartDidFailNotification"

/**
 * @brief posted when the statistics information has been updated.
 *
 * the pcinfo of this notification contains
 * @ref MtcDiagSendBandwidthKey
 * @ref MtcDiagSendLostRatioKey
 * @ref MtcDiagSendDelayKey
 * @ref MtcDiagReceiveBandwidthKey
 * @ref MtcDiagReceiveLostRatioKey
 * @ref MtcDiagReceiveDelayKey
 */
#define MtcDiagTptTestStatisticsNotification "MtcDiagTptTestStatisticsNotification"

/** @} */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Check HTTP reachability.
 * @param  pcUri Target HTTP URI, ZNULL use default.
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with @ref MtcDiagCheckReachableNotification .
 * @retval ZFAILED on invoke this interface failed. There will be no 
 * notification.
 */
MTCFUNC ZINT Mtc_DiagCheckReachable(ZCONST ZCHAR *pcUri);

/**
 * @brief Start transport testing.
 * 
 * @retval ZOK on invoke this interface successfully. 
 * The result will notify to user with @ref MtcDiagTptTestStartOkNotification,
 * @ref  MtcDiagTptTestStartDidFailNotification and @ref MtcDiagTptTestStatisticsNotification.
 * @retval ZFAILED on invoke this interface failed. There will be no 
 * notification.
 */
MTCFUNC ZINT Mtc_DiagTptTestStart(ZFUNC_VOID);

/**
 * @brief Stop transport testing.
 */
MTCFUNC ZVOID Mtc_DiagTptTestStop(ZFUNC_VOID);

/**
 * @brief Set automatically commit.
 */
MTCFUNC ZINT Mtc_DiagSetAutoCommit(ZBOOL bEnable);

/**
 * @brief Commit.
 */
MTCFUNC ZINT Mtc_DiagCommit(ZFUNC_VOID);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_DIAG_H__ */

