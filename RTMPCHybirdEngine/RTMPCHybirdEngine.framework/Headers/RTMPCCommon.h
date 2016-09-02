#ifndef __RTMP_C_COMMON_H__
#define __RTMP_C_COMMON_H__

typedef enum RTMPCVideoMode
{
	RTMPC_Video_HD = 0,
    RTMPC_Video_QHD,
	RTMPC_Video_SD,
	RTMPC_Video_Low

}RTMPCVideoMode;

typedef enum RTMPNetAdjustMode
{
	RTMP_NA_Nor	= 0,		// Normal
	RTMP_NA_Fast,			// When network is bad, we will drop some video frame.
	RTMP_NA_AutoBitrate	// When network is bad, we will adjust video bitrate to match.
    
}RTMPNetAdjustMode;

#endif	// __RTMP_C_COMMON_H__