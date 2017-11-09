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
  File name     : mtc_call_db.h
  Module        : multimedia talk client
  Author        : leo.lv
  Created on    : 2010-02-06
  Description   :
      Data structure and function declare required by mtc call database.

  Modify History:
  1. Date:        Author:         Modification:
*************************************************/
#ifndef _MTC_CALL_DB_H__
#define _MTC_CALL_DB_H__

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
 * @file mtc_call_db.h
 * @brief MTC Call Database Interface Functions
 */
#ifdef __cplusplus
extern "C" {
#endif

/** @brief MTC privacy flag */
#define MTC_PRIVACY_NONE     0x01    /**< @brief No privacy support. */
#define MTC_PRIVACY_ID       0x02    /**< @brief Using privacy id. */
#define MTC_PRIVACY_HEADER   0x03    /**< @brief Using privacy header. */
#define MTC_PRIVACY_SESSION  0x04    /**< @brief Using privacy session. */
#define MTC_PRIVACY_CRITICAL 0x05    /**< @brief Using privacy critical. */

/** @brief MTC database encoding type */
typedef enum EN_MTC_DB_ENCODING_TYPE
{
    EN_MTC_ENCODING_H264,            /**< @brief H.264. */
    EN_MTC_ENCODING_VP8,             /**< @brief VP8. */
} EN_MTC_DB_ENCODING_TYPE;

/** @brief MTC database ARS type */
typedef enum EN_MTC_DB_ARS_TYPE
{
    EN_MTC_DB_ARS_LD,                /**< @brief Low Difinition. */
    EN_MTC_DB_ARS_SD,                /**< @brief Standard Difinition. */
    EN_MTC_DB_ARS_HD                 /**< @brief High Difinition. */
} EN_MTC_DB_ARS_TYPE;

/** @brief MTC database net type */
typedef enum EN_MTC_DB_NET_TYPE
{
    EN_MTC_DB_NET_3G,                /**< @brief 3G. */
    EN_MTC_DB_NET_LAN,               /**< @brief LAN. */
    EN_MTC_DB_NET_WIFI               /**< @brief WIFI. */
} EN_MTC_DB_NET_TYPE;

/** @brief MTC database SRTP crypto type */
typedef enum EN_MTC_DB_SRTP_CRYPTO_TYPE
{
    EN_MTC_DB_SRTP_CRYPTO_OFF,       /**< @brief SRTP off */
    EN_MTC_DB_SRTP_CRYPTO_AES128_HMAC80, /**< @brief SRTP AES-128 HMAC-80. */
    EN_MTC_DB_SRTP_CRYPTO_AES128_HMAC32, /**< @brief SRTP AES-128 HMAC-32. */
} EN_MTC_DB_SRTP_CRYPTO_TYPE;
 
/** @brief Type of MTC echo cancellation. */
typedef enum EN_MTC_EC_TYPE
{
    EN_MTC_EC_AEC = 0,                /**< @brief Default AEC provided by engine. */    
    EN_MTC_EC_OS  = 1,                /**< @brief AEC provided by OS. */
    EN_MTC_EC_AES = 2,                /**< @brief AES provided by engine. */    
    EN_MTC_EC_AEC_FDE = 3,            /**< @brief AEC based on formant delay estimation. */ 
    EN_MTC_EC_AEC_SDE = 4,            /**< @brief AEC based on spectrum delay estimation. */ 
} EN_MTC_EC_TYPE;

/** @brief Type of MTC noise suppression. */
typedef enum EN_MTC_NS_TYPE
{
    EN_MTC_NS_LOW  = 0,               /**< @brief NS with low level. */
    EN_MTC_NS_MID  = 1,               /**< @brief NS with moderate level. */
    EN_MTC_NS_HIGH = 2,               /**< @brief NS with high level. */
    EN_MTC_NS_VERYHIGH = 3,           /**< @brief NS with very high level. */
} EN_MTC_NS_TYPE;

/** @brief Type of MTC gain control. */
typedef enum EN_MTC_GC_TYPE
{
    EN_MTC_GC_ANALOG  = 0,           /**< @brief AGC based on analog volume adjustment. */
    EN_MTC_GC_OS      = 1,           /**< @brief AGC provided by OS. */
    EN_MTC_GC_DIGITAL = 2,           /**< @brief AGC based on digital volume adjustment. */
} EN_MTC_GC_TYPE;

/** @brief Type of MTC receiving-side gain control. */
typedef enum EN_MTC_RX_GC_TYPE
{
    EN_MTC_RX_GC_FIXED     = 0,       /**< @brief RX-AGC based on fixed digital volume adjustment. */
    EN_MTC_RX_GC_ADAPTIVE  = 1,       /**< @brief RX-AGC based on adaptive digital volume adjustment. */
} EN_MTC_RX_GC_TYPE;

/** @brief Type of MTC video quality mode. */
typedef enum EN_MTC_ARS_TYPE
{
    EN_MTC_ARS_QUALITY_SPATIAL   = 0, /**< @brief Spatial quality first: clear picture. */
    EN_MTC_ARS_QUALITY_TEMPORAL  = 1, /**< @brief Temporal quality first: fluent motion. */
} EN_MTC_ARS_TYPE;

/** @brief Type of MTC voice activity detection. */
typedef enum EN_MTC_VAD_TYPE
{
    EN_MTC_VAD_NORMAL  = 0,           /**< @brief VAD with lowest level. */
    EN_MTC_VAD_LOW     = 1,           /**< @brief VAD with low level. */
    EN_MTC_VAD_MID     = 2,           /**< @brief VAD with moderate level. */
    EN_MTC_VAD_HIGH    = 3,           /**< @brief VAD with high level. */
} EN_MTC_VAD_TYPE;

/** @brief Type of MTC auto accept call. */
typedef enum EN_MTC_AAC_TYPE
{
    EN_MTC_AAC_DISABLE  = 0,         /**< @brief Do not auto accept. */
    EN_MTC_AAC_VOICE    = 1,         /**< @brief Auto accept with voice only. */
    EN_MTC_AAC_VIDEO    = 2          /**< @brief Auto accept with voice and video. */
} EN_MTC_AAC_TYPE;

#define DTMF_SETTINGS

/**
 * @brief Get the DTMF message payload.
 *
 * @return The DTMF message payload.
 *
 * @see @ref Mtc_CallDbSetDtmfPayload
 */
MTCFUNC ZUINT Mtc_CallDbGetDtmfPayload(ZFUNC_VOID);

/**
 * @brief Set the DTMF message payload.
 *
 * @param [in] iPayload The DTMF message payload.
 *
 * @retval ZOK Set the DTMF message payload successfully.
 * @retval ZFAILED Set the DTMF message payload failed.
 *
 * @see @ref Mtc_CallDbGetDtmfPayload
 */
MTCFUNC ZINT Mtc_CallDbSetDtmfPayload(ZUINT iPayload);

/**
 * @brief Get the watch DTMF flag.
 *
 * @retval ZTRUE It will notify watcher when receive DTMF.
 * @retval ZFALSE Don't notify.
 *
 * @see @ref Mtc_CallDbSetDtmfWatch
 */
MTCFUNC ZBOOL Mtc_CallDbGetDtmfWatch(ZFUNC_VOID);

/**
 * @brief Set the watch DTMF flag.
 *
 * @param [in] bWatch If ZTRUE, it will notify watcher when receive DTMF.
 *                    ZFALSE, Don't notify.
 *
 * @retval ZOK Set watch DTMF flag successfully.
 * @retval ZFAILED Set watch DTMF flag failed.
 *
 * @see @ref Mtc_CallDbGetDtmfWatch
 */
MTCFUNC ZINT Mtc_CallDbSetDtmfWatch(ZBOOL bWatch);

#define AUDIO_QOS_SETTINGS

/**
 * @brief Set state of ARS.
 *
 * @param [in] bEnable ZTRUE to enable ARS, ZFALSE to disable ARS.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetArsEnable
 */
MTCFUNC ZINT Mtc_CallDbSetArsEnable(ZBOOL bEnable);

/**
 * @brief Get state of ARS.
 *
 * @retval ZTRUE indicate ARS is enabled.
 * @retval ZFALSE indicate ARS is disabled.
 *
 * @see Mtc_CallDbSetArsEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetArsEnable(ZFUNC_VOID);

/**
 * @brief Get audio QOS.
 *
 * @param [out] pbAec Audio echo cancel option.
 * @param [out] pbAnr Audio noise reduction.
 * @param [out] pbAgc Audio gain control option.
 * @param [out] pbVad Audio silence detection.
 *
 * @retval ZOK Get audio QOS successfully.
 * @retval ZFAILED Get audio QOS failed.
 *
 * @see @ref Mtc_CallDbSetAudioQos
 */
MTCFUNC ZINT Mtc_CallDbGetAudioQos(ZBOOL *pbAec, ZBOOL *pbAnr, 
                ZBOOL *pbAgc, ZBOOL *pbVad);

/**
 * @brief Set audio QOS.
 *
 * @param [in] bAec Audio echo cancel option.
 * @param [in] bAnr Audio noise reduction.
 * @param [in] bAgc Audio gain control option.
 * @param [in] bVad Audio silence detection.
 *
 * @retval ZOK Set audio QOS successfully.
 * @retval ZFAILED Set audio QOS failed.
 *
 * @see @ref Mtc_CallDbGetAudioQos
 */
MTCFUNC ZINT Mtc_CallDbSetAudioQos(ZBOOL bAec, ZBOOL bAnr,
                ZBOOL bAgc, ZBOOL bVad);

/**
 * @brief Set state of AEC.
 *
 * @param [in] bEnable ZTRUE to enable AEC, ZFALSE to disable AEC.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetAecEnable
 */
MTCFUNC ZINT Mtc_CallDbSetAecEnable(ZBOOL bEnable);

/**
 * @brief Get state of AEC.
 *
 * @retval ZTRUE indicate AEC is enabled.
 * @retval ZFALSE indicate AEC is disabled.
 *
 * @see Mtc_CallDbSetAecEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetAecEnable(ZFUNC_VOID);

/**
 * @brief Set mode of AEC.
 *
 * @param [in] ucMode Mode of AEC, @ref EN_MTC_EC_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetAecMode
 */
MTCFUNC ZINT Mtc_CallDbSetAecMode(ZUCHAR ucMode);

/**
 * @brief Get mode of AEC.
 *
 * @return Current AEC mode, @ref EN_MTC_EC_TYPE.
 *
 * @see Mtc_CallDbSetAecMode
 */
MTCFUNC ZUCHAR Mtc_CallDbGetAecMode(ZFUNC_VOID);

/**
 * @brief Set state of VAD.
 *
 * @param [in] bEnable ZTRUE to enable VAD, ZFALSE to disable VAD.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetVadEnable
 */
MTCFUNC ZINT Mtc_CallDbSetVadEnable(ZBOOL bEnable);

/**
 * @brief Get state of VAD.
 *
 * @retval ZTRUE indicate VAD is enabled.
 * @retval ZFALSE indicate VAD is disabled.
 *
 * @see Mtc_CallDbSetVadEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetVadEnable(ZFUNC_VOID);

/**
 * @brief Set mode of VAD.
 *
 * @param [in] ucMode Mode of VAD, @ref EN_MTC_VAD_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetVadMode
 */
MTCFUNC ZINT Mtc_CallDbSetVadMode(ZUCHAR ucMode);

/**
 * @brief Get mode of VAD.
 *
 * @return Current VAD mode, @ref EN_MTC_VAD_TYPE.
 *
 * @see Mtc_CallDbSetVadMode
 */
MTCFUNC ZUCHAR Mtc_CallDbGetVadMode(ZFUNC_VOID);

/**
 * @brief Set state of AGC.
 *
 * @param [in] bEnable ZTRUE to enable AGC, ZFALSE to disable AGC.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetAgcEnable
 */
MTCFUNC ZINT Mtc_CallDbSetAgcEnable(ZBOOL bEnable);

/**
 * @brief Get state of AGC.
 *
 * @retval ZTRUE indicate AGC is enabled.
 * @retval ZFALSE indicate AGC is disabled.
 *
 * @see Mtc_CallDbSetAgcEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetAgcEnable(ZFUNC_VOID);

/**
 * @brief Set mode of AGC.
 *
 * @param [in] ucMode Mode of AGC, @ref EN_MTC_GC_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetAgcMode
 */
MTCFUNC ZINT Mtc_CallDbSetAgcMode(ZUCHAR ucMode);

/**
 * @brief Get mode of AGC.
 *
 * @return Current AGC mode, @ref EN_MTC_GC_TYPE.
 *
 * @see Mtc_CallDbSetAgcMode
 */
MTCFUNC ZUCHAR Mtc_CallDbGetAgcMode(ZFUNC_VOID);

/**
 * @brief Set target dBOV of AGC.
 *
 * @param [in] ucTargetDb Target dBOV of AGC, should be 0 - 30.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetAgcTarget
 */
MTCFUNC ZINT Mtc_CallDbSetAgcTarget(ZUCHAR ucTargetDb);

/**
 * @brief Get target dBOV of AGC.
 *
 * @return Current target dBOV of AGC.
 *
 * @see Mtc_CallDbSetAgcTarget
 */
MTCFUNC ZUCHAR Mtc_CallDbGetAgcTarget(ZFUNC_VOID);

/**
 * @brief Set state of RxAGC.
 *
 * @param [in] bEnable ZTRUE to enable RxAGC, ZFALSE to disable RxAGC.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetRxAgcEnable
 */
MTCFUNC ZINT Mtc_CallDbSetRxAgcEnable(ZBOOL bEnable);

/**
 * @brief Get state of RxAGC.
 *
 * @retval ZTRUE indicate RxAGC is enabled.
 * @retval ZFALSE indicate RxAGC is disabled.
 *
 * @see Mtc_CallDbSetRxAgcEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetRxAgcEnable(ZFUNC_VOID);

/**
 * @brief Set mode of RxAGC.
 *
 * @param [in] ucMode Mode of RxAGC, @ref EN_MTC_RX_GC_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetRxAgcMode
 */
MTCFUNC ZINT Mtc_CallDbSetRxAgcMode(ZUCHAR ucMode);

/**
 * @brief Get mode of RxAGC.
 *
 * @return Current RxAGC mode, @ref EN_MTC_RX_GC_TYPE.
 *
 * @see Mtc_CallDbSetRxAgcMode
 */
MTCFUNC ZUCHAR Mtc_CallDbGetRxAgcMode(ZFUNC_VOID);

/**
 * @brief Set target dBOV of RxAGC.
 *
 * @param [in] ucTargetDb Target dBOV of RxAGC, should be 0 - 30.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetRxAgcTarget
 */
MTCFUNC ZINT Mtc_CallDbSetRxAgcTarget(ZUCHAR ucTargetDb);

/**
 * @brief Get target dBOV of RxAGC.
 *
 * @return Current target dBOV of RxAGC.
 *
 * @see Mtc_CallDbSetRxAgcTarget
 */
MTCFUNC ZUCHAR Mtc_CallDbGetRxAgcTarget(ZFUNC_VOID);

/**
 * @brief Set state of ANR.
 *
 * @param [in] bEnable ZTRUE to enable ANR, ZFALSE to disable ANR.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetAnrEnable
 */
MTCFUNC ZINT Mtc_CallDbSetAnrEnable(ZBOOL bEnable);

/**
 * @brief Get state of ANR.
 *
 * @retval ZTRUE indicate ANR is enabled.
 * @retval ZFALSE indicate ANR is disabled.
 *
 * @see Mtc_CallDbSetAnrEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetAnrEnable(ZFUNC_VOID);

/**
 * @brief Set mode of ANR.
 *
 * @param [in] ucMode Mode of ANR, @ref EN_MTC_NS_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetAnrMode
 */
MTCFUNC ZINT Mtc_CallDbSetAnrMode(ZUCHAR ucMode);

/**
 * @brief Get mode of ANR.
 *
 * @return Current mode of ANR, @ref EN_MTC_NS_TYPE.
 *
 * @see Mtc_CallDbSetAnrMode
 */
MTCFUNC ZUCHAR Mtc_CallDbGetAnrMode(ZFUNC_VOID);

/**
 * @brief Set state of RxANR.
 *
 * @param [in] bEnable ZTRUE to enable RxANR, ZFALSE to disable RxANR.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetRxAnrEnable
 */
MTCFUNC ZINT Mtc_CallDbSetRxAnrEnable(ZBOOL bEnable);

/**
 * @brief Get state of RxANR.
 *
 * @retval ZTRUE indicate RxANR is enabled.
 * @retval ZFALSE indicate RxANR is disabled.
 *
 * @see Mtc_CallDbSetRxAnrEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetRxAnrEnable(ZFUNC_VOID);

/**
 * @brief Set mode of RxANR.
 *
 * @param [in] ucMode Mode of RxANR, @ref EN_MTC_NS_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetRxAnrMode
 */
MTCFUNC ZINT Mtc_CallDbSetRxAnrMode(ZUCHAR ucMode);

/**
 * @brief Get mode of RxANR.
 *
 * @return Current mode of RxANR, @ref EN_MTC_NS_TYPE.
 *
 * @see Mtc_CallDbSetRxAnrMode
 */
MTCFUNC ZUCHAR Mtc_CallDbGetRxAnrMode(ZFUNC_VOID);

/**
 * @brief Set state of audio redundant.
 *
 * @param [in] bEnable ZTRUE to enable audio redundant, ZFALSE to disable audio redundant.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetAudioRed
 */
MTCFUNC ZINT Mtc_CallDbSetAudioRed(ZBOOL bEnable);

/**
 * @brief Get state of audio redundant.
 *
 * @retval ZTRUE indicate audio redundant is enabled.
 * @retval ZFALSE indicate audio redundant is disabled.
 *
 * @see Mtc_CallDbSetAudioRed
 */
MTCFUNC ZBOOL Mtc_CallDbGetAudioRed(ZFUNC_VOID);

#define AUDIO_CODEC_SETTINGS

/**
 * @brief Get supporting audio codec count
 *
 * @return The count of audio codec supported.
 */
MTCFUNC ZUINT Mtc_CallDbGetSuptAudioCodecCount(ZFUNC_VOID);

/**
 * @brief Get supporting audio codec from database.
 *
 * @param [in] iIndex Codec index from 0 to (count - 1). Count get by
                       @ref Mtc_CallDbGetSuptAudioCodecCount.
 *
 * @return The string of Codec name successfully or empty string failed.
 *
 * @see @ref Mtc_CallDbGetSuptAudioCodecCount
 */
MTCFUNC ZCONST ZCHAR * Mtc_CallDbGetSuptAudioCodec(ZUINT iIndex);

/**
 * @brief Get used audio codec count
 *
 * @return The count of audio codec supported.
 */
MTCFUNC ZUINT Mtc_CallDbGetAudioCodecCount(ZFUNC_VOID);

/**
 * @brief Get audio codec from database.
 *
 * @param [in] ucPriority Codec priority.
 *
 * @return The string of Codec name successfully or empty string failed.
 *
 * @see @ref Mtc_CallDbSetAudioCodecByPriority
 */
MTCFUNC ZCONST ZCHAR * Mtc_CallDbGetAudioCodecByPriority(ZUCHAR ucPriority);

/**
 * @brief Set the audio codec enable or disable.
 *
 * @param [in] pcCodec Codec name.
 * @param [in] bEnable ZTRUE for enable, other for disable.
 *
 * @retval ZOK Set the audio codec enable or disable successfully.
 * @retval ZFAILED Set the audio codec enable or disable failed.
 *
 * @see
 */
MTCFUNC ZINT Mtc_CallDbSetAudioCodecEnable(ZCHAR *pcCodec,
                ZBOOL bEnable);

/**
 * @brief Set the audio codec priority.
 *
 * @param [in] pcName Codec name.
 * @param [in] ucPriority Codec priority.
 *
 * @retval ZOK Set the audio codec priority successfully.
 * @retval ZFAILED Set the audio codec priority failed.
 *
 * @see @ref Mtc_CallDbGetAudioCodecByPriority
 */
MTCFUNC ZINT Mtc_CallDbSetAudioCodecByPriority(ZCHAR *pcName,
                ZUCHAR ucPriority);

#define AUDIO_VOLUME_SETTINGS

/**
 * @brief Get default volume value for speaker.
 *
 * @return Default volume value for speaker, from 0-20.
 */
MTCFUNC ZUINT Mtc_CallDbGetSpkDftVol(ZFUNC_VOID);

/**
 * @brief Set default volume value for speaker.
 *
 * @param [in] iVol Default volume value for speaker, from 0-20.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 */
MTCFUNC ZINT Mtc_CallDbSetSpkDftVol(ZUINT iVol);

#define VIDEO_CODEC_SETTINGS

/**
 * @brief Get supporting video codec count
 *
 * @return The count of video codec supported.
 */
MTCFUNC ZUINT Mtc_CallDbGetSuptVideoCodecCount(ZFUNC_VOID);

/**
 * @brief Get supporting video codec from database.
 *
 * @param [in] iIndex Codec index from 0 to (count - 1). Count get by
                       @ref Mtc_CallDbGetSuptVideoCodecCount.
 *
 * @return The string of Codec name successfully or empty string failed.
 *
 * @see @ref Mtc_CallDbGetSuptVideoCodecCount
 */
MTCFUNC ZCONST ZCHAR * Mtc_CallDbGetSuptVideoCodec(ZUINT iIndex);

/**
 * @brief Get video codec count.
 *
 * @return Video used codec count.
 */
MTCFUNC ZUINT Mtc_CallDbGetVideoCodecCount(ZFUNC_VOID);

/**
 * @brief Get video codec from database.
 *
 * @param [in] ucPriority Codec priority.
 *
 * @return The string of Codec name successfully or empty string failed.
 *
 * @see @ref Mtc_CallDbSetVideoCodecByPriority
 */
MTCFUNC ZCONST ZCHAR * Mtc_CallDbGetVideoCodecByPriority(ZUCHAR ucPriority);

/**
 * @brief Set the video codec enable or disable.
 *
 * @param [in] pcCodec Codec name.
 * @param [in] bEnable ZTRUE for enable, other for disable.
 *
 * @retval ZOK Set the video codec enable or disable successfully.
 * @retval ZFAILED Set the video codec enable or disable failed.
 *
 * @see
 */
MTCFUNC ZINT Mtc_CallDbSetVideoCodecEnable(ZCHAR *pcCodec,
                ZBOOL bEnable);

/**
 * @brief Set the video codec priority.
 *
 * @param [in] pcCodec Codec name.
 * @param [in] ucPriority Codec priority.
 *
 * @retval ZOK Set the video codec priority successfully.
 * @retval ZFAILED Set the video codec priority failed.
 *
 * @see @ref Mtc_CallDbGetVideoCodecByPriority
 */
MTCFUNC ZINT Mtc_CallDbSetVideoCodecByPriority(ZCHAR *pcCodec,
                ZUCHAR ucPriority);

#define VIDEO_PARAMETER_SETTINGS

/**
 * @brief Get video bitrate.
 *
 * @retval Video bitrate parameter in bps.
 *
 * @see @ref Mtc_CallDbSetVideoBitrate
 */
MTCFUNC ZUINT Mtc_CallDbGetVideoBitrate();

/**
 * @brief Set video bitrate.
 *
 * @param [in] iBitRate Video bitrate parameter in bps.
 *
 * @retval ZOK Set the video bitrate successfully.
 * @retval ZFAILED Set the video bitrate failed.
 *
 * @see @ref Mtc_CallDbGetVideoBitrate
 */
MTCFUNC ZINT Mtc_CallDbSetVideoBitrate(ZUINT iBitRate);

/**
 * @brief Get video frame rate.
 *
 * @retval Video frame rate parameter in fps.
 *
 * @see @ref Mtc_CallDbSetVideoFramerate
 */
MTCFUNC ZUINT Mtc_CallDbGetVideoFramerate();

/**
 * @brief Set video frame rate.
 *
 * @param [in] iFrameRate Video frame rate parameter in fps.
 *
 * @retval ZOK Set the video frame rate successfully.
 * @retval ZFAILED Set the video frame rate failed.
 *
 * @see @ref Mtc_CallDbGetVideoFramerate
 */
MTCFUNC ZINT Mtc_CallDbSetVideoFramerate(ZUINT iFrameRate);

/**
 * @brief Get video resolution.
 *
 * @param [out] piWidth Pixel value in horizontal direction.
 * @param [out] piHeight Pixel value in vertical direction.
 *
 * @retval ZOK Get the video resolution successfully.
 * @retval ZFAILED Get the video resolution failed.
 *
 * @see @ref Mtc_CallDbSetVideoResolution
 */
MTCFUNC ZINT Mtc_CallDbGetVideoResolution(ZUINT *piWidth, ZUINT *piHeight);

/**
 * @brief Set video resolution.
 *
 * @param [in] iWidth Pixel value in horizontal direction.
 * @param [in] iHeight Pixel value in vertical direction.
 *
 * @retval ZOK Set the video resolution successfully.
 * @retval ZFAILED Set the video resolution failed.
 *
 * @see @ref Mtc_CallDbGetVideoResolution
 */
MTCFUNC ZINT Mtc_CallDbSetVideoResolution(ZUINT iWidth, ZUINT iHeight);

/**
 * @brief Get video resolution.
 *
 * @return The string of video resolution name or "UNKNOWN" failed.
 *
 * @see @ref Mtc_CallDbSetVideoResolutionX
 */
MTCFUNC ZCONST ZCHAR * Mtc_CallDbGetVideoResolutionX();

/**
 * @brief Set video resolution.
 *
 * @param [in] pcName Video resolution name string.
 *
 * @retval ZOK Set the video resolution successfully.
 * @retval ZFAILED Set the video resolution failed.
 *
 * @see @ref Mtc_CallDbGetVideoResolutionX
 */
MTCFUNC ZINT Mtc_CallDbSetVideoResolutionX(ZCHAR *pcName);

#define VIDEO_QOS_SETTINGS

/**
 * @brief Get media device manager option.
 *
 * @retval ZTRUE Enable media device manager.
 * @retval ZFALSE Disable media device manager.
 *
 * @see @ref Mtc_CallDbSetMdmEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetMdmEnable(ZFUNC_VOID);

/**
 * @brief Set media device manager option.
 *
 * @param [in] bEnable ZTRUE to enable media device manager, otherwise to disable.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetMdmEnable
 */
MTCFUNC ZINT Mtc_CallDbSetMdmEnable(ZBOOL bEnable);

/**
 * @brief Get resolution control of video stream.
 *
 * @retval ZTRUE Resolution control is enabled for video stream.
 * @retval ZFALSE Resolution control is disabled for video stream.
 *
 * @see @ref Mtc_CallDbSetResolutionControl
 */
MTCFUNC ZBOOL Mtc_CallDbGetResolutionControl(ZFUNC_VOID);

/**
 * @brief Set resolution control of video stream.
 *
 * @param [in] bEnable ZTRUE to enable resolution control, otherwise to disable.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetResolutionControl
 */
MTCFUNC ZINT Mtc_CallDbSetResolutionControl(ZBOOL bEnable);

/**
 * @brief Get framerate control of video stream.
 *
 * @retval ZTRUE Framerate control is enabled for video stream.
 * @retval ZFALSE Framerate control is disabled for video stream.
 *
 * @see @ref Mtc_CallDbSetFramerateControl
 */
MTCFUNC ZBOOL Mtc_CallDbGetFramerateControl(ZFUNC_VOID);

/**
 * @brief Set framerate control of video stream.
 *
 * @param [in] bEnable ZTRUE to enable framerate control, otherwise to disable.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetFramerateControl
 */
MTCFUNC ZINT Mtc_CallDbSetFramerateControl(ZBOOL bEnable);

/**
 * @brief Get CPU load control of video stream.
 *
 * @retval ZTRUE CPU load control is enabled for video stream.
 * @retval ZFALSE CPU load control is disabled for video stream.
 *
 * @see @ref Mtc_CallDbSetCpuLoadControl
 */
MTCFUNC ZBOOL Mtc_CallDbGetCpuLoadControl(ZFUNC_VOID);

/**
 * @brief Set CPU load control of video stream.
 *
 * @param [in] bEnable ZTRUE to enable CPU load control, otherwise to disable.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetCpuLoadControl
 */
MTCFUNC ZINT Mtc_CallDbSetCpuLoadControl(ZBOOL bEnable);

/**
 * @brief Get CPU load control of video stream.
 *
 * @return CPU load control target, from 0 to 100.
 *
 * @see @ref Mtc_CallDbSetCpuLoadTarget
 */
MTCFUNC ZUINT Mtc_CallDbGetCpuLoadTarget(ZFUNC_VOID);

/**
 * @brief Set CPU load control of video stream.
 *
 * @param [in] iTarget CPU load control target, from 0 to 100.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetCpuLoadTarget
 */
MTCFUNC ZINT Mtc_CallDbSetCpuLoadTarget(ZUINT iTarget);

/**
 * @brief Get FIR of video stream.
 *
 * @retval ZTRUE FIR is enabled for video stream.
 * @retval ZFALSE FIR is disabled for video stream.
 *
 * @see @ref Mtc_CallDbSetFir
 */
MTCFUNC ZBOOL Mtc_CallDbGetFir(ZFUNC_VOID);

/**
 * @brief Set FIR of video stream.
 *
 * @param [in] bEnable ZTRUE to enable FIR, otherwise to disable.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetFir
 */
MTCFUNC ZINT Mtc_CallDbSetFir(ZBOOL bEnable);

/**
 * @brief Get FIR using INFO method of video stream.
 *
 * @retval ZTRUE FIR using INFO method is enabled for video stream.
 * @retval ZFALSE FIR using INFO method is disabled for video stream.
 *
 * @see @ref Mtc_CallDbSetFirByInfo
 */
MTCFUNC ZBOOL Mtc_CallDbGetFirByInfo(ZFUNC_VOID);

/**
 * @brief Set FIR using INFO method of video stream.
 *
 * @param [in] bEnable ZTRUE to enable FIR by INFO method, otherwise to disable.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetFirByInfo
 */
MTCFUNC ZINT Mtc_CallDbSetFirByInfo(ZBOOL bEnable);

/**
 * @brief Get key frame period of video stream.
 *
 * @return Key frame period in milliseconds for video stream.
 *
 * @see @ref Mtc_CallDbSetFramerateControl
 */
MTCFUNC ZUINT Mtc_CallDbGetKeyPeriod(ZFUNC_VOID);

/**
 * @brief Set framerate control of video stream.
 *
 * @param [in] iTimeLen Key frame period in milliseconds.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetKeyPeriod
 */
MTCFUNC ZINT Mtc_CallDbSetKeyPeriod(ZUINT iTimeLen);

/**
 * @brief Get bandwidth efficiency mode of video stream.
 *
 * @retval ZTRUE BEM is enabled for video stream.
 * @retval ZFALSE BEM is disabled for video stream.
 *
 * @see @ref Mtc_CallDbSetVideoBem
 */
MTCFUNC ZBOOL Mtc_CallDbGetVideoBem(ZFUNC_VOID);

/**
 * @brief Set bandwidth efficiency mode of video stream.
 *
 * @param [in] bEnable ZTRUE to enable BEM, otherwise to disable BEM.
 *
 * @retval ZOK Set the video BEM option successfully.
 * @retval ZFAILED Set the video BEM option failed.
 *
 * @see @ref Mtc_CallDbGetVideoBem
 */
MTCFUNC ZINT Mtc_CallDbSetVideoBem(ZBOOL bEnable);

/**
 * @brief Get bandwidth for video stream.
 * 
 * @param  [out] piDownBps Downstream bandwidth in bps.
 * @param  [out] piUpBps   Upstream bandwidth in bps.
 * 
 * @retval ZOK Set the video bandwidth option successfully.
 * @retval ZFAILED Set the video bandwidth option failed.
 */
MTCFUNC ZINT Mtc_CallDbGetVideoBandwidth(ZUINT *piDownBps, ZUINT *piUpBps);

/**
 * @brief Set bandwidth for video stream.
 *
 * @param  [in] iDownBps Downstream bandwidth in bps.
 * @param  [in] iUpBps   Upstream bandwidth in bps.
 *
 * @retval ZOK Set the video bandwidth option successfully.
 * @retval ZFAILED Set the video bandwidth option failed.
 */
MTCFUNC ZINT Mtc_CallDbSetVideoBandwidth(ZUINT iDownBps, ZUINT iUpBps);

/**
 * @brief Get coordination of video orientation is enabled or not for send.
 *
 * @retval ZTRUE Coordination of video orientation is enabled for send.
 * @retval ZFALSE Coordination of video orientation is disabled for send.
 *
 * @see @ref Mtc_CallDbSetVideoOrientSend
 */
MTCFUNC ZBOOL Mtc_CallDbGetVideoOrientSend(ZFUNC_VOID);

/**
 * @brief Set coordination of video orientation is enabled or not for send.
 *
 * @param [in] bEnable ZTRUE enable coordination of video orientation for send.
 *
 * @retval ZOK Set option successfully.
 * @retval ZFAILED Set option failed.
 *
 * @see @ref Mtc_CallDbGetVideoOrientSend
 */
MTCFUNC ZINT Mtc_CallDbSetVideoOrientSend(ZBOOL bEnable);

/**
 * @brief Get coordination of video orientation is enabled or not for receive.
 *
 * @retval ZTRUE Coordination of video orientation is enabled for receive.
 * @retval ZFALSE Coordination of video orientation is disabled for receive.
 *
 * @see @ref Mtc_CallDbSetVideoOrientRecv
 */
MTCFUNC ZBOOL Mtc_CallDbGetVideoOrientRecv(ZFUNC_VOID);

/**
 * @brief Set coordination of video orientation is enabled or not for receive.
 *
 * @param [in] bEnable ZTRUE enable coordination of video orientation for receive.
 *
 * @retval ZOK Set option successfully.
 * @retval ZFAILED Set option failed.
 *
 * @see @ref Mtc_CallDbGetVideoOrientRecv
 */
MTCFUNC ZINT Mtc_CallDbSetVideoOrientRecv(ZBOOL bEnable);

/**
 * @brief Get RTP extension ID for coordination of video orientation.
 *
 * @return RTP extension ID.
 *
 * @see @ref Mtc_CallDbSetVideoOrientId
 */
MTCFUNC ZUINT Mtc_CallDbGetVideoOrientId(ZFUNC_VOID);

/**
 * @brief Set RTP extension ID for coordination of video orientation.
 *
 * @param [in] iId RTP extension ID.
 *
 * @retval ZOK Set option successfully.
 * @retval ZFAILED Set option failed.
 *
 * @see @ref Mtc_CallDbGetVideoOrientId
 */
MTCFUNC ZINT Mtc_CallDbSetVideoOrientId(ZUINT iId);

/**
 * @brief Get Picture ID is enabled or not for send.
 *
 * @retval ZTRUE Picture ID is enabled for send.
 * @retval ZFALSE Picture ID is disabled for send.
 *
 * @see @ref Mtc_CallDbSetPictureIdSend
 */
MTCFUNC ZBOOL Mtc_CallDbGetPictureIdSend(ZFUNC_VOID);

/**
 * @brief Set Picture ID is enabled or not for send.
 *
 * @param [in] bEnable ZTRUE enable Picture ID for send.
 *
 * @retval ZOK Set option successfully.
 * @retval ZFAILED Set option failed.
 *
 * @see @ref Mtc_CallDbGetPictureIdSend
 */
MTCFUNC ZINT Mtc_CallDbSetPictureIdSend(ZBOOL bEnable);

/**
 * @brief Get Picture ID is enabled or not for receive.
 *
 * @retval ZTRUE Picture ID is enabled for receive.
 * @retval ZFALSE Picture ID is disabled for receive.
 *
 * @see @ref Mtc_CallDbSetPictureIdRecv
 */
MTCFUNC ZBOOL Mtc_CallDbGetPictureIdRecv(ZFUNC_VOID);

/**
 * @brief Set Picture ID is enabled or not for receive.
 *
 * @param [in] bEnable ZTRUE enable Picture ID for receive.
 *
 * @retval ZOK Set option successfully.
 * @retval ZFAILED Set option failed.
 *
 * @see @ref Mtc_CallDbGetPictureIdRecv
 */
MTCFUNC ZINT Mtc_CallDbSetPictureIdRecv(ZBOOL bEnable);

/**
 * @brief Get RTP extension ID for Picture ID.
 *
 * @return RTP extension ID.
 *
 * @see @ref Mtc_CallDbSetPictureIdId
 */
MTCFUNC ZUINT Mtc_CallDbGetPictureIdId(ZFUNC_VOID);

/**
 * @brief Set RTP extension ID for Picture ID.
 *
 * @param [in] iId RTP extension ID.
 *
 * @retval ZOK Set option successfully.
 * @retval ZFAILED Set option failed.
 *
 * @see @ref Mtc_CallDbGetPictureIdId
 */
MTCFUNC ZINT Mtc_CallDbSetPictureIdId(ZUINT iId);

/**
 * @brief Get ARS option of video stream.
 *
 * @retval ZTRUE ARS is enabled for video stream.
 * @retval ZFALSE ARS is disabled for video stream.
 *
 * @see @ref Mtc_CallDbSetVideoArs
 */
MTCFUNC ZBOOL Mtc_CallDbGetVideoArs(ZFUNC_VOID);

/**
 * @brief Set ARS option of video stream.
 *
 * @param [in] bEnable ZTRUE to enable ARS, otherwise to disable ARS.
 *
 * @retval ZOK Set the video ARS option successfully.
 * @retval ZFAILED Set the video ARS option failed.
 *
 * @see @ref Mtc_CallDbGetVideoArs
 */
MTCFUNC ZINT Mtc_CallDbSetVideoArs(ZBOOL bEnable);

/**
 * @brief Get ARS fixed bitrate of video stream.
 *
 * @return ARS fixed bitrate in kbps
 *
 * @see @ref Mtc_CallDbSetVideoArsFixBitrate
 */
MTCFUNC ZUINT Mtc_CallDbGetVideoArsFixBitrate(ZFUNC_VOID);

/**
 * @brief Set ARS fixed bitrate of video stream.
 *
 * @param [in] iBitrate ARS fixed bitrate in kbps.
 *
 * @retval ZOK Set the video ARS option successfully.
 * @retval ZFAILED Set the video ARS option failed.
 *
 * @see @ref Mtc_CallDbGetVideoArsFixBitrate
 */
MTCFUNC ZINT Mtc_CallDbSetVideoArsFixBitrate(ZUINT iBitrate);

/**
 * @brief Set mode of ARS.
 *
 * @param [in] ucMode Mode of ARS, @ref EN_MTC_ARS_TYPE.
 *
 * @retval ZOK on successfully.
 * @retval ZFAILED on failed.
 *
 * @see Mtc_CallDbGetArsMode
 */
MTCFUNC ZINT Mtc_CallDbSetArsMode(ZUCHAR ucMode);

/**
 * @brief Get mode of ARS.
 *
 * @return Current ARS mode, @ref EN_MTC_ARS_TYPE.
 *
 * @see Mtc_CallDbSetArsMode
 */
MTCFUNC ZUCHAR Mtc_CallDbGetArsMode(ZFUNC_VOID);

/**
 * @brief Get ARS parameter from database.
 *
 * @param [out] piBrHi Highest bitrate.
 * @param [out] piBrLo Lowest bitrate.
 * @param [out] piFrHi Highest framerate.
 * @param [out] piFrLo Lowest framerate.

 * @retval ZOK Get successfully.
 * @retval ZFAILED Get failed.
 *
 * @see @ref Mtc_CallDbSetVideoArsParm
 */
MTCFUNC ZINT Mtc_CallDbGetVideoArsParm(ZUINT * piBrHi, ZUINT * piBrLo,
                ZUINT * piFrHi, ZUINT * piFrLo);

/**
 * @brief Set ARS parameter.
 *
 * @param [in] iBrHi Highest bitrate.
 * @param [in] iBrLo Lowest bitrate.
 * @param [in] iFrHi Highest framerate.
 * @param [in] iFrLo Lowest framerate.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetVideoArsParm
 */
MTCFUNC ZINT Mtc_CallDbSetVideoArsParm(ZUINT iBrHi, ZUINT iBrLo,
                ZUINT iFrHi, ZUINT iFrLo);

/**
 * @brief Set ARS parameter.
 *
 * @param [in] bNetWorkType the network type.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetVideoArsParm
 */
MTCFUNC ZINT Mtc_CallDbSetVideoArsParmX(ZBOOL bNetWorkType);

/**
 * @brief Set option of red/fec.
 *
 * @param [in] bEnable ZTRUE to enable red/fec, otherwise to disable red/fec.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see @ref Mtc_CallDbGetVideoRedFec
 */
MTCFUNC ZINT Mtc_CallDbSetVideoRedFec(ZBOOL bEnable);

/**
 * @brief Get option of red/fec.
 *
 * @retval ZTRUE ARS is enabled red/fec.
 * @retval ZFALSE ARS is disabled red/fec.
 *
 * @see @ref Mtc_CallDbSetVideoRedFec
 */
MTCFUNC ZBOOL Mtc_CallDbGetVideoRedFec();  

#define RTP_RTCP_SETTINGS

/**
 * @brief Get RTP port from database.
 *
 * @param [out] pwAMinPort RTP audio min port.
 * @param [out] pwAMaxPort RTP audio max port.
 * @param [out] pwVMinPort RTP video min port.
 * @param [out] pwVMaxPort RTP video max port.

 * @retval ZOK Get RTP port successfully.
 * @retval ZFAILED Get RTP port failed.
 *
 * @see @ref Mtc_CallDbSetRtpPort
 */
MTCFUNC ZINT Mtc_CallDbGetRtpPort(ZUSHORT *pwAMinPort, ZUSHORT *pwAMaxPort, 
                ZUSHORT *pwVMinPort, ZUSHORT *pwVMaxPort);

/**
 * @brief Set RTP port.
 *
 * @param [in] wAMinPort RTP audio min port.
 * @param [in] wAMaxPort RTP audio max port.
 * @param [in] wVMinPort RTP video min port.
 * @param [in] wVMaxPort RTP video max port.
 *
 * @retval ZOK Set RTP port successfully.
 * @retval ZFAILED Set RTP port failed.
 *
 * @see @ref Mtc_CallDbGetRtpPort
 */
MTCFUNC ZINT Mtc_CallDbSetRtpPort(ZUSHORT wAMinPort, ZUSHORT wAMaxPort, 
                ZUSHORT wVMinPort, ZUSHORT wVMaxPort);

/**
 * @brief Get RTP break detection time length in seconds from database.
 *
 * @return RTP break detection time length.
 *
 * @see Mtc_CallDbSetRtpBreakTime
 */
MTCFUNC ZUINT Mtc_CallDbGetRtpBreakTime(ZFUNC_VOID);

/**
 * @brief Set RTP break detection time length in seconds.
 *
 * @param [in] iTimeLen RTP break detection time length in seconds.
 *
 * @retval ZOK Set RTP break detection time length successfully.
 * @retval ZFAILED Set RTP break detection time length failed.
 *
 * @see Mtc_CallDbGetRtpBreakTime
 */
MTCFUNC ZINT Mtc_CallDbSetRtpBreakTime(ZUINT iTimeLen);

#define SRTP_SETTINGS

/**
 * @brief Get SRTP crypto type from database.
 *
 * @return SRTP crypto type, @ref EN_MTC_DB_SRTP_CRYPTO_TYPE.
 *
 * @see Mtc_CallDbSetSrtpCryptoType
 */
MTCFUNC ZUINT Mtc_CallDbGetSrtpCryptoType(ZFUNC_VOID);

/**
 * @brief Set SRTP crypto type.
 *
 * @param [in] iType SRTP crypto type, @ref EN_MTC_DB_SRTP_CRYPTO_TYPE.
 *
 * @retval ZOK Set SRTP crypto type successfully.
 * @retval ZFAILED Set SRTP crypto type failed.
 *
 * @see Mtc_CallDbGetSrtpCryptoType
 */
MTCFUNC ZINT Mtc_CallDbSetSrtpCryptoType(ZUINT iType);

/**
 * @brief Get authenticated SRTP option from database.
 *
 * @retval ZTRUE Enable authenticated SRTP.
 * @retval ZFALSE Disable authenticated SRTP.
 *
 * @see @ref Mtc_CallDbSetSrtpAuthRtp
 */
MTCFUNC ZBOOL Mtc_CallDbGetSrtpAuthRtp(ZFUNC_VOID);

/**
 * @brief Set authenticated SRTP option.
 *
 * @param [in] bEnable ZTRUE to enable authenticated SRTP, ZFALSE to disable.
 *
 * @retval ZOK Set authenticated SRTP option successfully.
 * @retval ZFAILED Set authenticated SRTP option failed.
 *
 * @see @ref Mtc_CallDbGetSrtpAuthRtp
 */
MTCFUNC ZINT Mtc_CallDbSetSrtpAuthRtp(ZBOOL bEnable);

/**
 * @brief Get encrypted SRTP option from database.
 *
 * @retval ZTRUE Enable encrypted SRTP.
 * @retval ZFALSE Disable encrypted SRTP.
 *
 * @see @ref Mtc_CallDbSetSrtpEncryptRtp
 */
MTCFUNC ZBOOL Mtc_CallDbGetSrtpEncryptRtp(ZFUNC_VOID);

/**
 * @brief Set encrypted SRTP option.
 *
 * @param [in] bEnable ZTRUE to enable encrypted SRTP, ZFALSE to disable.
 *
 * @retval ZOK Set encrypted SRTP option successfully.
 * @retval ZFAILED Set encrypted SRTP option failed.
 *
 * @see @ref Mtc_CallDbGetSrtpEncryptRtp
 */
MTCFUNC ZINT Mtc_CallDbSetSrtpEncryptRtp(ZBOOL bEnable);

/**
 * @brief Get encrypted SRTCP option from database.
 *
 * @retval ZTRUE Enable encrypted SRTCP.
 * @retval ZFALSE Disable encrypted SRTCP.
 *
 * @see @ref Mtc_CallDbSetSrtpEncryptRtcp
 */
MTCFUNC ZBOOL Mtc_CallDbGetSrtpEncryptRtcp(ZFUNC_VOID);

/**
 * @brief Set encrypted SRTCP option.
 *
 * @param [in] bEnable ZTRUE to enable encrypted SRTCP, ZFALSE to disable.
 *
 * @retval ZOK Set encrypted SRTCP option successfully.
 * @retval ZFAILED Set encrypted SRTCP option failed.
 *
 * @see @ref Mtc_CallDbGetSrtpEncryptRtcp
 */
MTCFUNC ZINT Mtc_CallDbSetSrtpEncryptRtcp(ZBOOL bEnable);

#define TRANSPORT_PARAMETER_SETTINGS

/**
 * @brief Get NACK option from database.
 *
 * @retval ZTRUE Start NACK.
 * @retval ZFALSE Do not start NACK.
 *
 * @see @ref Mtc_CallDbSetAudioNackEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetAudioNackEnable(ZFUNC_VOID);

/**
 * @brief Set NACK option.
 *
 * @param [in] bEnable NACK option.
 *
 * @retval ZOK Set NACK option successfully.
 * @retval ZFAILED Set NACK option failed.
 *
 * @see @ref Mtc_CallDbGetAudioNackEnable
 */
MTCFUNC ZINT Mtc_CallDbSetAudioNackEnable(ZBOOL bEnable);

/**
 * @brief Get NACK option from database.
 *
 * @retval ZTRUE Start NACK.
 * @retval ZFALSE Do not start NACK.
 *
 * @see @ref Mtc_CallDbSetVideoNackEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetVideoNackEnable(ZFUNC_VOID);

/**
 * @brief Set NACK option.
 *
 * @param [in] bEnable NACK option.
 *
 * @retval ZOK Set NACK option successfully.
 * @retval ZFAILED Set NACK option failed.
 *
 * @see @ref Mtc_CallDbGetVideoNackEnable
 */
MTCFUNC ZINT Mtc_CallDbSetVideoNackEnable(ZBOOL bEnable);

/**
 * @brief Get NACK RTT range from database.
 *
 * @param [out] piLow NACK RTT range lowest value in miliseconds.
 * @param [out] piHigh NACK RTT range highest value in miliseconds.
 *
 * @retval ZOK Get NACK RTT range successfully.
 * @retval ZFAILED Get NACK RTT range failed.
 *
 * @see @ref Mtc_CallDbSetVideoNackRttRange
 */
MTCFUNC ZINT Mtc_CallDbGetVideoNackRttRange(ZUINT *piLow, ZUINT *piHigh);

/**
 * @brief Set NACK RTT range.
 *
 * @param [in] iLow NACK RTT range lowest value in miliseconds.
 * @param [in] iHigh NACK RTT range highest value in miliseconds.
 *
 * @retval ZOK Set NACK RTT range successfully.
 * @retval ZFAILED Set NACK RTT range failed.
 *
 * @see @ref Mtc_CallDbGetVideoNackRttRange
 */
MTCFUNC ZINT Mtc_CallDbSetVideoNackRttRange(ZUINT iLow, ZUINT iHigh);

/**
 * @brief Get TMMBR option from database.
 *
 * @retval ZTRUE Start TMMBR.
 * @retval ZFALSE Do not start TMMBR.
 *
 * @see @ref Mtc_CallDbSetTmmbrEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetTmmbrEnable(ZFUNC_VOID);

/**
 * @brief Set TMMBR option.
 *
 * @param [in] bEnable TMMBR option.
 *
 * @retval ZOK Set TMMBR option successfully.
 * @retval ZFAILED Set TMMBR option failed.
 *
 * @see @ref Mtc_CallDbGetTmmbrEnable
 */
MTCFUNC ZINT Mtc_CallDbSetTmmbrEnable(ZBOOL bEnable);

/**
 * @brief Get audio rtcp-mux option from database.
 *
 * @retval ZTRUE Start audio rtcp-mux.
 * @retval ZFALSE Do not start audio rtcp-mux.
 *
 * @see @ref Mtc_CallDbSetAudioRtcpMuxEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetAudioRtcpMuxEnable(ZFUNC_VOID);

/**
 * @brief Set audio rtcp-mux option.
 *
 * @param [in] bEnable audio rtcp-mux option.
 *
 * @retval ZOK Set audio rtcp-mux option successfully.
 * @retval ZFAILED Set audio rtcp-mux option failed.
 *
 * @see @ref Mtc_CallDbGetAudioRtcpMuxEnable
 */
MTCFUNC ZINT Mtc_CallDbSetAudioRtcpMuxEnable(ZBOOL bEnable);

/**
 * @brief Get video rtcp-mux option from database.
 *
 * @retval ZTRUE Start video rtcp-mux.
 * @retval ZFALSE Do not start video rtcp-mux.
 *
 * @see @ref Mtc_CallDbSetVideoRtcpMuxEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetVideoRtcpMuxEnable(ZFUNC_VOID);

/**
 * @brief Set video rtcp-mux option.
 *
 * @param [in] bEnable video rtcp-mux option.
 *
 * @retval ZOK Set video rtcp-mux option successfully.
 * @retval ZFAILED Set video rtcp-mux option failed.
 *
 * @see @ref Mtc_CallDbGetVideoRtcpMuxEnable
 */
MTCFUNC ZINT Mtc_CallDbSetVideoRtcpMuxEnable(ZBOOL bEnable);

/**
 * @brief Get RPSI option from database.
 *
 * @retval ZTRUE Start RPSI.
 * @retval ZFALSE Do not start RPSI.
 *
 * @see @ref Mtc_CallDbSetRpsiEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetRpsiEnable(ZFUNC_VOID);

/**
 * @brief Set RPSI option.
 *
 * @param [in] bEnable RPSI option.
 *
 * @retval ZOK Set RPSI option successfully.
 * @retval ZFAILED Set RPSI option failed.
 *
 * @see @ref Mtc_CallDbGetRpsiEnable
 */
MTCFUNC ZINT Mtc_CallDbSetRpsiEnable(ZBOOL bEnable);

/**
 * @brief Get small NALU option from database.
 *
 * @retval ZTRUE Enable small NALU.
 * @retval ZFALSE Disable small NALU.
 *
 * @see @ref Mtc_CallDbSetSmallNaluEnable
 */
MTCFUNC ZBOOL Mtc_CallDbGetSmallNaluEnable(ZFUNC_VOID);

/**
 * @brief Set small NALU option.
 *
 * @param [in] bEnable Small NALU option.
 *
 * @retval ZOK Set small NALU option successfully.
 * @retval ZFAILED Set small NALU option failed.
 *
 * @see @ref Mtc_CallDbGetSmallNaluEnable
 */
MTCFUNC ZINT Mtc_CallDbSetSmallNaluEnable(ZBOOL bEnable);

/**
 * @brief Get packet time length from database.
 *
 * @return Packet time length.
 *
 * @see Mtc_CallDbSetPtime
 */
MTCFUNC ZUINT Mtc_CallDbGetPtime(ZFUNC_VOID);

/**
 * @brief Set packet time length.
 *
 * @param [in] iTimeLen Packet time length.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see Mtc_CallDbGetPtime
 */
MTCFUNC ZINT Mtc_CallDbSetPtime(ZUINT iTimeLen);

/**
 * @brief Get packet time length from database.
 *
 * @return Packet time length.
 *
 * @see Mtc_CallDbSetMaxPtime
 */
MTCFUNC ZUINT Mtc_CallDbGetMaxPtime(ZFUNC_VOID);

/**
 * @brief Set packet time length.
 *
 * @param [in] iMaxPtime Packet time length.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see Mtc_CallDbGetMaxPtime
 */
MTCFUNC ZINT Mtc_CallDbSetMaxPtime(ZUINT iMaxPtime);

/**
 * @brief Get packet time length from database.
 *
 * @return arm mode-set.
 *
 * @see Mtc_CallDbSetAmrModeSet
 */
MTCFUNC ZUINT Mtc_CallDbGetAmrModeSet(ZFUNC_VOID);


/**
 * @brief Set packet time length.
 *
 * @param [in] iModeSet mode-set.
 *
 * @retval ZOK Set successfully.
 * @retval ZFAILED Set failed.
 *
 * @see Mtc_CallDbGetAmrModeSet
 */
MTCFUNC ZINT Mtc_CallDbSetAmrModeSet(ZUINT iModeSet);

/**
 * @brief Get RUDP option from database.
 *
 * @retval ZTRUE Start RUDP.
 * @retval ZFALSE Do not start RUDP.
 *
 * @see @ref Mtc_CallDbSetArcRudpMode
 */
MTCFUNC ZBOOL Mtc_CallDbGetArcRudpMode(ZFUNC_VOID);

/**
 * @brief Set RUDP option.
 *
 * @param [in] bEnable RUDP option.
 *
 * @retval ZOK Set RUDP option successfully.
 * @retval ZFAILED Set RUDP option failed.
 *
 * @see @ref Mtc_CallDbGetAutoAcceptCall
 */
MTCFUNC ZINT Mtc_CallDbSetArcRudpMode(ZBOOL bEnable);

#define SERVICE_SETTINGS

/**
 * @brief Get auto accept call option from database.
 *
 * @return Type of auto accept call.
 *
 * @see @ref Mtc_CallDbSetArcRudpMode
 */
MTCFUNC ZUINT Mtc_CallDbGetAutoAcceptCall(ZFUNC_VOID);

/**
 * @brief Set auto accept call option.
 *
 * @param [in] iType Type of auto accept call.
 *
 * @retval ZOK Set auto accept call option successfully.
 * @retval ZFAILED Set auto accept call option failed.
 *
 * @see @ref Mtc_CallDbGetAutoAcceptCall
 */
MTCFUNC ZINT Mtc_CallDbSetAutoAcceptCall(ZUINT iType);

/**
 * @brief Get symmetrical negotiation from database.
 *
 * @retval ZTRUE Symmetrical negotiation is enable.
 * @retval ZFALSE Symmetrical negotiation is disable.
 *
 * @see @ref Mtc_CallDbSetSymNego
 */
MTCFUNC ZBOOL Mtc_CallDbGetSymNego();

/**
 * @brief Set symmetrical negotiation.
 *
 * @param [in] bEnable ZTRUE to enable symmetrical negotiation.
 *
 * @retval ZOK Set the option successfully.
 * @retval ZFAILED Set the option option failed.
 *
 * @see @ref Mtc_CallDbGetSymNego
 */
MTCFUNC ZINT Mtc_CallDbSetSymNego(ZBOOL bEnable);

/**
 * @brief Get if use compressed SDP flag from database.
 *
 * @retval ZTRUE Use compressed SDP.
 * @retval ZFALSE Not to use compressed SDP.
 *
 * @see @ref Mtc_CallDbSetSdpComp
 */
MTCFUNC ZBOOL Mtc_CallDbGetSdpComp(ZFUNC_VOID);

/**
 * @brief Set if use compressed SDP.
 *
 * @param [in] bEnable ZTRUE to use compressed SDP.
 *
 * @retval ZOK Set the option successfully.
 * @retval ZFAILED Set the option option failed.
 *
 * @see @ref Mtc_CallDbGetSdpComp
 */
MTCFUNC ZINT Mtc_CallDbSetSdpComp(ZBOOL bEnable);

/**
 * @brief Get if use data transmission flag from database.
 *
 * @retval ZTRUE Use data transmission.
 * @retval ZFALSE Not to use data transmission.
 *
 * @see @ref Mtc_CallDbSetDataTransmission
 */
MTCFUNC ZBOOL Mtc_CallDbGetDataTransmission(ZFUNC_VOID);

/**
 * @brief Set if use data transmission.
 *
 * @param [in] bEnable ZTRUE to use data transmission.
 *
 * @retval ZOK Set the option successfully.
 * @retval ZFAILED Set the option option failed.
 *
 * @see @ref Mtc_CallDbGetDataTransmission
 */
MTCFUNC ZINT Mtc_CallDbSetDataTransmission(ZBOOL bEnable);

#ifdef __cplusplus
}
#endif
    
#endif /* _MTC_CALL_DB_H__ */

