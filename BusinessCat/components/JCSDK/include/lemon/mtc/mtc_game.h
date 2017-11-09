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
  File name     : mtc_game.h
  Module        : game client
  Author        : junjie.wang
  Created on    : 2015-11-16
  Description   :
      Data structure and function declare required by MTC Game

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_GAME_H__
#define _MTC_GAME_H__

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
 * @file mtc_game.h
 * @brief MTC Game Interface Functions
 *
 * This file includes game interface function.
 */

/**
 * @defgroup MtcGameKey MTC notification key for game.
 * @{
 */

/**
 * @brief A key whose value is a string object reflecting
 * the user's ID.
 */
#define MtcGameUserUriKey           "MtcGameUserUriKey"

/**
 * @brief A key whose value is a string object reflecting
 * the game id.
 */
#define MtcGameGameIdKey            "MtcGameGameIdKey"

/**
 * @brief A key whose value is a number object reflecting
 * the game score.
 */
#define MtcGameScoreKey             "MtcGameScoreKey"

/**
 * @brief A key whose value is a string object reflecting
 * the game name.
 */
#define MtcGameNameKey              "MtcGameNameKey"

/**
 * @brief A key whose value is a string object reflecting
 * the game description.
 */
#define MtcGameDescriptionKey       "MtcGameDescriptionKey"

/**
 * @brief A key whose value is a number object reflecting
 * the game start time.
 */
#define MtcGameStartTimeKey         "MtcGameStartTimeKey"

/**
 * @brief A key whose value is a number object reflecting
 * the game end time.
 */
#define MtcGameEndTimeKey           "MtcGameEndTimeKey"

/**
 * @brief A key whose value is a number object reflecting
 * the game challenge type.
 */
#define MtcGameChallengeKey         "MtcGameChallengeKey"

/**
 * @brief A key whose value is a number object reflecting
 * the max score of a game record.
 */
#define MtcGameMaxScoreKey          "MtcGameMaxScoreKey"

/**
 * @brief A key whose value is a number object reflecting
 * the last score of a game record.
 */
#define MtcGameLastScoreKey         "MtcGameLastScoreKey"

/**
 * @brief A key whose value is a number object reflecting
 * the sum score of a game record.
 */
#define MtcGameSumScoreKey          "MtcGameSumScoreKey"

/**
 * @brief A key whose value is a number object reflecting
 * the play times of a game record.
 */
#define MtcGamePlayTimesKey         "MtcGamePlayTimesKey"

/**
 * @brief A key whose value is a number object reflecting
 * the rank of a game record.
 */
#define MtcGameRankKey              "MtcGameRankKey"

/** @} */

/**
 * @defgroup MtcGameNotification MTC notification names for game.
 * @{
 */
/**
 * @brief Posted when update score successfully.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcGameUpdateScoreOkNotification "MtcGameUpdateScoreOkNotification"

/**
 * @brief Posted when failed to update score.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcGameUpdateScoreDidFailNotification "MtcGameUpdateScoreDidFailNotification"

/**
 * @brief Posted when get ranking successfully.
 *
 * The pcInfo of this notification contains a list of structure of
 * @ref MtcGameGameIdKey,
 * @ref MtcGameRankKey,
 * @ref MtcGameScoreKey,
 * @ref MtcGameUserUriKey.
 */
#define MtcGameGetRankingOkNotification "MtcGameGetRankingOkNotification"

/**
 * @brief Posted when failed to get ranking.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcGameGetRankingDidFailNotification "MtcGameGetRankingDidFailNotification"

/**
 * @brief Posted when get game info successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcGameGameIdKey,
 * @ref MtcGameNameKey,
 * @ref MtcGameDescriptionKey,
 * @ref MtcGameStartTimeKey,
 * @ref MtcGameEndTimeKey,
 * @ref MtcGameChallengeKey.
 */
#define MtcGameGetGameInfoOkNotification "MtcGameGetGameInfoOkNotification"

/**
 * @brief Posted when failed to get game info.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcGameGetGameInfoDidFailNotification "MtcGameGetGameInfoDidFailNotification"

/**
 * @brief Posted when get record successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcGameGameIdKey,
 * @ref MtcGameUserUriKey,
 * @ref MtcGameMaxScoreKey,
 * @ref MtcGameLastScoreKey,
 * @ref MtcGameSumScoreKey,
 * @ref MtcGamePlayTimesKey,
 * @ref MtcGameRankKey.
 */
#define MtcGameGetRecordOkNotification "MtcGameGetRecordOkNotification"

/**
 * @brief Posted when failed to get record.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcGameGetRecordDidFailNotification "MtcGameGetRecordDidFailNotification"

/**
 * @brief Posted when get user record successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcGameGameIdKey,
 * @ref MtcGameUserUriKey,
 * @ref MtcGameMaxScoreKey,
 * @ref MtcGameLastScoreKey,
 * @ref MtcGameSumScoreKey,
 * @ref MtcGamePlayTimesKey,
 * @ref MtcGameRankKey.
 */
#define MtcGameGetUserRecordOkNotification "MtcGameGetUserRecordOkNotification"

/**
 * @brief Posted when failed to get user record.
 *
 * The pcInfo of this notification is ZNULL.
 */
#define MtcGameGetUserRecordDidFailNotification "MtcGameGetUserRecordDidFailNotification"

/** @} */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Update game score.
 * @param  zCookie The cookie value.
 * @param  pcGameId The game id.
 * @param  iScore The score to update.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_GameUpdateScore(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcGameId, ZINT iScore);

/**
 * @brief Get ranking.
 * @param  zCookie The cookie value.
 * @param  pcGameId The game id.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_GameGetRanking(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcGameId);

/**
 * @brief Get game info.
 * @param  zCookie The cookie value.
 * @param  pcGameId The game id.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_GameGetGameInfo(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcGameId);

/**
 * @brief Get record.
 * @param  zCookie The cookie value.
 * @param  pcGameId The game id.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_GameGetRecord(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcGameId);

/**
 * @brief Get user record.
 * @param  zCookie The cookie value.
 * @param  pcGameId The game id.
 * @param  pcUserUri The user uri, support both single uri in string format
 *         and multi uris in json array string format.
 * @retval ZOK On interface invoke successfully.
 * @retval ZFAILED On failed.
 */
MTCFUNC ZINT Mtc_GameGetUserRecord(ZCOOKIE zCookie,
    ZCONST ZCHAR *pcGameId, ZCONST ZCHAR *pcUserUri);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_GAME_H__ */

