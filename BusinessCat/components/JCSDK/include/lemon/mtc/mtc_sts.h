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
  File name     : mtc_sts.h
  Module        : multimedia talk client
  Author        : logan.huang
  Created on    : 2013-02-01
  Description   :
      Data structure and function declare required by MTC statistics

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_STS_H__
#define _MTC_STS_H__

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
 * @file mtc_sts.h
 * @brief MTC statistics Interface Functions
 *
 * This file includes statistics interface function.
 */

/**
 * @defgroup MtcStsNotify MTC notification names for statistic and commit ok.
 * @{
 */
/**
 * @brief Posted when the statistic committed successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcStsCommitOkNotification "MtcStsCommitOkNotification"

/**
 * @brief Posted when the statistic failed to commit.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcStsCommitDidFailNotification "MtcStsCommitDidFailNotification"
/**
 * @}
 */

#ifdef __cplusplus
extern "C" {
#endif

/** 
 * @brief MTC statistics communicate in json format.
 *
 * @param [in] iCallId The ID of session which you want to commit.
 * @param [in] zCookie The user cookie.
 * @retval ZOK indicates that invoking this interface successfully.
 * The result will notify to user with @ref MtcStsCommitOkNotification or
 * @ref MtcStsCommitDidFailNotification.
 * @retval ZFAILED indicates that invoking this interface failed.
 * there is no notification to user.
 *
 */
MTCFUNC ZINT Mtc_StsCommit(ZCOOKIE zCookie, ZUINT iCallId);

/**
 * @brief Set data link flag.
 *
 * @param [in] bEnable ZTRUE for collect statistics over data link.
 *
 * @retval ZOK Set OK.
 * @retval ZFAILED Set failed.
 */
MTCFUNC ZINT Mtc_StsSetDataLink(ZBOOL bEnable);

/**
 * @brief Get total network traffic statistics.
 *
 * @param [out] piSent Sent bytes;
 * @param [out] piRecv Received bytes;
 * @param [out] piMediaSent Media sent bytes;
 * @param [out] piMediaRecv Media received bytes;
 *
 * @retval ZOK Get statistics OK.
 * @retval ZFAILED Get statistics failed.
 */
MTCFUNC ZINT Mtc_StsGetTotalTraffic(ZUINT *piSent, ZUINT *piRecv,
                ZUINT *piMediaSent, ZUINT *piMediaRecv);

/**
 * @brief Get network traffic statistics over data link.
 *
 * @param [out] piSent Sent bytes;
 * @param [out] piRecv Received bytes;
 * @param [out] piMediaSent Media sent bytes;
 * @param [out] piMediaRecv Media received bytes;
 *
 * @retval ZOK Get statistics OK.
 * @retval ZFAILED Get statistics failed.
 */
MTCFUNC ZINT Mtc_StsGetDataTraffic(ZUINT *piSent, ZUINT *piRecv,
                ZUINT *piMediaSent, ZUINT *piMediaRecv);

/**
 * @brief Reset network traffic statistics.
 *
 * @retval ZOK Reset statistics OK.
 * @retval ZFAILED Reset statistics failed.
 */
MTCFUNC ZINT Mtc_StsResetTraffic(ZFUNC_VOID);

/**
 * @brief Get total call time length in seconds.
 *
 * @param [out] piVoice Voice call time length in seconds;
 * @param [out] piVideo Video call time length in seconds;
 *
 * @retval ZOK Get statistics OK.
 * @retval ZFAILED Get statistics failed.
 */
MTCFUNC ZINT Mtc_StsGetCallTimeLength(ZUINT *piVoice, ZUINT *piVideo);

/**
 * @brief Reset call statistics.
 *
 * @retval ZOK Reset statistics OK.
 * @retval ZFAILED Reset statistics failed.
 */
MTCFUNC ZINT Mtc_StsResetCall(ZFUNC_VOID);

#ifdef __cplusplus
}
#endif
                
#endif /* _MTC_STS_H__ */

