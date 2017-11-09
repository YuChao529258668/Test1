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
#ifndef _MTC_ACV_H__
#define _MTC_ACV_H__

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
 * @file mtc_acv.h
 * @brief MTC statistics Interface Functions
 *
 * This file includes statistics interface function.
 */

/**
 * @defgroup MtcAcvNotify MTC notification names for archive and commit.
 * @{
 */
/**
 * @brief Posted when the log package committed successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcAcvCommitOkNotification "MtcAcvCommitOkNotification"

/**
 * @brief Posted when the log package failed to commit.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcAcvCommitDidFailNotification "MtcAcvCommitDidFailNotification"
/**
 * @}
 */

/**
 * @defgroup MtcAcvParm MTC parameters keys for archive and commit.
 * @{
 */
 
/**
 * @brief A key whose value is a string reflecting the memo.
 */
#define MtcParmAcvCommitMemo        "Memo"

/**
 * @brief A key whose value is a string reflecting the device ID.
 */
#define MtcParmAcvCommitDeviceId    "DeviceId"

/**
 * @brief A key whose value is a string reflecting the archive name.
 */
#define MtcParmAcvCommitArchiveName "ArchiveName"

/**
 * @brief A key whose value is an array contains the string of each directory
 * which will be committed.
 */
#define MtcParmAcvCommitPaths       "Paths"
/**
 * @}
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Archive logs and commit to server.
 *
 * @param [in] zCookie Cookie value in notification callback.
 * @param [in] pcInfo The parameter information in json format.
 * Parameters include MtcParmAcvCommitArchiveName, MtcParmAcvCommitMemo,
 * MtcParmAcvCommitDeviceId, MtcParmAcvCommitPaths.
 *
 * Schema:
 * {
 *   "name": "MtcAcvCommit",
 *   "properties": {
 *     "Memo": {
 *       "type"         : "string",
 *       "description"  : "Memo information in commit message",
 *       "require"      : true
 *     },
 *     "DeviceId": {
 *       "type"         : "string",
 *       "description"  : "Device ID in commit message",
 *       "require"      : true
 *     },
 *     "ArchiveName": {
 *       "type"         : "string",
 *       "description"  : "Achive file name",
 *     },
 *     "Paths": {
 *       "type"         : "array",
 *       "description"  : "The path name of files or directoires to be archived.",
 *       "items"        : { "type": "string" },
 *       "minItems"     : 1,
 *       "uniqueItems"  : true
 *     }
 *   }
 * }
 * 
 * Example:
 * {
 *   "Memo"         : "exmaple",
 *   "DeviceId"     : "JUPHOONDEVCIEID01",
 *   "ArchiveName"  : "example-20140420.tgz",
 *   "Paths"        : ["example/dir/file1", "example/dir/file2", "exmaple/dir2"]
 * }
 *
 * @retval ZOK on invoke this interface successfully. The result will notify
 * to user with MtcAcvCommitOkNotification or MtcAcvCommitDidFailNotification.
 * @retval ZFAILED on invoke this interface failed. There will be no 
 * notification.
 */
MTCFUNC ZINT Mtc_AcvCommitJ(ZCOOKIE zCookie, ZCONST ZCHAR *pcInfo);

/** 
 * @brief MTC archive files locally.
 *
 * @param [in] pcArchive The archived file name.
 * @param [in] pcPaths The path name in json format.
 * Parameters include MtcParmAcvCommitPaths.
 * @retval ZFAILED on invoke this interface failed.
 * @retval ZOK archive file is saved locally.
 *
 * Schema:
 * {
 *     "Paths": {
 *       "type"         : "array",
 *       "description"  : "The path name of files or directoires to be archived.",
 *       "items"        : { "type": "string" },
 *       "minItems"     : 1,
 *       "uniqueItems"  : true
 *     }
 * }
 *
 * Example:
 * {
 *   "Paths" : ["example/dir/file1", "example/dir/file2", "exmaple/dir2"]
 * }
 *
 */
MTCFUNC ZINT Mtc_AcvPack(ZCONST ZCHAR *pcArchive, ZCONST ZCHAR *pcPaths);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_ACV_H__ */

