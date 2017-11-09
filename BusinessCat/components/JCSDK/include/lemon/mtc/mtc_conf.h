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
  File name     : mtc_conf.h
  Module        : rich session enabler
  Author        : bob.liu
  Created on    : 2015-06-02
  Description   :
      Data structure and function declare required by mtc conference 

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_CONF_H__
#define _MTC_CONF_H__

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

#include "mtc_conf_db.h"

/**
 * @file
 * @brief MTC Conference Interfaces
 *
 * This file includes session and conference interface function.
 */
#ifdef __cplusplus
extern "C" {
#endif

/** @brief MTC video pattern mode */
typedef enum EN_MTC_VIDEO_PATTERN_TYPE
{
    EN_MTC_VIDEO_PATTERN_SOLO = 0,
    EN_MTC_VIDEO_PATTERN_TILE = 2,
    EN_MTC_VIDEO_PATTERN_CINEMA = 3,
    EN_MTC_VIDEO_PATTERN_PIP = 4
} EN_MTC_VIDEO_PATTERN_TYPE;

/** @brief Event type. */
typedef enum EN_MTC_CONF_EVENT_TYPE
{
    EN_MTC_CONF_EVENT_UNKNOWN,          /**< @brief Unknown error. */
    EN_MTC_CONF_EVENT_START_MEDIA,      /**< @brief Start media error. */
    EN_MTC_CONF_EVENT_STOP_MEDIA,       /**< @brief Stop media error. */
    EN_MTC_CONF_EVENT_START_FORWARD,    /**< @brief Start forward error. */
    EN_MTC_CONF_EVENT_STOP_FORWARD,     /**< @brief Stop forward error. */
    EN_MTC_CONF_EVENT_SET_TITLE,        /**< @brief Change title error. */
    EN_MTC_CONF_EVENT_SET_SCREEN,       /**< @brief Change shared screen error. */
    EN_MTC_CONF_EVENT_INVITE,
    EN_MTC_CONF_EVENT_KICKOUT,
    EN_MTC_CONF_EVENT_LEAVE,
    EN_MTC_CONF_EVENT_JOIN,
    EN_MTC_CONF_EVENT_CHAT
} EN_MTC_CONF_EVENT_TYPE;

/** @brief Reason type for error. */
typedef enum EN_MTC_CONF_REASON_TYPE
{
    EN_MTC_CONF_REASON_UNKNOWN = 2000,  /**< @brief Unknown reason. */
    EN_MTC_CONF_REASON_LEAVED,          /**< @brief Leaved. */
    EN_MTC_CONF_REASON_KICKED,          /**< @brief Kicked off. */
    EN_MTC_CONF_REASON_OFFLINE,         /**< @brief Peer is offline. */
    EN_MTC_CONF_REASON_DECLINE,         /**< @brief Peer declined. */
    EN_MTC_CONF_REASON_OVER,            /**< @brief Conference over. */

    EN_MTC_CONF_REASON_GENERAL_ERROR = 2100, /**< @brief General error. */
    EN_MTC_CONF_REASON_INVALID_CONFERENCE, /**< @brief Invalid conference. */
    EN_MTC_CONF_REASON_INVALID_PARTICIPANT, /**< @brief Invalid participant. */
    EN_MTC_CONF_REASON_TIMEOUT,         /**< @brief Timeout. */
    EN_MTC_CONF_REASON_INVALID_PASSWORD, /**< @brief Invalid password. */
    EN_MTC_CONF_REASON_NO_PERMISSION,   /**< @brief No permission. */
    EN_MTC_CONF_REASON_MEMBER_FULL,     /**< @brief Member full. */
    EN_MTC_CONF_REASON_MEDIA_ENGINE,    /**< @brief Media engine. */
    EN_MTC_CONF_REASON_INVALID_PARAM,   /**< @brief Invalid parameter. */
    EN_MTC_CONF_REASON_INVALID_CONFERENCE_NUMBER, /**< @brief Invalid conference number. */
    EN_MTC_CONF_REASON_INVALID_DOMAIN,  /**< @brief Invalid domain. */
    EN_MTC_CONF_REASON_MISMATCH,        /**< @brief Conference number and ID mismatch. */

    EN_MTC_CONF_REASON_PARAM_ERROR = 2200, /**< @brief Parameter error. */
    EN_MTC_CONF_REASON_NO_DOMAIN_ID,    /**< @brief No domain ID. */
    EN_MTC_CONF_REASON_NO_APP_ID,       /**< @brief No app ID. */
    EN_MTC_CONF_REASON_NO_CONFERENCE_ID, /**< @brief No conference ID. */
    EN_MTC_CONF_REASON_NO_CONFERENCE_NUMBER, /**< @brief No conference number. */
    EN_MTC_CONF_REASON_NO_PASSWORD,     /**< @brief No password. */
    EN_MTC_CONF_REASON_NO_REALY_ID,     /**< @brief No relay ID. */
    EN_MTC_CONF_REASON_NO_ROOM_ID,      /**< @brief No room ID. */
    EN_MTC_CONF_REASON_NO_CONFERENCE_SID, /**< @brief No conference service ID. */
    EN_MTC_CONF_REASON_NO_ACCOUNT_ID,   /**< @brief No account ID. */
    EN_MTC_CONF_REASON_NO_SESSION_ID,   /**< @brief No session ID. */
    EN_MTC_CONF_REASON_NO_HOST,         /**< @brief No host. */
    EN_MTC_CONF_REASON_NO_START_TIME,   /**< @brief No start time. */
    EN_MTC_CONF_REASON_NO_END_TIME,     /**< @brief No end time. */
    EN_MTC_CONF_REASON_NO_DURATION,     /**< @brief No duration. */
    EN_MTC_CONF_REASON_NO_RESERVATION_FLAG, /**< @brief No reservation flag. */
    EN_MTC_CONF_REASON_NO_CAPACITY,     /**< @brief No capacity. */
    EN_MTC_CONF_REASON_NO_VIDEO_FLAG,   /**< @brief No video flag. */
    EN_MTC_CONF_REASON_NO_RESERVATION_TIME, /**< @brief No reservation time. */
    EN_MTC_CONF_REASON_NO_RESERVATION_START_TIME, /**< @brief No reservation start time. */
    EN_MTC_CONF_REASON_NO_MEDIA_TYPE,   /**< @brief No media type. */
    EN_MTC_CONF_REASON_NO_TERMINATION_REASON, /**< @brief No termination reason. */
    EN_MTC_CONF_REASON_NO_PICTURE_SIZE, /**< @brief No picture size. */
    EN_MTC_CONF_REASON_NO_PICTURE_RATIO, /**< @brief No picture ratio. */
    EN_MTC_CONF_REASON_NO_WEBCASTING_URI, /**< @brief No webcasting URI. */
    EN_MTC_CONF_REASON_NO_COMPOSITE_MODE, /**< @brief No composite mode. */
    EN_MTC_CONF_REASON_NO_COMPOSITE_PICTURE_SIZE, /**< @brief No composite picture size. */
    EN_MTC_CONF_REASON_NO_ACCOUNT_NAME, /**< @brief No account name. */
    EN_MTC_CONF_REASON_NO_IVR_ROLE,     /**< @brief No IVR role. */
    EN_MTC_CONF_REASON_NO_RECORDER_ROLE,  /**< @brief No recorder role. */

    EN_MTC_CONF_REASON_EXCEED_LIMIT_ERROR = 2300, /**< @brief Exceed limit error. */
    EN_MTC_CONF_REASON_EXCEED_RESOLUTION, /**< @brief Exceed resolution limit. */
    EN_MTC_CONF_REASON_EXCEED_PARTICIPANT_COUNT, /**< @brief Exceed participants count. */
    EN_MTC_CONF_REASON_EXCEED_ROOM_COUNT, /**< @brief Exceed room count. */
    EN_MTC_CONF_REASON_EXCEED_TOTAL_PARTICIPANT_COUNT, /**< @brief Exceed total participants count. */
    EN_MTC_CONF_REASON_EXCEED_DOMAIN_RESOLUTION, /**< @brief Exceed resolution limit of domain. */
    EN_MTC_CONF_REASON_EXCEED_DOMAIN_PARTICIPANT_COUNT, /**< @brief Exceed participants count of domain. */
    EN_MTC_CONF_REASON_EXCEED_DOMAIN_ROOM_COUNT, /**< @brief Exceed room count of domain. */
    EN_MTC_CONF_REASON_EXCEED_DOMAIN_TOTAL_PARTICIPANT_COUNT, /**< @brief Exceed total participants count of domain. */
    EN_MTC_CONF_REASON_EXCEED_APP_RESOLUTION, /**< @brief Exceed resolution limit of app. */
    EN_MTC_CONF_REASON_EXCEED_APP_PARTICIPANT_COUNT, /**< @brief Exceed participants count of app. */
    EN_MTC_CONF_REASON_EXCEED_APP_ROOM_COUNT, /**< @brief Exceed room count of app. */
    EN_MTC_CONF_REASON_EXCEED_APP_TOTAL_PARTICIPANT_COUNT, /**< @brief Exceed total participants count of app. */

    EN_MTC_CONF_REASON_SERVER_ERROR = 2400, /**< @brief Server error. */
    EN_MTC_CONF_REASON_SERVER_NO_RESOURCE, /**< @brief No resource. */
    EN_MTC_CONF_REASON_SERVER_NO_RESOURCE_JSMS, /**< @brief No candidate server. */
    EN_MTC_CONF_REASON_SERVER_NO_RESOURCE_RELAY, /**< @brief No candidate server. */
    EN_MTC_CONF_REASON_SERVER_NO_RESOURCE_JMDS, /**< @brief No candidate server. */
    EN_MTC_CONF_REASON_SERVER_ALLOC_CONTENT, /**< @brief Allocate content error. */
    EN_MTC_CONF_REASON_SERVER_NO_ENGINED, /**< @brief No conference engine. */
} EN_MTC_CONF_REASON_TYPE;

/** @brief Minimal value of region ID */
#define MTC_CONF_REGION_ID_MIN      10
/** @brief Maximal value of region ID */
#define MTC_CONF_REGION_ID_MAX      99
/** @brief Region ID for default */
#define MTC_CONF_REGION_ID_DEFAULT  0

/**
 * @defgroup MtcConfState MTC participant status type of conference.
 * @{
 */
/** @brief Invalid state value. */
#define MTC_CONF_STATE_INVALID      0x00
/** @brief Conference server forwards the video. */
#define MTC_CONF_STATE_FWD_VIDEO    0x01
/** @brief Conference server forwards the audio. */
#define MTC_CONF_STATE_FWD_AUDIO    0x02
/** @brief The participant upload the video to server. */
#define MTC_CONF_STATE_VIDEO        0x04
/** @brief The participant upload the audio to server. */
#define MTC_CONF_STATE_AUDIO        0x08
/** @brief The cdn server upload state. */
#define MTC_CONF_STATE_CDN_PUSH     0x10

/** @brief The state of speech right control */
#define MTC_CONF_STATE_SPEECH_RIGHT_CONTROL 0x100
/** @brief The state of presenter */
#define MTC_CONF_STATE_PRESENTER            0x200
/** @brief The state of document sharing */
#define MTC_CONF_STATE_DOCUMENT_SHARING     0x400

/** @brief The valid service mask */
#define MTC_CONF_STATE_SERVICE_MASK \
    ( MTC_CONF_STATE_SPEECH_RIGHT_CONTROL \
    | MTC_CONF_STATE_PRESENTER \
    | MTC_CONF_STATE_DOCUMENT_SHARING)
/** @} */

/**
 * @defgroup MtcConfRole MTC participant role type of conference.
 * @{
 */
/** @brief only can receive */
#define MTC_CONF_ROLE_VIEWER           0x01
/** @brief only can.send*/
#define MTC_CONF_ROLE_SENDER           0x02
/** @brief can receive and send. */
#define MTC_CONF_ROLE_ACTOR            0x03
/** @brief his event will be broadcast */
#define MTC_CONF_ROLE_PLAYER           0x04
/** @brief normal participant, this is default roles */
#define MTC_CONF_ROLE_PARTP            0x07
/** @brief the autogen by Conference and only one participant */
#define MTC_CONF_ROLE_OWNER            0x08

/** @brief The role of speech right control */
#define MTC_CONF_ROLE_SPEECH_RIGHT_CONTROL 0x100
/** @brief The role of presenter */
#define MTC_CONF_ROLE_PRESENTER            0x200
/** @brief The role of document sharing */
#define MTC_CONF_ROLE_DOCUMENT_SHARING     0x400

/** @brief The valid service mask */
#define MTC_CONF_ROLE_SERVICE_MASK \
    ( MTC_CONF_ROLE_SPEECH_RIGHT_CONTROL \
    | MTC_CONF_ROLE_PRESENTER \
    | MTC_CONF_ROLE_DOCUMENT_SHARING)
/** @} */

/**
 * @defgroup MtcConfCap MTC participant capability of conference.
 * @{
 */
/** @brief The capability of speech right control */
#define MTC_CONF_CAP_SPEECH_RIGHT_CONTROL 0x100
/** @brief The capability of presenter */
#define MTC_CONF_CAP_PRESENTER            0x200
/** @brief The capability of document sharing */
#define MTC_CONF_CAP_DOCUMENT_SHARING     0x400
/** @} */

/**
 * @defgroup MtcConfMedia MTC media option of conference.
 * @{
 */
/** @brief Request for audio. */
#define MTC_CONF_MEDIA_AUDIO        0x01
/** @brief Request for video. */
#define MTC_CONF_MEDIA_VIDEO        0x02
/** @brief Request for both audio and video */
#define MTC_CONF_MEDIA_ALL          0x03
/** @} */

/**
 * @defgroup MtcConfRenderState MTC render state of conference.
 * @{
 */
/** @brief normal render state. */
#define MTC_CONF_RENDER_STATE_NORMAL        0x01
/** @brief stop by network blocked. */
#define MTC_CONF_RENDER_STATE_BLOCKED       0x02
/** @brief stop by user or server */
#define MTC_CONF_RENDER_STATE_PAUSED        0x03
/** @} */

/**
 * @defgroup MtcConfMode MTC mode of conference.
 * @{
 */
/** @brief all actors subscribe videos freely. */
#define MTC_CONF_MODE_VIEW_FREEDOM       0x01
/** @brief all actors subscribe the same videos. */
#define MTC_CONF_MODE_VIEW_UNIFORMITY    0x02
/** @} */


/**
 * @defgroup MtcConfQualityGrade MTC quality grade of conference's video.
 * @{
 */
/** @brief video quality is junior. */
#define MTC_CONF_QUALITY_GRADE_JUNIOR     0x0
/** @brief video quality is middle. */
#define MTC_CONF_QUALITY_GRADE_MIDDLE     0x01
/** @brief video quality is high. */
#define MTC_CONF_QUALITY_GRADE_HIGH       0x02
/** @} */

/**
 * @defgroup MtcConfPs MTC conference picture size.
 * @{
 */
/** @brief Request not to transmit video. */
#define MTC_CONF_PS_OFF     0
/** @brief Request to transmit video with minial picture size. */
#define MTC_CONF_PS_MIN     0x100
/** @brief Request to transmit video with small picture size. */
#define MTC_CONF_PS_SMALL   0x200
/** @brief Request to transmit video with large picture size. */
#define MTC_CONF_PS_LARGE   0x300
/** @brief Request to transmit video with maxium picture size. */
#define MTC_CONF_PS_MAX     0x400
/** @} */

/**
 * @defgroup MtcConfCompositeMode MTC conference composite mode.
 * @{
 */
/** @brief Merge screen content without any attendee's camera content. */
#define MTC_CONF_COMPOSITE_MODE_SCREEN    0x01
/** @brief Merge screen content with all attendees' camera content. */
#define MTC_CONF_COMPOSITE_MODE_PLATFORM  0x02
/** @brief Merge screen content with the speaker's camera content. */
#define MTC_CONF_COMPOSITE_MODE_SPEAKER   0x03
/** @brief Merge use layout callback */
#define MTC_CONF_COMPOSITE_MODE_LAYOUT    0x04
/** @} */

/**
 * @defgroup MtcConfCanvasMode MTC conference canvas mode.
 * @{
 */
/** @brief Landscape canvas. */
#define MTC_CONF_CANVAS_MODE_LANDSCAPE    0x00
/** @brief Portrait canvas. */
#define MTC_CONF_CANVAS_MODE_PORTRAIT     0x01
/** @} */

/**
 * @defgroup MtcConfKey MTC notification key of conference event.
 * @{
 */

/**
 * @brief A key whose value is a number object in json format reflecting 
 * error type @ref EN_MTC_CONF_EVENT_TYPE.
 */
#define MtcConfEventKey              "MtcConfEventKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * reason value @ref EN_MTC_CONF_REASON_TYPE.
 */
#define MtcConfReasonKey             "MtcConfReasonKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * detail failed reason.
 */
#define MtcConfDetailReasonKey             "MtcConfDetailReasonKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * conference resource.
 * @deprecated using MtcConfNumberKey
 */
#define MtcConfUriKey                "MtcConfUriKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * conference number.
 */
#define MtcConfNumberKey             "MtcConfNumberKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * ID of the conference has joined to.
 */
#define MtcConfIdKey                 "MtcConfIdKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * ID of the conference participant.
 */
#define MtcConfUserUriKey            "MtcConfUserUriKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * view mode of the conference. @ref MtcConfMode
 */
#define MtcConfViewModeKey            "MtcConfViewModeKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * Render tag of the conference participant.
 */
#define MtcConfRenderTagKey          "MtcConfRenderTagKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * title of conference.
 */
#define MtcConfTitleKey              "MtcConfTitleKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * shared custom data of conference.
 */
#define MtcConfDataKey               "MtcConfDataKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * ID of the conference participant who is using shared screen.
 */
#define MtcConfScreenUserKey         "MtcConfScreenUserKey"

/**
 * @brief A key whose value is a boolean object in json format reflecting 
 * if the conference is video conference.
 */
#define MtcConfIsVideoKey            "MtcConfIsVideoKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the participant status @ref MtcConfState.
 */
#define MtcConfStateKey              "MtcConfStateKey"

/**
 * @brief A key whose value is a number object in json format used by 
 * mark bits of participant status mask @ref MtcConfState.
 */
#define MtcConfStateMaskKey          "MtcConfStateMaskKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the participant role @ref MtcConfRole.
 */
#define MtcConfRoleKey               "MtcConfRoleKey"

/**
 * @brief A key whose value is a number object in json format used by 
 * mark bits of participant status @ref MtcConfRole.
 */
#define MtcConfRoleMaskKey           "MtcConfRoleMaskKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * the participant's display name.
 */
#define MtcConfDisplayNameKey        "MtcConfDisplayNameKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * the text message
 */
#define MtcConfTextKey               "MtcConfTextKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * the type of data.
 */
#define MtcConfDataTypeKey           "MtcConfDataTypeKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * the content of data.
 */
#define MtcConfDataContentKey        "MtcConfDataContentKey"

/**
 * @brief A key whose value is an array object in json format reflecting 
 * the participant list. Each array element is an object contains
 * @ref MtcConfUserUriKey, @ref MtcConfStateKey.
 */
#define MtcConfPartpLstKey           "MtcConfPartpLstKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the picture size value @ref MtcConfPs.
 */
#define MtcConfPictureSizeKey        "MtcConfPictureSizeKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the frame rate value from 1 to 30.
 */
#define MtcConfFrameRateKey          "MtcConfFrameRateKey"

/**
 * @brief A key whose value is a number object in json format reflecting
 * the media option type @ref MtcConfMedia.
 */
#define MtcConfMediaOptionKey        "MtcConfMediaOptionKey"

/**
 * @brief A key whose value is a number object in json format reflecting
 * the volume energy. Valid value from 0 to 100.
 */
#define MtcConfVolumeKey             "MtcConfVolumeKey"

/**
 * @brief A key whose value is a number object in json format reflecting
 * the network status. Valid value from 0 to 5.
 */
#define MtcConfNetworkStatusKey      "MtcConfNetworkStatusKey"

/**
 * @brief A key whose value is a boolean object in json format reflecting 
 * the network status indicates upstream network status, otherwise indicates
 * downstream network status.
 */
#define MtcConfIsUpstreamKey         "MtcConfIsUpstreamKey"

/**
 * @brief A key whose value is a number object in json format reflecting
 * the video render state type, @ref MtcConfRenderState.
 */
#define MtcConfVideoStateKey         "MtcConfVideoStateKey"

/**
 * @brief A key whose value is a number object in json format reflecting
 * the shared screen render state type, @ref MtcConfRenderState.
 */
#define MtcConfScreenStateKey        "MtcConfScreenStateKey"

/**
 * @brief A key whose value is an array object in json format reflecting 
 * the participant volume energy list. Each array element is an object contains
 * @ref MtcConfUserUriKey, @ref MtcConfVolumeKey.
 */
#define MtcConfPartpVolumeLstKey     "MtcConfPartpVolumeLstKey"

/**
 * @brief A key whose value is an array object in json format reflecting 
 * the participant network status list. Each array element is an object contains
 * @ref MtcConfUserUriKey, @ref MtcConfNetworkStatusKey.
 */
#define MtcConfPartpNetworkStatusListKey "MtcConfPartpNetworkStatusListKey"

/**
 * @brief A key whose value is an array object in json format reflecting 
 * the participant video render state list. Each array element is an object contains
 * @ref MtcConfUserUriKey, @ref MtcConfVideoStateKey.
 */
#define MtcConfPartpVideoStateLstKey "MtcConfPartpVideoStateLstKey"

/**
 * @brief A key whose value is an array object in json format reflecting 
 * the participant video render tag list. Each array element is an object contains
 * @ref MtcConfUserUriKey, @ref MtcConfRenderTagKey.
 */
#define MtcConfPartpVideoTagLstKey   "MtcConfPartpVideoTagLstKey"

/** 
 * @brief A key whose value is an array object in JSON format reflecting
 * the rectangle position and size. Each item is relative value of background.
 * The coordinate of the upper left corner of background is [0.0, 0.0].
 * The coordinate of the bottom right corner of background is [1.0, 1.0].
 * The 1st item is the X coordinate of the upper left corner.
 * The 2nd item is the Y coordinate of the upper left corner.
 * The 3rd item is the width. The 4th item is the height.
 */
#define MtcConfRectangleKey          "MtcConfRectangleKey"

/**
 * @brief A key whose value is a number object in JSON format reflecting
 * the ID of region which between 10 to 99.
 */
#define MtcRegionIdKey                  "MtcRegionIdKey"

/**
 * @brief A key whose value is a string object in JSON format reflecting
 * the name of region.
 */
#define MtcRegionNameKey                "MtcRegionNameKey"

/**
 * @brief A key whose value is a string object in JSON format reflecting
 * the description of region.
 */
#define MtcRegionDescKey                "MtcRegionDescKey"

/**
 * @brief A key whose value is object in JSON format contains
 * @ref MtcRegionIdKey, @ref MtcRegionNameKey, @ref MtcRegionDescKey.
 */
#define MtcConfDefaultRegionKey         "MtcConfDefaultRegionKey"

/** 
 * @brief A key whose value is array in JSON format. Each item is object contains
 * @ref MtcRegionIdKey, @ref MtcRegionNameKey, @ref MtcRegionDescKey.
 */
#define MtcConfOtherRegionKey           "MtcConfOtherRegionKey"

/** @} */

/**
 * @defgroup MtcConfPropKey MTC param key of conference create json string.
 * @{
 */

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the conference capacity, the max number of the actors in the conference, at least 4.
 */
#define MtcConfCapacityKey              "MtcConfCapacityKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the conference start or finish time remaining, positive number, milliseconds.
 */
#define MtcConfTimeRemainingKey         "MtcConfTimeRemainingKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the conference video quality @ref MtcConfQualityGrade.
 */
#define MtcConfQualityGradeKey          "MtcConfQualityGradeKey"

/**
 * @brief A key whose value is a bool object in json format reflecting 
 * the conference video aspect is square.
 */
#define MtcConfVideoSquareKey           "MtcConfVideoSquareKey"

/**
 * @brief A key whose value is a bool object in json format reflecting 
 * the conference using security transmission.
 */
#define MtcConfSecurityKey              "MtcConfSecurityKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the current client count in conference.
 */
#define MtcConfClientCountKey           "MtcConfClientCountKey"

/** 
 * @brief A key whose value is array in JSON format. Each item is an user
 * in the conference.
 */
#define MtcConfMemberListKey           "MtcConfMemberListKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * the conference passard.
 * the password contains any letter or digit.
 */
#define MtcConfPasswordKey              "MtcConfPasswordKey"

/**
 * @brief A key whose value is a string object in json format reflecting
 * the start time of conference, in milliseconds.
 */
#define MtcConfStartTimeKey             "MtcConfStartTimeKey"

/**
 * @brief A key whose value is a string object in json format reflecting
 * the duration time of conference, in milliseconds.
 */
#define MtcConfDurationKey              "MtcConfDurationKey"

/**
 * @brief A key whose value is a boolean object in json format reflecting 
 * whether the conference has a replay function.
 */
#define MtcConfReplayKey                "MtcConfReplayKey"

/**
 * @brief A key whose value is a string object in json format reflecting 
 * the URI for webcasting,
 * if empty will auto choosed.
 * if end with '/',will auto append the conference number.
 */
#define MtcConfWebCastingUriKey         "MtcConfWebCastingUriKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the composite mode, @ref MtcConfCompositeMode.
 */
#define MtcConfCompositeModeKey         "MtcConfCompositeModeKey"

/**
 * @brief A key whose value is a number object in json format reflecting 
 * the composited picture size, @ref MtcConfPs.
 */
#define MtcConfCompositePictureSizeKey  "MtcConfCompositePictureSizeKey"
/** @} */

/**
 * @defgroup MtcConfNotification MTC notification of conference event.
 * @{
 */

/**
 * @brief Posted when region information loaded.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfDefaultRegionKey
 * @ref MtcConfOtherRegionKey
 */
#define MtcConfLoadRegionInfoOkNotification "MtcConfLoadRegionInfoOkNotification"

/**
 * @brief Posted when region information load failed.
 */
#define MtcConfLoadRegionInfoDidFailNotification "MtcConfLoadRegionInfoDidFailNotification"

/**
 * @brief Posted when conference resource created.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfUriKey
 * @ref MtcConfNumberKey
 * @ref MtcConfIsVideoKey
 */
#define MtcConfCreateOkNotification         "MtcConfCreateOkNotification"

/**
 * @brief Posted when conference resource create failed.
 */
#define MtcConfCreateDidFailNotification    "MtcConfCreateDidFailNotification"

/**
 * @brief Posted when query conference URI OK.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfUriKey
 * @ref MtcConfNumberKey
 * @ref MtcConfTitleKey
 * @ref MtcConfIsVideoKey
 * @ref MtcConfStartTimeKey
 * @ref MtcConfDurationKey
 * @ref MtcRegionIdKey
 * @ref MtcRegionNameKey
 * @ref MtcRegionDescKey
 */
#define MtcConfQueryOkNotification          "MtcConfQueryOkNotification"

/**
 * @brief Posted when query conference URI failed.
 */
#define MtcConfQueryDidFailNotification     "MtcConfQueryDidFailNotification"

/**
 * @brief Posted when conference resource reserved.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfNumberKey.
 */
#define MtcConfReserveOkNotification        "MtcConfReserveOkNotification"

/**
 * @brief Posted when conference resource reserve failed.
 */
#define MtcConfReserveDidFailNotification   "MtcConfReserveDidFailNotification"

/**
 * @brief Posted when cancel reservation OK.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfNumberKey.
 */
#define MtcConfCancelReservationOkNotification "MtcConfCancelReservationOkNotification"

/**
 * @brief Posted when cancel reservation failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfReasonKey
 */
#define MtcConfCancelReservationDidFailNotification "MtcConfCancelReservationDidFailNotification"

/**
 * @brief Posted when there is a conference invitation received.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfUriKey
 * @ref MtcConfNumberKey
 * @ref MtcConfTitleKey
 * @ref MtcConfIsVideoKey
 * @ref MtcConfUserUriKey indicates who send the invitation.
 * @ref MtcConfPasswordKey
 */
#define MtcConfInviteReceivedNotification   "MtcConfInviteReceivedNotification"

/**
 * @brief Posted when there is a conference cancel received.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfUriKey
 * @ref MtcConfNumberKey
 * @ref MtcConfTitleKey
 * @ref MtcConfIsVideoKey
 * @ref MtcConfReasonKey
 * @ref MtcConfUserUriKey indicates who send the cancel
 */
#define MtcConfCancelReceivedNotification   "MtcConfCancelReceivedNotification"

/**
 * @brief Posted when join to a conference successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfPartpLstKey
 * @ref MtcConfTitleKey,
 * @ref MtcConfDataKey
 * @ref MtcConfScreenUserKey
 * @ref MtcConfViewModeKey
 * @ref MtcConfQualityGradeKey
 * @ref MtcConfVideoSquareKey
 * @ref MtcConfPropUserDefined
 * @ref MtcConfPropDocumentUri
 * @ref MtcConfPropDocumentPageId
 * @ref MtcRegionIdKey
 * @ref MtcRegionNameKey
 * @ref MtcRegionDescKey
 */
#define MtcConfJoinOkNotification           "MtcConfJoinOkNotification"

/**
 * @brief Posted when join to a conference failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfEventKey
 * @ref MtcConfReasonKey.
 */
#define MtcConfJoinDidFailNotification      "MtcConfJoinDidFailNotification"

/**
 * @brief Posted when there is another user has joined to the conference.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfUserUriKey
 * @ref MtcConfDisplayNameKey
 * @ref MtcConfRoleKey
 * @ref MtcConfStateKey.
 */
#define MtcConfJoinedNotification           "MtcConfJoinedNotification"

/**
 * @brief Posted when leaved from the conference.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfEventKey
 * @ref MtcConfReasonKey
 */
#define MtcConfDidLeaveNotification         "MtcConfDidLeaveNotification"

/**
 * @brief Posted when there is another user has leaved from the conference.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfUserUriKey.
 */
#define MtcConfLeavedNotification           "MtcConfLeavedNotification"

/**
 * @brief Posted when invitation sent out successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfEventKey
 * @ref MtcConfUserUriKey.
 */
#define MtcConfInviteOkNotification         "MtcConfInviteOkNotification"

/**
 * @brief Posted when invitation sent out failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfUserUriKey
 * @ref MtcConfEventKey
 * @ref MtcConfReasonKey.
 */
#define MtcConfInviteDidFailNotification    "MtcConfInviteDidFailNotification"

/**
 * @brief Posted when kickout sent out successfully.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfUserUriKey
 */
#define MtcConfKickOkNotification           "MtcConfKickOkNotification"

/**
 * @brief Posted when kickout sent out failed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfUserUriKey
 * @ref MtcConfEventKey
 * @ref MtcConfReasonKey
 */
#define MtcConfKickDidFailNotification      "MtcConfKickDidFailNotification"

/**
 * @brief Posted when a participant's state changed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfUserUriKey
 * @ref MtcConfStateKey.
 * @ref MtcConfRoleKey
 * @ref MtcConfDisplayNameKey
 */
#define MtcConfParticipantChangedNotification "MtcConfParticipantChangedNotification"

/**
 * @brief Posted when conference property changed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfTitleKey
 * @ref MtcConfDataKey
 * @ref MtcConfScreenUserKey
 * @ref MtcConfPropUserDefined
 * @ref MtcConfPropDocumentUri
 * @ref MtcConfPropDocumentPageId
 */
#define MtcConfPropertyChangedNotfication   "MtcConfPropertyChangedNotfication"

/**
 * @brief Posted when volume energy changed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfPartpVolumeLstKey.
 */
#define MtcConfVolumeChangedNotification    "MtcConfVolumeChangedNotification"

/**
 * @brief Posted when volume energy changed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfPartpNetworkStatusListKey.
 * @ref MtcConfIsUpstreamKey.
 */
#define MtcConfNetworkStatusChangedNotification "MtcConfNetworkStatusChangedNotification"

/**
 * @brief Posted when render state changed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfPartpVideoStateLstKey
 * @ref MtcConfScreenStateKey
 */
#define MtcConfRenderChangedNotification    "MtcConfRenderChangedNotification"

/**
 * @brief Posted when render tag changed.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfPartpVideoTagLstKey
 */
#define MtcConfRenderTagChangedNotification "MtcConfRenderTagChangedNotification"

/**
 * @brief Posted when received text message.
 *
 * The pcInfo of this notification contains 
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfUserUriKey
 * @ref MtcConfTextKey.
 */
#define MtcConfTextReceivedNotification     "MtcConfTextReceivedNotification"

/**
 * @brief Posted when received data message.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey,
 * @ref MtcConfNumberKey
 * @ref MtcConfUserUriKey
 * @ref MtcConfDataTypeKey
 * @ref MtcConfDataContentKey.
 */
#define MtcConfDataReceivedNotification     "MtcConfDataReceivedNotification"

/**
 * @brief Posted when received bypass data message.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey,
 * @ref MtcConfNumberKey
 * @ref MtcConfDataTypeKey
 * @ref MtcConfDataContentKey.
 */
#define MtcConfBypassDataReceivedNotification "MtcConfBypassDataReceivedNotification"

/**
 * @brief Posted when there is an error.
 *
 * The pcInfo of this notification contains
 * @ref MtcConfIdKey
 * @ref MtcConfNumberKey
 * @ref MtcConfEventKey
 * @ref MtcConfReasonKey.
 */
#define MtcConfErrorNotification            "MtcConfErrorNotification"

/** @} */

/**
 * @brief MTC get JSM version
 *
 * @return JSM version.
 */
MTCFUNC ZCONST ZCHAR * Mtc_GetJsmVersion(ZFUNC_VOID);

/**
 * @brief Get region information.
 *
 * @return Region information which is a object in JSON. It contains
 * @ref MtcConfDefaultRegionKey and @ref MtcConfOtherRegionKey.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ConfGetRegionInfo(ZFUNC_VOID);

/**
 * @brief Load region information from server.
 *
 * @retval ZOK on succeed, result will be notified by 
 * @ref MtcConfLoadRegionInfoOkNotification or
 * @ref MtcConfLoadRegionInfoDidFailNotification.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfLoadRegionInfo(ZFUNC_VOID);

/**
 * @brief Join a meeting room directily. The room is identified by room ID.
 * 
 * @param  iRegionId     The region ID.
 * @param  pcRoomId      The User Defined ID of room.
 * @param  zCookie       The cookie value.
 * @param  pcDisplayName The display name string.
 * @param  bVideo        Video flag.
 * @param  pcParm  The json string, param key is @ref MtcConfPropKey,
 *                     @ref MtcConfViewModeKey, @ref MtcConfStateKey.
 * 
 * @return The conference ID when send request successfully.
 * Otherwise return ZMAXUINT.
 */
MTCFUNC ZUINT Mtc_ConfJoinRoom(ZINT iRegionId, 
    ZCONST ZCHAR *pcRoomId, ZCOOKIE zCookie, ZCONST ZCHAR *pcDisplayName,
    ZBOOL bVideo, ZCONST ZCHAR *pcParm);

/**
 * @brief Join a meeting room as viewer. The room is identified by room ID.
 * 
 * @param  iRegionId     The region ID.
 * @param  pcRoomId      The User Defined ID of room.
 * @param  zCookie       The cookie value.
 * 
 * @return The conference ID when send request successfully.
 * Otherwise return ZMAXUINT.
 */
MTCFUNC ZUINT Mtc_ConfJoinRoomAsViewer(ZINT iRegionId, 
    ZCONST ZCHAR *pcRoomId, ZCOOKIE zCookie);

/**
 * @brief Query room. The room is identified by room ID.
 * 
 * @param  iRegionId     The region ID.
 * @param  pcRoomId      The User Defined ID of room.
 * @param  zCookie       The cookie value.
 * 
 * @retval ZOK on succeed. 
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfQueryRoom(ZINT iRegionId, 
    ZCONST ZCHAR *pcRoomId, ZCOOKIE zCookie);

/** 
 * @brief Create a conference resource.
 *
 * If conference resource created successfully,
 * @ref MtcConfCreateOkNotification will be notified with
 * the URI of conference resource.
 * Otherwise @ref MtcConfCreateDidFailNotification will be notified.
 *
 * @param [in] zCookie Used to correspond conference with UI resource.
 * @param [in] iRegionId Region ID.
 * @param [in] pcTitle Conference title.
 * @param [in] pcPassword Conference password, contains any letter or digit.
 * @param [in] bVideo ZTRUE for video conference, ZFALSE for voice conference.
 * @param [in] pcParm  The json string, param key is @ref MtcConfPropKey,
 *                     @ref MtcConfViewModeKey
 *
 * @retval ZOK on succeed. 
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfCreateEx(ZCOOKIE zCookie, ZINT iRegionId,
    ZCONST ZCHAR *pcTitle, ZCONST ZCHAR *pcPassword, ZBOOL bVideo,
    ZCONST ZCHAR *pcParm);

/**
 * @brief Query a conference resource.
 *
 * If query conference resource successfully,
 * @ref MtcConfQueryOkNotification will be notified with
 * the URI of conference resource.
 * Otherwise @ref MtcConfQueryDidFailNotification will be notified.
 *
 * @param  zCookie Cookie used by UI.
 * @param  iConfNo The conference number.
 *
 * @retval ZOK Query sent successfully.
 * @retval ZFAILED Query sent failed.
 */
MTCFUNC ZINT Mtc_ConfQuery(ZCOOKIE zCookie, ZINT iConfNo);

/** 
 * @brief Reserve a conference resource.
 *
 * If conference resource reserved successfully,
 * @ref MtcConfReserveOkNotification will be notified with
 * the URI of conference resource.
 * Otherwise @ref MtcConfReserveDidFailNotification will be notified.
 *
 * @param [in] zCookie Used to correspond conference with UI resource.
 * @param [in] iRegionId Region ID.
 * @param [in] qwStartTs Conference start time, seconds from 1/1/1970 00:00:00 GMT.
 * @param [in] qwDuration Conference duration seconds.
 * @param [in] pcTitle Conference title.
 * @param [in] bVideo ZTRUE for video conference, ZFALSE for voice conference.
 * @param [in] pcParm  The json string, param key is @ref MtcConfPropKey
 *
 * @retval ZOK on succeed. 
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfReserve(ZCOOKIE zCookie, ZINT iRegionId, ZUINT64 qwStartTs, 
    ZUINT64 qwDuration, ZCONST ZCHAR *pcTitle, ZBOOL bVideo, ZCONST ZCHAR *pcParm);

/**
 * @brief Cancel a conference reservation.
 * 
 * @param  zCookie Cookie value.
 * @param  iConfNo The conference number.
 * 
 * @retval ZOK on succeed. 
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfCancelReservation(ZCOOKIE zCookie, ZINT iConfNo);

/** 
 * @brief Join a conference.
 *
 * When join to the conference successfully,
 * @ref MtcConfJoinOkNotification will be notified.
 *
 * @param [in] pcUri The URI of conference resource.
 * @param [in] zCookie Used to correspond conference with UI resource.
 * @param [in] pcDisplayName Used to display name, must UTF-8 encoding.
 * @param [in] iRoles The role type of participant, option @ref MtcConfRole
 * @param [in] pcPassword The passord of conference, it is option.
 *
 * @return The conference ID when send request successfully.
 * Otherwise return ZMAXUINT.
 *
 * @see Mtc_ConfCreate
 */
MTCFUNC ZUINT Mtc_ConfJoinEx(ZCONST ZCHAR *pcUri, ZCOOKIE zCookie,
    ZCONST ZCHAR *pcDisplayName, ZUINT iRoles, ZCONST ZCHAR *pcPassword);

/** 
 * @brief Join a conference.
 *
 * When join to the conference successfully,
 * @ref MtcConfJoinOkNotification will be notified.
 *
 * @param [in] pcUri The URI of conference resource.
 * @param [in] zCookie Used to correspond conference with UI resource.
 * @param [in] pcPassword The passord of conference, it is option.
 * @param [in] iRoles The role type of participant, option @ref MtcConfRole
 * @param [in] pcParm More parameters which is a object in JSON format, contains
 *                    @ref MtcConfDisplayNameKey, @ref MtcConfStateKey
 *
 * @return The conference ID when send request successfully.
 * Otherwise return ZMAXUINT.
 *
 * @see Mtc_ConfCreate
 */
MTCFUNC ZUINT Mtc_ConfJoin(ZCONST ZCHAR *pcUri, ZCOOKIE zCookie,
    ZCONST ZCHAR *pcPassword, ZUINT iRoles, ZCONST ZCHAR *pcParm);

/**
 * @brief Join conference's relay node.
 * @param  pcUri      The conference URI.
 * @param  zCookie    The cookie value.
 * @param  pcPassword The conference's password.
 * 
 * @return The conference ID when send request successfully.
 * Otherwise return ZMAXUINT.
 */
MTCFUNC ZUINT Mtc_ConfJoinAsViewer(ZCONST ZCHAR *pcUri, ZCOOKIE zCookie,
    ZCONST ZCHAR *pcPassword);

/** 
 * @brief Send text in the conference.
 *
 * @param [in] iConfId The ID of conference in which you chat.
 * @param [in] pcUserUri The URI of target user, NULL will broadcast.
 * @param [in] pcText  The  UTF8 encoding message
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfSendText(ZUINT iConfId, ZCONST ZCHAR *pcUserUri,
    ZCONST ZCHAR *pcText);

/** 
 * @brief Send data in the conference.
 *
 * @param [in] iConfId The ID of conference in which you chat.
 * @param [in] pcUserUri The URI of target user, NULL will broadcast.
 * @param [in] pcType  The data type.
 * @param [in] pcContent  The data content in UTF8.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfSendData(ZUINT iConfId, ZCONST ZCHAR *pcUserUri,
    ZCONST ZCHAR *pcType, ZCONST ZCHAR *pcContent);

/** 
 * @brief Send bypass data in the conference.
 *
 * @param [in] iConfId The ID of conference in which you chat.
 * @param [in] pcType  The data type.
 * @param [in] pcContent The data content.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfSendBypassData(ZUINT iConfId, ZCONST ZCHAR *pcType,
    ZCONST ZCHAR *pcContent);

/** 
 * @brief Leave a conference.
 *
 * When leave the conference successfully,
 * @ref MtcConfDidLeaveNotification will be notified.
 *
 * @param [in] iConfId The ID of conference which you want leave.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 *
 * @see Mtc_ConfJoin
 */
MTCFUNC ZINT Mtc_ConfLeave(ZUINT iConfId);

/** 
 * @brief Invite an user to the conference.
 *
 * When invitation has been delivieried to peer successfully,
 * @ref MtcConfInviteOkNotification will be notified.
 * Otherwise @ref MtcConfInviteDidFailNotification will be notified.
 *
 * @param [in] iConfId The ID of conference to which you want invite new
 *                      participant.
 * @param [in] pcUserUri The URI of user invited.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 *
 * @see Mtc_ConfKickUser
 */
MTCFUNC ZINT Mtc_ConfInviteUser(ZUINT iConfId, ZCONST ZCHAR *pcUserUri);

/** 
 * @brief decline the invite from  conference.
 *
 * @param [in] pcUri The URI of conference resource.
 * @param [in] pcUserUri The URI of target user.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 *
 * @see Mtc_ConfInviteUser
 */
MTCFUNC ZINT Mtc_ConfDeclineInvite(ZCONST ZCHAR *pcUri, ZCONST ZCHAR *pcUserUri);

/** 
 * @brief Kick an user out of the conference.
 *
 * When invitation has been delivieried to server successfully,
 * @ref MtcConfKickOkNotification will be notified.
 * Otherwise @ref MtcConfKickDidFailNotification will be notified.
 *
 * @param [in] iConfId The ID of conference to which you want kick participant.
 * @param [in] pcUserUri The URI of user.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 *
 * @see Mtc_ConfInviteUser
 */
MTCFUNC ZINT Mtc_ConfKickUser(ZUINT iConfId, ZCONST ZCHAR *pcUserUri);

/** 
 * @brief Set video capture device for conference.
 *
 * @param [in] iConfId The ID of conference.
 * @param [in] pcName Capture device name.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfSetVideoCapture(ZUINT iConfId, ZCONST ZCHAR *pcName);

/** 
 * @brief Set video capture layout for conference.
 *
 * @param [in] iConfId The ID of conference.
 * @param [in] iPattern Layout pattern.
 * @param [in] pcConfig A string which is a JSON array contains 
 *                      string of ID of capture device.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfSetVideoCaptureLayout(ZUINT iConfId, ZUINT iPattern,
    ZCONST ZCHAR *pcConfig);

/** 
 * @brief Set screen capture device for conference.
 *
 * @param [in] iConfId The ID of conference.
 * @param [in] pcName Capture device name.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfSetScreenCapture(ZUINT iConfId, ZCONST ZCHAR *pcName);

/** 
 * @brief Set microphone file  for conference.
 *
 * @param [in] iConfId The ID of conference.
 * @param [in] pcName microphone file path.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfSetFileAsMicrophone(ZUINT iConfId, ZCONST ZCHAR *pcName);

/** 
 * @brief Set user for conference shared screen.
 *
 * @param [in] iConfId The ID of conference.
 * @param [in] pcUserUri The URI of user.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfSetScreenUser(ZUINT iConfId, ZCONST ZCHAR *pcUserUri);

/** 
 * @brief Start media sending.
 *
 * @param [in] iConfId The ID of conference to which you want kick participant.
 * @param [in] iMediaOption Media option @ref MtcConfMedia.
 *
 * @retval ZOK Start media sending successfully, and request has sent to server.
 *             If request failed, @ref MtcConfErrorNotification will be notified.
 * @retval ZFAILED Fail to start media sending.
 */
MTCFUNC ZINT Mtc_ConfStartSend(ZUINT iConfId, ZUINT iMediaOption);

/** 
 * @brief Stop media sending.
 *
 * @param [in] iConfId The ID of conference to which you want kick participant.
 * @param [in] iMediaOption Media option @ref MtcConfMedia.
 *
 * @retval ZOK Stop media sending successfully, and request has sent to server.
 *             If request failed, @ref MtcConfErrorNotification will be notified.
 * @retval ZFAILED Fail to stop media sending.
 */
MTCFUNC ZINT Mtc_ConfStopSend(ZUINT iConfId, ZUINT iMediaOption);

/** 
 * @brief Start conference CDN service
 *
 * @param [in] iConfId The ID of conference.
 *
 * @retval ZOK
 * @retval ZFAILED Fail to start CDN service.
 */
MTCFUNC ZINT Mtc_ConfStartCdn(ZUINT iConfId);

/** 
 * @brief Stop conference CDN service.
 *
 * @param [in] iConfId The ID of conference.
 *
 * @retval ZOK
 * @retval ZFAILED Fail to stop CDN service.
 */
MTCFUNC ZINT Mtc_ConfStopCdn(ZUINT iConfId);

/**
 * @brief Set participant's role.
 * 
 * @param  iConfId   The ID of conference.
 * @param  pcUserUri The user's URI, ZNULL for self.
 * @param  iMask     The mask of value, @ref MtcConfRole.
 * @param  iValue    The value, @ref MtcConfRole.
 * 
 * @return           ZOK when succeed. ZFAILED when failed.
 */
MTCFUNC ZINT Mtc_ConfSetRole(ZUINT iConfId, ZCONST ZCHAR *pcUserUri,
    ZUINT iMask, ZUINT iValue);

/**
 * @brief Set participant's state.
 * 
 * @param  iConfId   The ID of conference.
 * @param  pcUserUri The user's URI, ZNULL for self.
 * @param  iMask     The mask of value, @ref MtcConfState.
 * @param  iValue    The value, @ref MtcConfState.
 * 
 * @return           ZOK when succeed. ZFAILED when failed.
 */
MTCFUNC ZINT Mtc_ConfSetState(ZUINT iConfId, ZCONST ZCHAR *pcUserUri,
    ZUINT iMask, ZUINT iValue);

/**
 * @defgroup MtcConfReq MTC request parameters.
 * @{
 */

/**
 * @brief Start forwarding media of specific participant.
 * 
 * The pcParm is a string which is a object in JSON format includes
 * @ref MtcConfUserUriKey, @ref MtcConfMediaOptionKey.
 */
#define MtcConfCmdStartForward      "MtcConfCmdStartForward"

/**
 * @brief Stop forwarding media of specific praticipant.
 * 
 * The pcParm is a string which is a object in JSON format includes
 * @ref MtcConfUserUriKey, @ref MtcConfMediaOptionKey.
 */
#define MtcConfCmdStopForward       "MtcConfCmdStopForward"

/**
 * @brief Request video of specific participant.
 *
 * The pcParm is a string which is a object in JSON format includes
 * @ref MtcConfUserUriKey, @ref MtcConfPictureSizeKey and @ref MtcConfFrameRateKey.
 */
#define MtcConfCmdRequestVideo      "MtcConfCmdRequestVideo"

/**
 * @brief Command name of change title.
 *
 * The pcParm is a string which is a object in JSON format includes
 * @ref MtcConfTitleKey.
 */
#define MtcConfCmdChangeTitle       "MtcConfCmdChangeTitle"


/**
 * @brief Command name of invite some users.
 *
 * The pcParm is a string which is a array in JSON format includes
 * uri.
 */
#define MtcConfCmdInviteUsers       "MtcConfCmdInviteUsers"

/**
 * @brief Command name of set property of  some users.
 *
 * The pcParm is a string which is a JSON format includes
 * @ref MtcConfPartpLstKey, @ref MtcConfDisplayNameKey,
 * @ref MtcConfRoleKey, and @ref MtcConfStateKey
 */
#define MtcConfCmdSetPartpProp       "MtcConfCmdSetPartpProp"

/**
 * @brief Command name of apply layout to replayer.
 *
 * The pcParm is a string in JSON array format.
 * Each item of array is the participant's layout information, which includes
 * @ref MtcConfUserUriKey, @ref MtcConfPictureSizeKey,
 * @ref MtcConfRectangleKey.
 */
#define MtcConfCmdReplayApplyLayout  "MtcConfCmdReplayApplyLayout"

/**
 * @brief Command name of replayer to set layout mode.
 *
 * The pcParm is a string in JSON format which contains
 * @ref MtcConfCompositeModeKey.
 */
#define MtcConfCmdReplayApplyMode    "MtcConfCmdReplayApplyMode"

/**
 * @brief Command name of replayer to start push content to CDN.
 */
#define MtcConfCmdReplayStartWebCasting "MtcConfCmdReplayStartWebCasting"

/**
 * @brief Command name of replayer to stop push content to CDN.
 */
#define MtcConfCmdReplayStopWebCasting "MtcConfCmdReplayStopWebCasting"

/**
 * @brief Command name of replayer to start record.
 *
 * The pcParm is a string in JSON format which contains
 * @ref MtcConfIsVideoKey
 */
#define MtcConfCmdReplayStartRecord "MtcConfCmdReplayStartRecord"

/**
 * @brief Command name of replayer to stop record.
 */
#define MtcConfCmdReplayStopRecord  "MtcConfCmdReplayStopRecord"

/**
 * @brief A key whose value is a object in JSON format reflecting 
 * the storage information, which contains
 * @ref MtcConfProtocolKey,
 * @ref MtcConfAccessKeyKey,
 * @ref MtcConfSecretKeyKey,
 * @ref MtcConfBucketNameKey,
 * @ref MtcConfFileKeyKey.
 */
#define MtcConfStorageKey           "Storage"

/**
 * @brief A key whose value is a string object in JSON format reflecting 
 * the storage protocol type. Avaliable values contains "qiniu".
 */
#define MtcConfProtocolKey          "Protocol"

/**
 * @brief A key whose value is a string object in JSON format reflecting 
 * the access key value of storage.
 */
#define MtcConfAccessKeyKey         "AccessKey"

/**
 * @brief A key whose value is a string object in JSON format reflecting 
 * the secret key value of storage.
 */
#define MtcConfSecretKeyKey         "SecretKey"

/**
 * @brief A key whose value is a string object in JSON format reflecting 
 * the bucket name.
 */
#define MtcConfBucketNameKey        "BucketName"

/**
 * @brief A key whose value is a string object in JSON format reflecting 
 * the file key.
 */
#define MtcConfFileKeyKey           "FileKey"

/** @} */

/**
 * @brief Request to change conference parameters.
 *
 * @param [in] iConfId The ID of conference.
 * @param [in] pcCmd   The command name, @ref MtcConfReq.
 * @param [in] pcParm  The parameter string, reference each command description.
 *
 * @retval ZOK Command has been sent out successfully.
 *             When server accept the command, there will be
 *             a @ref MtcConfParticipantChangedNotification
 *             notification.
 *             When server reject the command or timeout, there will be
 *             a @ref MtcConfErrorNotification notification.
 * @retval ZFAILED Fail to sent the command.
 */
MTCFUNC ZINT Mtc_ConfCommand(ZUINT iConfId, ZCONST ZCHAR *pcCmd,
    ZCONST ZCHAR *pcParm);

/**
 * @defgroup MtcConfProp MTC conference property's name.
 * @{
 */

/**
 * @brief Property name of conference title.
 * This property is readonly.
 */
#define MtcConfPropTitle            MtcConfTitleKey

/**
 * @brief Property name of conference number.
 * This property is readonly.
 */
#define MtcConfPropConfNumber       MtcConfNumberKey

/**
 * @brief Property name of conference's max participant count.
 * This property is readonly.
 */
#define MtcConfPropCapacity         MtcConfCapacityKey

/**
 * @brief Property name of conference's password.
 * This property is readonly.
 */
#define MtcConfPropPassword         MtcConfPasswordKey

/**
 * @brief Property name of conference start timestamp in milliseconds.
 * This property is readonly.
 */
#define MtcConfPropStartTime        MtcConfStartTimeKey

/**
 * @brief Property name of conference duration time in milliseconds.
 * This property is readonly.
 */
#define MtcConfPropDuration         MtcConfDurationKey

/**
 * @brief Property name of conference URI.
 * This property is readonly.
 */
#define MtcConfPropConfUri          MtcConfUriKey

/**
 * @brief Property name of conference shared screen URI.
 * This property is readonly.
 */
#define MtcConfPropScreenUri        "ScreenURI"

/**
 * @brief Property name of conference shared delivery URI.
 * This property is readonly.
 */
#define MtcConfPropDeliveryUri      "DeliveryURI"

/**
 * @brief Property name of user defined value.
 */
#define MtcConfPropUserDefined      MtcConfDataKey

/**
 * @brief Property name of the sharing document's URI.
 */
#define MtcConfPropDocumentUri      "DSR.Uri"

/**
 * @brief Property name of the sharing document's page Id.
 */
#define MtcConfPropDocumentPageId    "DSR.PageId"
/** @} */

/**
 * @brief Get conference property's value.
 *
 * @param [in] iConfId The ID of conference.
 * @param [in] pcName  The property name. @ref MtcConfProp
 *
 * @return Reference @ref MtcConfProp for detail. ZNULL when failed.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ConfGetProp(ZUINT iConfId, ZCONST ZCHAR *pcName);

/**
 * @brief Set conference property.
 * 
 * @param  iConfId The ID of conference.
 * @param  pcName  The property name. @ref MtcConfProp
 * @param  pcValue The property value. Use ZNULL to delete this value.
 *
 * @return         ZOK when succeed. ZFAILED when failed.
 *
 * If specific property is not found, it will create new one.
 * If same property is found, it replace the value.
 *
 * Other participants will be notified by @ref MtcConfPropertyChangedNotfication
 * when property was set.
 */
MTCFUNC ZINT Mtc_ConfSetProp(ZUINT iConfId, ZCONST ZCHAR *pcName,
    ZCONST ZCHAR *pcValue);

/**
 * @brief Get count of conference participants.
 *
 * @param [in] iConfId The ID of conference.
 *
 * @return         The count of participants.
 */
MTCFUNC ZUINT Mtc_ConfGetPartpCount(ZUINT iConfId);

/**
 * @brief Get all user's URI of conference.
 *
 * @param [in] iConfId The ID of conference.
 *
 * @return         The string is an array object in JSON format contains
 *                 all the user's URI of conference.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ConfGetAllPartp(ZUINT iConfId);

/**
 * @brief Get properties of one participant.
 *
 * @param [in] iConfId   The ID of conference
 * @param [in] pcUserUri The user's URI of the participant.
 *
 * @return           The string is an object in JSON format contains
 *                   @ref MtcConfStateKey.
 *                   ZNULL indicates failed.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ConfGetPartpProp(ZUINT iConfId,
    ZCONST ZCHAR *pcUserUri);

/**
 * @defgroup MtcConfStatistics MTC Conference Statistics Type
 * @{
 */
/**
 * @brief Configuration statistics.
 */
#define MTC_CONF_STS_CONFIG     "MtcConfStsConfig"

/**
 * @brief Network statistics.
 */
#define MTC_CONF_STS_NETWORK    "MtcConfStsNetwork"

/**
 * @brief Transport statistics.
 */
#define MTC_CONF_STS_TRANSPORT  "MtcConfStsTransport"

/**
 * @brief Participant statistics. The pcParm must be the user's URI of participant.
 */
#define MTC_CONF_STS_PARTICIPANT "MtcConfStsParticipant"
/** @} */

/**
 * @brief Get statistics.
 *
 * @param [in] iConfId The ID of conference.
 * @param [in] pcName  The statistics name. @ref MtcConfStatistics.
 * @param [in] pcParm  The statistics parameter. @ref MtcConfStatistics for detail.
 *
 * @return         Statistics string.
 *                 ZNULL indicates failed.
 */
MTCFUNC ZCONST ZCHAR * Mtc_ConfGetStatistics(ZUINT iConfId,
    ZCONST ZCHAR *pcName, ZCONST ZCHAR *pcParm);

/**
 * @defgroup MtcConfTest MTC conference test type.
 * @{
 */
/** 
 * @brief Testing the microphone record
 * Get real-time volume recorded by Mtc_ConfDspGetMicLevel().
 */
#define MTC_CONF_TEST_MIC       0x01
/** 
 * @brief By playing an audio file, test the speakers
 * Gets the speaker volume by Mtc_ConfDspGetSpkLevel()
 */
#define MTC_CONF_TEST_SPK       0x02
/** @} */

/**
 * @brief Start test microphone or camera deivce for conference
 *
 * @param [in] iTestType The test type @ref MtcConfTest.
 * @param [in] pcFilename The test file name.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfTestStart(ZUINT iTestType, ZCONST ZCHAR* pcFilename);

/**
 * @brief Stop  microphone or camera deivce test for conference
 *
 * @param [in] iTestType The test type @ref MtcConfTest.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfTestStop(ZUINT iTestType);

/**
 * @brief Get the current speaker volume level
 * Only the current existence of audio playback, @ref MTC_CONF_TEST_SPK,
 * or when meeting someone speak, will have to play the volume level
 * 
 * @return Playback volume range 0-100
 */
MTCFUNC ZINT Mtc_ConfDspGetSpkLevel();

/**
 * @brief Get the current local recording volume level, range 0-100
 * Only Mic test currently exists, @ref MTC_CONF_TEST_MIC
 * or when a meeting on the audio, will have a volume level recorded
 *
 * @return Record volume range 0-100
 */
MTCFUNC ZINT Mtc_ConfDspGetMicLevel();

/** 
 * @brief MTC session get the mute status of speaker.
 *
 * @param [in] iConfId The ID of session which you want to get.
 *
 * @retval ZTRUE on muted.
 * @retval ZFALSE on not muted.
 *
 * @see @ref Mtc_ConfSetSpkMute
 */
MTCFUNC ZBOOL Mtc_ConfGetSpkMute(ZUINT iConfId);

/** 
 * @brief MTC session set the mute status of speaker.
 *
 * @param [in] iConfId The ID of session which you want to set.
 * @param [in] bMute Indicate whether to mute the speaker.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 *
 * @see @ref Mtc_ConfGetSpkMute
 */
MTCFUNC ZINT Mtc_ConfSetSpkMute(ZUINT iConfId, ZBOOL bMute);

/** 
 * @brief MTC session set the dsp status.
 *
 * @param [in] bEnable Indicate whether to enable the dsp.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfDspSetEnable(ZBOOL bEnable);

/** 
 * @brief MTC session set the dsp status.
 *
 * @param [in] bEnable Indicate whether to enable the dsp.
 *
 * @retval ZOK on succeed.
 * @retval ZFAILED on failure.
 */
MTCFUNC ZINT Mtc_ConfDspSetEnable(ZBOOL bEnable);

/* mtc layout item */
typedef struct tagMTC_CONF_LAYOUT_ITEM
{
    int id, x, y, w, h;
    const char* name;
} ST_MTC_CONF_LAYOUT_ITEM;

/** 
 * @brief Type define of MTC layout callback.
 * @param width is the width of canvas
 * @param height is the height of canvas.
 * @param item is the video in canvas
 * @param size is the number of item
 * @param sharerIndex is the index of sharer video at item 
 * @retval 1 will force 
 */
typedef ZINT (*PFN_MTCCONFLAYOUT)(ZINT width, ZINT height,
                         ST_MTC_CONF_LAYOUT_ITEM item[], ZINT size, ZINT sharerIndex);

/**
 * @brief Set layout callback of media data received 
 *
 * @param pfnLayout The merge layout callback @ref PFN_MTCCONFLAYOUT
 *
 * @retval ZOK
 * @retval ZFAILED Fail to set callback.
 */
MTCFUNC ZINT Mtc_ConfSetLayout(PFN_MTCCONFLAYOUT pfnLayout);

/**
 * @brief Change Display Name while in meeting
 * @param [in] iConfId The ID of session which you want to get.
 * @param [in] pcDisplayName Used to display name, must UTF-8 encoding.
 *
 * @retval ZOK
 * @retval ZFAILED Fail to change display name.
 */
MTCFUNC ZINT Mtc_ConfChangeDisplayName(ZUINT iConfId, ZCONST ZCHAR *pcDisplayName);

#ifdef __cplusplus
}
#endif

#endif /* _MTC_CONF_H__ */

