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
  File name     : mtc_call_cfg.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2011-01-04
  Description   :
      Data structure and function declare required by mtc call config 

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_CALL_CFG_H__
#define _MTC_CALL_CFG_H__

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
 * @file mtc_call_cfg.h
 * @brief MTC Call Config Interface Functions
 */
#ifdef __cplusplus
extern "C" {
#endif

/** @brief Callback function type defination when init encryption.    */
typedef ZVOID (*PFN_MTCENCRYPTINIT)(ZUINT iCallId, ZVOID *pUserData,
                ZUCHAR *pucKey, ZINT *piKeyBytes);

/** @brief Callback function type defination when init decryption.    */
typedef ZVOID (*PFN_MTCDECRYPTINIT)(ZUINT iCallId, ZVOID *pUserData,
                ZCONST ZUCHAR *pucKey, ZINT iKeyBytes);

/** @brief Callback function type defination when destroy.    */
typedef ZVOID (*PFN_MTCENCRYPTDESTROY)(ZUINT iCallId, ZVOID *pUserData);

/** @brief Callback function type defination when finish encryption.    */
typedef ZVOID (*PFN_MTCENCRYPT)(ZUINT iCallId, ZVOID *pUserData,
                ZUCHAR *pucInData, ZUCHAR *pucOutData, ZINT iInBytes,
                ZINT *piOutBytes);

/** @brief Callback function type defination when finish decryption.    */
typedef ZVOID (*PFN_MTCDECRYPT)(ZUINT iCallId, ZVOID *pUserData,
                ZUCHAR *pucInData, ZUCHAR *pucOutData, ZINT iInBytes,
                ZINT *piOutBytes, ZCONST ZCHAR *pcPeerIp,
                ZCONST ZUSHORT wPeerPort);

/**
 * @brief Enable encryption for audio.
 * 
 * @param  bEnable ZTRUE enable encryption, ZFALSE disable encryption.
 * 
 * @retval ZOK Set config successfully.
 * @retval ZFAILED Set config failed.
 */
MTCFUNC ZINT Mtc_CallCfgEnableEncryption(ZBOOL bEnable);

/**
 * @brief Set encryption functions for audio data.
 * 
 * @param  pUserData      The user data.
 * @param  pfnEncryptInit The init encrypt fucntion.
 * @param  pfnDecryptInit The init decrypt function.
 * @param  pfnEncryptDestroy     The destroy encrypt fucntion.
 * @param  pfnEncrypt     The encrypt fucntion.
 * @param  pfnDecrypt     The decrypt function.
 * 
 * @retval ZOK Set config successfully.
 * @retval ZFAILED Set config failed.
 */
MTCFUNC ZINT Mtc_CallCfgSetEncryption(ZVOID *pUserData,
    PFN_MTCENCRYPTINIT pfnEncryptInit, PFN_MTCDECRYPTINIT pfnDecryptInit,
    PFN_MTCENCRYPTDESTROY pfnEncryptDestroy,
    PFN_MTCENCRYPT pfnEncrypt, PFN_MTCDECRYPT pfnDecrypt);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_CALL_CFG_H__ */

