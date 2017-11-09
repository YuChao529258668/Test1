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
  File name     : mtc_user.h
  Module        : rich session enabler
  Author        : bob.liu
  Created on    : 2015-06-12
  Description   :
      Data structure and function declare required by mtc conference 

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_USER_H__
#define _MTC_USER_H__

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
 * @brief MTC User Interfaces
 *
 * This file includes user interface function. 
 */
#ifdef __cplusplus
extern "C" {
#endif

/** @brief MTC user ID type. */
typedef enum EN_MTC_USER_ID_TYPE
{
    EN_MTC_USER_ID_INVALID = 0,               /**< @brief Invalid ID type. */
    EN_MTC_USER_ID_PHONE,                     /**< @brief The ID of phone. */
    EN_MTC_USER_ID_EMAIL,                     /**< @brief The ID of email. */
    EN_MTC_USER_ID_USERNAME,                  /**< @brief The ID of username. */
    EN_MTC_USER_ID_UID,                       /**< @brief The ID of unique. */
    EN_MTC_USER_ID_FACEBOOK,                  /**< @brief The ID of facebook. */
    EN_MTC_USER_ID_TWITTER,                   /**< @brief The ID of twitter. */
    EN_MTC_USER_ID_SNAPCHAT,                  /**< @brief The ID of snapchat. */
    EN_MTC_USER_ID_INSTAGRAM,                 /**< @brief The ID of instagram. */
    EN_MTC_USER_ID_WEIBO,                     /**< @brief The ID of weibo. */
    EN_MTC_USER_ID_WECHAT,                    /**< @brief The ID of wechat. */
    EN_MTC_USER_ID_QQ,                        /**< @brief The ID of qq. */
} EN_MTC_USER_ID_TYPE;

/**
 * @defgroup MtcUserIdString MTC User ID Type String.
 * @{
 */
/** @brief Indicate the phone number @ref EN_MTC_USER_ID_PHONE. */
#define MTC_USER_ID_PHONE "phone"
/** @brief Indicate the email @ref EN_MTC_USER_ID_EMAIL. */
#define MTC_USER_ID_EMAIL "email"
/** @brief Indicate the username @ref EN_MTC_USER_ID_USERNAME.*/
#define MTC_USER_ID_USERNAME "username"
/** @brief Indicate the udi @ref EN_MTC_USER_ID_UID.*/
#define MTC_USER_ID_UID "uid"
/** @brief Indicate the facebook @ref EN_MTC_USER_ID_FACEBOOK.*/
#define MTC_USER_ID_FACEBOOK "facebook"
/** @brief Indicate the twitter @ref EN_MTC_USER_ID_TWITTER.*/
#define MTC_USER_ID_TWITTER "twitter"
/** @brief Indicate the snapchat @ref EN_MTC_USER_ID_SNAPCHAT.*/
#define MTC_USER_ID_SNAPCHAT "snapchat"
/** @brief Indicate the instagram @ref EN_MTC_USER_ID_INSTAGRAM.*/
#define MTC_USER_ID_INSTAGRAM "instagram"
/** @brief Indicate the weibo @ref EN_MTC_USER_ID_WEIBO.*/
#define MTC_USER_ID_WEIBO "weibo"
/** @brief Indicate the wechat @ref EN_MTC_USER_ID_WECHAT.*/
#define MTC_USER_ID_WECHAT "wechat"
/** @brief Indicate the qq @ref EN_MTC_USER_ID_QQ.*/
#define MTC_USER_ID_QQ "qq"
/** @} */

/**
 * @brief Form URI from user ID.
 *
 * @param [in] iIdType ID type @ref EN_MTC_USER_ID_TYPE.
 * @param [in] pcId ID string.
 *
 * @return User URI string when succeed, otherwise ZNULL.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UserFormUri(ZUINT iIdType, ZCONST ZCHAR *pcId);

/**
 * @brief Form URI from user ID.
 *
 * @param [in] pcIdType the ID type string.
 * @param [in] pcId ID string.
 *
 * @return User URI string when succeed, otherwise ZNULL.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UserFormUriX(ZCONST ZCHAR *pcIdType, ZCONST ZCHAR *pcId);

/**
 * @brief Check if the URI is valid.
 * @param  pcUri The URI string.
 * @retval ZTRUE The URI is valid.
 * @retval ZFALSE The URI is invalid.
 */
MTCFUNC ZBOOL Mtc_UserIsValidUri(ZCONST ZCHAR *pcUri);

/**
 * @brief Check if the uid is valid.
 * @param  pcUid The uid string.
 * @retval ZTRUE The uid is valid.
 * @retval ZFALSE The uid is invalid.
 */
MTCFUNC ZBOOL Mtc_UserIsValidUid(ZCONST ZCHAR *pcUid);

/**
 * @brief Get ID type from URI.
 * @param  pcUri The URI string.
 * @return       The ID type @ref EN_MTC_USER_ID_TYPE if URI is valid.
 *               Otherwise ZMAXUINT.
 */
MTCFUNC ZUINT Mtc_UserGetIdType(ZCONST ZCHAR *pcUri);

/**
 * @brief Get string of ID type from URI.
 * @param  pcUri The URI string.
 * @return       The string of ID type if URI is valid.
 *               Otherwise ZNULL.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UserGetIdTypeX(ZCONST ZCHAR *pcUri);

/**
 * @brief Get string of ID from URI.
 * @param  pcUri The URI string.
 * @return       The string of ID if URI is valid.
 *               Otherwise ZNULL.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UserGetId(ZCONST ZCHAR *pcUri);

/**
 * @brief Get string of realm from URI.
 * @param  pcUri The URI string.
 * @return       The string of realm if URI is valid.
 *               Otherwise ZNULL.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UserGetRealm(ZCONST ZCHAR *pcUri);

/**
 * @brief Convert ID type from string to type value.
 * @param pcType The ID type string.
 * @return The ID type value @ref EN_MTC_USER_ID_TYPE.
 */
MTCFUNC ZUINT Mtc_UserTypeS2t(ZCONST ZCHAR *pcType);

/**
 * @brief Convert ID type from type value to string.
 * @param iIdType The ID type @ref EN_MTC_USER_ID_TYPE.
 * @return The ID type string.
 */
MTCFUNC ZCONST ZCHAR * Mtc_UserTypeT2s(ZUINT iIdType);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_USER_H__ */

