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
  File name     : mtc_ue_db.h
  Module        : multimedia talk client
  Author        : jason.chen
  Created on    : 2015-05-16
  Description   :
      Data structure and function declare required by MTC statistics

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_UE_DB_H__
#define _MTC_UE_DB_H__

#ifndef MTCFUNC
#if defined(MTC_DLL_EXPORT)
#define MTCFUNC ZFUNC_EXPORT
#elif defined(MTC_DLL_IMPORT)
#define MTCFUNC ZFUNC_IMPORT
#else
#define MTCFUNC
#endif
#endif

#ifdef __cplusplus
extern "C" {
#endif

/** 
 * @brief MTC user entry set id type.
 *
 * @param [in] iIdType @ref EN_MTC_USER_ID_TYPE.
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetIdType(ZINT iIdType);

/** 
 * @brief MTC user entry get id type.
 *
 * @return Type of ID @ref EN_MTC_USER_ID_TYPE.
 *
 */ 
MTCFUNC ZINT Mtc_UeDbGetIdType(ZFUNC_VOID);

/** 
 * @brief MTC user entry get id type.
 *
 * @return ZNULL if no parameter which do not exist, or @ref MtcUserIdString.
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetIdTypeX(ZFUNC_VOID);

/**
 * @brief MTC user get ID.
 * 
 * @return The ID string if exist.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetId();

/** 
 * @brief MTC user entry set user name.
 *
 * @param [in] pcName The user name string.
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetUserName(ZCONST ZCHAR *pcName);

/** 
 * @brief MTC user entry get user name.
 *
 * @retval ZNULL if no parameter which do not exist, or user name string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetUserName(ZFUNC_VOID);

/** 
 * @brief MTC user entry set phone number .
 *
 * @param [in] pcPhone The phone number string.
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetPhone(ZCONST ZCHAR *pcPhone);

/** 
 * @brief MTC user entry get phone number.
 *
 * @retval ZNULL if no parameter which do not exist, or phone num string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetPhone(ZFUNC_VOID);

/** 
 * @brief MTC user entry set email.
 *
 * @param [in] pcEmail The email address string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetEmail(ZCONST ZCHAR *pcEmail);

/** 
 * @brief MTC user entry get email.
 *
 * @retval ZNULL if no parameter which do not exist, or email string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetEmail(ZFUNC_VOID);

/** 
 * @brief MTC user entry set facebook.
 *
 * @param [in] pcFacebook The facebook account string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
 MTCFUNC ZINT Mtc_UeDbSetFacebook(ZCONST ZCHAR *pcFacebook);

/** 
 * @brief MTC user entry get facebook.
 *
 * @retval ZNULL if no parameter which do not exist, or facebook account string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetFacebook(ZFUNC_VOID);

/** 
 * @brief MTC user entry set twitter.
 *
 * @param [in] pcTwitter The twitter account string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
 MTCFUNC ZINT Mtc_UeDbSetTwitter(ZCONST ZCHAR *pcTwitter);

/** 
 * @brief MTC user entry get twitter.
 *
 * @retval ZNULL if no parameter which do not exist, or twitter account string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetTwitter(ZFUNC_VOID);

/** 
 * @brief MTC user entry set snapchat.
 *
 * @param [in] pcSnapchat The snapchat account string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
 MTCFUNC ZINT Mtc_UeDbSetSnapchat(ZCONST ZCHAR *pcSnapchat);

/** 
 * @brief MTC user entry get snapchat.
 *
 * @retval ZNULL if no parameter which do not exist, or snapchat account string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetSnapchat(ZFUNC_VOID);

/** 
 * @brief MTC user entry set instagram.
 *
 * @param [in] pcInstagram The instagram account string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
 MTCFUNC ZINT Mtc_UeDbSetInstagram(ZCONST ZCHAR *pcInstagram);

/** 
 * @brief MTC user entry get instagram.
 *
 * @retval ZNULL if no parameter which do not exist, or instagram account string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetInstagram(ZFUNC_VOID);

/** 
 * @brief MTC user entry set weibo.
 *
 * @param [in] pcWeibo The weibo account string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetWeibo(ZCONST ZCHAR *pcWeibo);

/** 
 * @brief MTC user entry get weibo.
 *
 * @retval ZNULL if no parameter which do not exist, or weibo account string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetWeibo(ZFUNC_VOID);

/** 
 * @brief MTC user entry set wechat.
 *
 * @param [in] pcWechat The wechat account string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
 MTCFUNC ZINT Mtc_UeDbSetWechat(ZCONST ZCHAR *pcWechat);

/** 
 * @brief MTC user entry get wechat.
 *
 * @retval ZNULL if no parameter which do not exist, or wechat account string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetWechat(ZFUNC_VOID);

/** 
 * @brief MTC user entry set qq.
 *
 * @param [in] pcQq The qq account string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
 MTCFUNC ZINT Mtc_UeDbSetQq(ZCONST ZCHAR *pcQq);

/** 
 * @brief MTC user entry get qq.
 *
 * @retval ZNULL if no parameter which do not exist, or qq account string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetQq(ZFUNC_VOID);

/** 
 * @brief MTC set Uid.
 *
 * @param [in] pcUid The Uid string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetUid(ZCONST ZCHAR *pcUid);

/** 
 * @brief MTC get Uid.
 *
 * @retval ZNULL if no parameter which do not exist, or Uid string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetUid(ZFUNC_VOID);

/** 
 * @brief MTC set realm.
 *
 * @param [in] pcRealm The realm string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetRealm(ZCONST ZCHAR *pcRealm);

/** 
 * @brief MTC get realm.
 *
 * @retval ZNULL if no parameter which do not exist, or realm string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetRealm(ZFUNC_VOID);

/** 
 * @brief MTC user entry set password.
 *
 * @param [in] pcPassword The password string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetPassword(ZCONST ZCHAR *pcPassword);

/** 
 * @brief MTC user entry get password.
 *
 * @retval ZNULL if no parameter which do not exist, or password string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetPassword(ZFUNC_VOID);

/** 
 * @brief MTC user entry set appkey.
 *
 * @param [in] pcAppKey The appkey string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetAppKey(ZCONST ZCHAR *pcAppKey);

/** 
 * @brief MTC user entry get appkey.
 *
 * @retval ZNULL if no parameter which do not exist, or appkey string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetAppKey(ZFUNC_VOID);

/** 
 * @brief MTC user entry set network.
 *
 * @param [in] pcNetwork The network string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetNetwork(ZCONST ZCHAR *pcNetwork);

/** 
 * @brief MTC user entry get network.
 *
 * @retval ZNULL if no parameter which do not exist, or network string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetNetwork(ZFUNC_VOID);

/** 
 * @brief MTC user entry set entry.
 *
 * @param [in] pcEntry The entry string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetEntry(ZCONST ZCHAR *pcEntry);

/** 
 * @brief MTC user entry get entry.
 *
 * @retval ZNULL if no parameter which do not exist, or entry string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetEntry(ZFUNC_VOID);

/** 
 * @brief MTC user entry set config.
 *
 * @param [in] pcConfig The config string. 
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetConfig(ZCONST ZCHAR *pcConfig);

/** 
 * @brief MTC user entry get config.
 *
 * @retval ZNULL if no parameter which do not exist, or config string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetConfig(ZFUNC_VOID);

/** 
 * @brief MTC set message language.
 *
 * @param [in] pcLang The message language string.
 *  example: "en" or "zh"
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetAuthLanguage(ZCONST ZCHAR *pcLang);

/** 
 * @brief MTC get message language.
 *
 * @retval ZNULL if no parameter which do not exist, or message language string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetAuthLanguage(ZFUNC_VOID);

/** 
 * @brief MTC set message country code.
 *
 * @param [in] pcCountryCode The message country code string. 
 *  example: "86" or "355"
 *
 * @retval ZOK ok
 * @retval ZFAILED failed
 */
MTCFUNC ZINT Mtc_UeDbSetAuthCountryCode(ZCONST ZCHAR *pcCountryCode);

/** 
 * @brief MTC get message country code.
 *
 * @retval ZNULL if no parameter which do not exist, or message country code string
 *
 */ 
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetAuthCountryCode(ZFUNC_VOID);

/**
 * @brief MTC set RSA mode.
 *
 * @param [in] bEnable ZTRUE to use RSA mode.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set Failed.
 */
MTCFUNC ZINT Mtc_UeDbSetRsaMode(ZBOOL bEnable);

/** 
 * @brief MTC get RSA mode.
 *
 * @retval ZTRUE to use RSA mode, otherwise not use RSA mode
 */ 
MTCFUNC ZBOOL Mtc_UeDbGetRsaMode();

/**
 * @brief Get account ID.
 *
 * @return Account ID.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UeDbGetAccountId();

#ifdef __cplusplus
}
#endif

#endif 
