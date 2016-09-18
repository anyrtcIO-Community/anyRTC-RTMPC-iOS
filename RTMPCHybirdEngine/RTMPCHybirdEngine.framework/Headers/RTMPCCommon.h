#ifndef __RTMP_C_COMMON_H__
#define __RTMP_C_COMMON_H__

typedef enum RTMPCVideoMode
{
	RTMPC_Video_HH = 0,
    RTMPC_Video_Low,
    RTMPC_Video_SD,
    RTMPC_Video_QHD,
    RTMPC_Video_HD,
    RTMPC_Video_720P,
    RTMPC_Video_1080P,
    RTMPC_Video_2K,
	RTMPC_Video_4K,
}RTMPCVideoMode;

typedef enum RTMPCScreenOrientation{
	RTMPC_SCRN_Portrait = 0,
	RTMPC_SCRN_LandscapeRight,
    RTMPC_SCRN_PortraitUpsideDown,
    RTMPC_SCRN_LandscapeLeft
}RTMPCScreenOrientation;

typedef enum RTMPMixVideoType
{
	RTMP_MXV_NULL = 0,
	RTMP_MXV_MAIN,
	RTMP_MXV_B_LEFT, 
	RTMP_MXV_B_RIGHT,
	RTMP_MXV_CUSTOM,
}RTMPMixVideoType;

typedef enum RTMPNetAdjustMode
{
	RTMP_NA_Nor	= 0,		// Normal
	RTMP_NA_Fast,			// When network is bad, we will drop some video frame.
	RTMP_NA_AutoBitrate		// When network is bad, we will adjust video bitrate to match.
    
}RTMPNetAdjustMode;

#endif	// __RTMP_C_COMMON_H__
