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
  File name     : mtc_doodle.h
  Module        : multimedia talk client
  Author        : xiangbo.hui
  Created on    : 2015-03-27
  Description   :
      Data structure and function declare required by MTC statistics

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_D0_H__
#define _MTC_D0_H__

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
 * @file mtc_d0.h
 * @brief MTC Doodle Interface Functions
 *
 * This file includes doodle interface function.
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Create image object.
 * @return            Image object.
 */
MTCFUNC MTC_IMG Mtc_D0CreateImage(ZFUNC_VOID);

/**
 * @brief Delete image object.
 * @param  zImage The image object.
 */
MTCFUNC ZVOID Mtc_D0DeleteImage(MTC_IMG zImage);

/**
 * @brief Create image object from text.
 * @param  pcMsg The text.
 * @return       The Image object.
 */
MTCFUNC MTC_IMG Mtc_D0ParseImage(ZCONST ZCHAR *pcMsg);

/**
 * @brief Save image object to text.
 * @param  zImage The image object.
 * @return        The text string.
 */
MTCFUNC ZCONST ZCHAR * Mtc_D0PrintImage(MTC_IMG zImage);

/**
 * @brief Set image attributes.
 * @param  zImage The image object.
 * @param  pcInfo The attributes in JSON format which contains
 *                @ref MtcDoodlePageIdKey
 *                @ref MtcDoodleImageTypeKey
 *                @ref MtcDoodleImageNameKey
 *                @ref MtcDoodleImageUriKey
 *                @ref MtcDoodleResolutionKey
 *                @ref MtcDoodlePositionKey
 * @return        ZOK on succeed, otherwise failed.
 */
MTCFUNC ZINT Mtc_D0SetImageAttr(MTC_IMG zImage,
    ZCONST ZCHAR *pcInfo);

/**
 * @brief Get image attributes.
 * @param  zImage The image object.
 * @return        The attributes in JSON format which contains
 *                @ref MtcDoodlePageIdKey
 *                @ref MtcDoodleImageTypeKey
 *                @ref MtcDoodleImageNameKey
 *                @ref MtcDoodleImageUriKey
 *                @ref MtcDoodleResolutionKey
 *                @ref MtcDoodlePositionKey
 */
MTCFUNC ZCONST ZCHAR * Mtc_D0GetImageAttr(MTC_IMG zImage);

/**
 * @brief Create action object.
 * @return            The action object.
 */
MTCFUNC MTC_ACT Mtc_D0CreateAction(ZFUNC_VOID);

/**
 * @brief Delete action object.
 * @param  zAction The action object.
 */
MTCFUNC ZVOID Mtc_D0DeleteAction(MTC_IMG zAction);

/**
 * @brief Create action object from text.
 * @param  pcMsg The text.
 * @return       The action object.
 */
MTCFUNC MTC_ACT Mtc_D0ParseAction(ZCONST ZCHAR *pcMsg);

/**
 * @brief Save action object to text.
 * @param  zAction The action object.
 * @return         The text string.
 */
MTCFUNC ZCONST ZCHAR * Mtc_D0PrintAction(MTC_IMG zAction);

/**
 * @brief Set action attributes.
 * @param  zAction The action object.
 * @param  pcInfo  The attributes in JSON format which contains
 *                 @ref MtcDoodleActionTypeKey
 *                 @ref MtcDoodleSeqNoKey
 *                 @ref MtcDoodleBrushKey
 *                 @ref MtcDoodlePageIdKey
 *                 @ref MtcDoodleContentKey
 * @return         ZOK on succeed, otherwise failed.
 */
MTCFUNC ZINT Mtc_D0SetActionAttr(MTC_IMG zAction,
    ZCONST ZCHAR *pcInfo);

/**
 * @brief Get action attributes.
 * @param  zAction The action object.
 * @return         The attributes in JSON format which contains
 *                 @ref MtcDoodleActionTypeKey
 *                 @ref MtcDoodleSeqNoKey
 *                 @ref MtcDoodleBrushKey
 *                 @ref MtcDoodlePageIdKey
 *                 @ref MtcDoodleContentKey
 */
MTCFUNC ZCONST ZCHAR * Mtc_D0GetActionAttr(MTC_IMG zAction);

/**
 * @brief Add action position.
 * @param  zAction The action object.
 * @param  fX      The X value from -1.0 to 1.0.
 * @param  fY      The Y value from -1.0 to 1.0.
 * @return         ZOK on succeed, otherwise failed.
 */
MTCFUNC ZINT Mtc_D0AddActionPosition(MTC_ACT zAction,
    ZFLOAT fX, ZFLOAT fY);

/**
 * @brief Set action positions.
 * @param  zAction The action object.
 * @param  fX      The value from -1.0 to 1.0.
 * @param  fY      The value from -1.0 to 1.0.
 * @param  iIntVal The interval.
 * @return         ZOK on succeed, otherwise failed.
 */
MTCFUNC ZINT Mtc_D0AddActionPositionX(MTC_ACT zAction,
    ZFLOAT fX, ZFLOAT fY, ZUINT iIntVal);

/**
 * @brief Get count of positions in action object.
 * @param  zAction The action object.
 * @return         The count of positions.
 */
MTCFUNC ZINT Mtc_D0GetActionPositionCount(MTC_ACT zAction);

/**
 * @brief Get the interval of position.
 * @param  zAction The action object.
 * @param  iIndex  The index of position, from 0 to count-1.
 * @return         The interval in milliseconds.
 */
MTCFUNC ZINT Mtc_D0GetActionIntval(MTC_ACT zAction, ZINT iIndex);

/**
 * @brief Get the X value of position.
 * @param  zAction The action object.
 * @param  iIndex  The index of position, from 0 to count-1.
 * @return         The X value of postion.
 */
MTCFUNC ZFLOAT Mtc_D0GetActionPositionX(MTC_ACT zAction, ZINT iIndex);

/**
 * @brief Get the Y value of position.
 * @param  zAction The action object.
 * @param  iIndex  The index of position, from 0 to count-1.
 * @return         The Y value of postion.
 */
MTCFUNC ZFLOAT Mtc_D0GetActionPositionY(MTC_ACT zAction, ZINT iIndex);

/**
 * @brief Get the path of action.
 * @param  zAction The action object.
 * @return         The path in JSON format which is array contains
 *                 all positions. Each position is array of number.
 *                 First number is interval in milliseoncds.
 *                 Second number is X value of position.
 *                 Third number is Y value of position.
 */
MTCFUNC ZCONST ZCHAR * Mtc_D0GetActionPath(MTC_ACT zAction);

/**
 * @brief Create session object.
 * @return            The session object.
 */
MTCFUNC MTC_SESS Mtc_D0CreateSession(ZFUNC_VOID);

/**
 * @brief Delete session object.
 * @param  zSession The session object.
 */
MTCFUNC ZVOID Mtc_D0DeleteSession(MTC_SESS zSession);

/**
 * @brief Set page count.
 * @param  zSession The session object.
 * @param  iCount   The count of pages.
 * @return          ZOK on succeed, otherwise failed.
 */
MTCFUNC ZINT Mtc_D0SessionSetPageCount(MTC_SESS zSession, ZINT iCount);

/**
 * @brief Add image object to session.
 *
 * You must not delete image after add this image to the session.
 * The image will replace the exist one with same MtcDoodlePageIdKey.
 * 
 * @param  zSession The session object.
 * @param  zImage   The image object.
 * @return          ZOK on succeed, otherwise failed.
 */
MTCFUNC ZINT Mtc_D0SessionAddImage(MTC_SESS zSession, MTC_IMG zImage);

/**
 * @brief Get the count of image.
 * @param  zSession The session object.
 * @return          The count of images.
 */
MTCFUNC ZINT Mtc_D0SessionGetImageCount(MTC_SESS zSession);

/**
 * @brief Enumrate the image object.
 * @param  zSession The session object.
 * @param  iIndex   The index of image, from 0 to count-1.
 * @return          The image object.
 */
MTCFUNC MTC_IMG Mtc_D0SessionEnumImage(MTC_SESS zSession, ZUINT iIndex);

/**
 * @brief Add action object to session.
 * @param  zSession The session object.
 * @param  bSelf    ZTRUE indicates the action was taken by self.
 *                  Otherwise the actions was taken by peer.
 * @param  zAction  The action object.
 * @return          ZOK on succeed, otherwise failed.
 */
MTCFUNC ZINT Mtc_D0SessionAddAction(MTC_SESS zSession, ZBOOL bSelf,
    MTC_ACT zAction);

/**
 * @brief Get count of actions.
 * @param  zSession The session object.
 * @return          The count of actions.
 */
MTCFUNC ZINT Mtc_D0SessionGetActionCount(MTC_SESS zSession);

/**
 * @brief Enumrate the actions in session.
 * @param  zSession The session object.
 * @param  iIndex   The index of action, from 0 to count-1.
 * @return          The action object.
 */
MTCFUNC MTC_ACT Mtc_D0SessionEnumAction(MTC_SESS zSession, ZUINT iIndex);

/**
 * @brief Enumrate the self flags in session.
 * @param  zSession The session object.
 * @param  iIndex   The index of action, from 0 to count-1.
 * @return          The self flag.
 */
MTCFUNC ZBOOL Mtc_D0SessionEnumSelf(MTC_SESS zSession, ZUINT iIndex);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_D0_H__ */

