#ifndef __RTC_COMMON_H__
#define __RTC_COMMON_H__

typedef enum {
    AnyRTC_OK = 0,				// 正常
    AnyRTC_UNKNOW = 1,          // 未知错误
    AnyRTC_EXCEPTION = 2,		// SDK调用异常
	AnyRTC_EXP_UNINIT = 3,		// SDK未初始化
	AnyRTC_EXP_PARAMS_INVALIDE = 4,	// 参数非法
	AnyRTC_EXP_NO_NETWORK = 5,		// 没有网络链接
	AnyRTC_EXP_NOT_FOUND_CAMERA = 6,		// 没有找到摄像头设备
	AnyRTC_EXP_NO_CAMERA_PERMISSION = 7,	// 没有打开摄像头权限
	AnyRTC_EXP_NO_AUDIO_PERMISSION = 8,		// 没有音频录音权限
	AnyRTC_EXP_NOT_SUPPORT_WEBRTC = 9,		// 浏览器不支持原生的webrtc


    AnyRTC_NET_ERR = 100,			// 网络错误
	AnyRTC_NET_DISSCONNECT = 101,	// 网络断开
    AnyRTC_LIVE_ERR	= 102,			// 直播出错
	AnyRTC_EXP_ERR = 103,			// 异常错误
	AnyRTC_EXP_Unauthorized = 104,	// 服务未授权(仅可能出现在私有云项目)

    AnyRTC_BAD_REQ = 201,		// 服务不支持的错误请求
    AnyRTC_AUTH_FAIL = 202,		// 认证失败
    AnyRTC_NO_USER = 203,		// 此开发者信息不存在
    AnyRTC_SQL_ERR = 204,		// 服务器内部数据库错误
    AnyRTC_ARREARS = 205,		// 账号欠费
    AnyRTC_LOCKED = 206,		// 账号被锁定
    AnyRTC_FORCE_EXIT = 207,	// 强制离开
	AnyRTC_ID_INVALIDE = 208,	// AnyRTC ID非法(仅会议和RTCP中检测)
	AnyRTC_SERVICE_CLOSED = 209,// 服务未开通 
	AnyRTC_BUNDLE_ID_ERR = 210,	// Bundle ID不匹配
	AnyRTC_PUB_GONE = 211,		// 订阅的PubID已过期
	AnyRTC_NO_RTC_SVR = 212,	// 没有RTC服务器
}AnyRTCErrorCode;

//连麦
typedef enum {
	RTCLive_OK = 0,					// 正常
	RTCLive_NOT_START = 600,		// 直播未开始
	RTCLive_HOSTER_REJECT = 601,	// 主播拒绝连麦
	RTCLive_LINE_FULL = 602,		// 连麦已满
	RTCLive_CLOSE_ERR = 603,		// 游客关闭错误，onRtmpPlayerClosed
	RTCLive_HAS_OPENED = 604,		// 直播已经开始，不能重复开启
	RTCLive_IS_STOP = 605,			// 直播已结束
}RTCLiveErrorCode;

//Meet
typedef enum {
	RTCMeet_OK = 0,      // 正常
	RTCMeet_NOT_START = 700,  // 会议未开始
	RTCMeet_IS_FULL = 701,	  // 会议室已满
	RTCMeet_NOT_COMPARE = 702,// 会议类型不匹配
}RTCMeetErrorCode;

//P2PCall
typedef enum {
	RTCCall_OK = 0,      // 正常
	RTCCall_PEER_BUSY = 800,  // 对方正忙
	RTCCall_OFFLINE,		// 对方不在线
	RTCCall_NOT_SELF,		// 不能呼叫自己
	RTCCall_EXP_OFFLINE,	// 通话中对方意外掉线
	RTCCall_EXP_EXIT,		// 对方异常导致(如：重复登录帐号将此前的帐号踢出)
	RTCCall_TIMEOUT,		// 呼叫超时(45秒)
	RTCCall_NOT_SURPPORT,	// 不支持
}RTCCallErrorCode;

//Meet
typedef enum {
    RTCMeet_Videos_HHD = 0,    //* 1920*1080 - 2048kbps
    RTCMeet_Videos_HD,        //* 1280*720 - 1024kbps
    RTCMeet_Videos_QHD,       //* 960*540 - 768kbps
    RTCMeet_Videos_SD,        //* 640*480 - 384kbps
    RTCMeet_Videos_Low,       //* 352*288 - 256kbps
    RTCMeet_Videos_Flow       //* 320*240 - 128kbps
}RTCMeetVideosMode;
//RTCP
typedef enum {
	RTCRtcp_OK = 0,      // 正常
	RTCRtcp_NOT_START = 800,     // 会议未开始
}RTCRtcpErrorCode;

typedef enum RTCPVideoMode
{
	RTCP_Video_HD = 0,	//* 1280*720 - 1024kbps
	RTCP_Video_QHD,		//* 960*540 - 768kbps
	RTCP_Video_SD,		//* 640*480 - 512kbps
	RTCP_Video_Low		//* 352*288 - 384kbps
}RTCPVideoMode;

//Talk
typedef enum {
	RTCTalk_OK = 0,      // 正常
	RTCTalk_APPLY_SVR_ERR = 800,    // 申请麦但是服务器异常 (没有MCU服务器,暂停申请)
	RTCTalk_APPLY_BUSY = 801,		// 当前你正在忙
	RTCTalk_APPLY_NO_PRIO = 802,	// 当前麦被占用 (有人正在说话切你的权限不够)
	RTCTalk_APPLY_INITING = 803,	// 正在初始化中 (自身的通道没有发布成功,不能申请)
	RTCTalk_APPLY_ING = 804,		// 等待上麦
	RTCTalk_ROBBED = 810,			// 麦被抢掉了
	RTCTalk_BREAKED = 811,			// 麦被释放了
	RTCTalk_RELEASED_BY_P2P = 812,	// 麦被释放了，因为要对讲
	RTCTalk_P2P_OFFLINE = 820,		// 强插时，对方可能不在线了或异常离线
	RTCTalk_P2P_BUSY = 821,			// 强插时，对方正忙
	RTCTalk_P2P_NOT_TALK = 822,		// 强插时，对方不在麦上
	RTCTalk_V_MON_OFFLINE = 830,	// 视频监看时，对方不在线，或下线了
	RTCTalk_V_MON_GRABED = 831,		// 视频监看被抢占了
	RTCTalk_CALL_OFFLINE = 840,		// 对方不在线或掉线了
	RTCTalk_CALL_NO_PRIO = 841,		// 发起呼叫时自己有其他业务再进行(资源被占用)
	RTCTalk_CALL_NOT_FOUND = 842,	// 会话不存在
}RTCTalkErrorCode;

typedef enum {
    RTC_V_1X3 = 0 ,       // Default - One big screen and 3 subscreens
    RTC_V_3X3_auto,       // All screens as same size & auto layout
}RTCVideoLayout;

typedef enum {
    RTMPC_LINE_V_Fullscrn = 0,		// 　默认模式：主播全屏，副主播小屏
    RTMPC_LINE_V_1_equal_others = 1,	// 　主播跟副主播视频大小一致
    RTMPC_LINE_V_1big_3small = 2,		// 　主播大屏（非全屏）副主播小屏
	RTMPC_LINE_V_1full_4small = 3,		// 主大(是全屏),四小副
}RTMPCLineVideoLayout;

typedef enum {
	RTP2P_CALL_Video = 0,		//	默认视频呼叫
	RTP2P_CALL_VideoPro = 1,	//	视频呼叫Pro模式: 被呼叫方可先看到对方视频
	RTP2P_CALL_Audio  = 2,		//	音频呼叫
	RTP2P_CALL_VideoMon = 3		//	视频监看模式,此模式被叫端只能是Android
}RTP2PCallMode;

typedef enum {
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

typedef enum {
    AnyRTCVideoQuality_Low1 = 0,      // 320*240 - 128kbps
    AnyRTCVideoQuality_Low2,          // 352*288 - 256kbps
    AnyRTCVideoQuality_Low3,          // 352*288 - 384kbps
    AnyRTCVideoQuality_Medium1,       // 640*480 - 384kbps
    AnyRTCVideoQuality_Medium2,       // 640*480 - 512kbps
    AnyRTCVideoQuality_Medium3,       // 640*480 - 768kbps
    AnyRTCVideoQuality_Height1,       // 960*540 - 1024kbps
    AnyRTCVideoQuality_Height2,       // 1280*720 - 1280kbps
    AnyRTCVideoQuality_Height3,       // 1920*1080 - 2048kbps
}AnyRTCVideoQualityModel;

typedef enum {
    RTC_SCRN_Portrait = 0,
    RTC_SCRN_LandscapeRight,
    RTC_SCRN_PortraitUpsideDown,
    RTC_SCRN_LandscapeLeft,
    RTC_SCRN_Auto
}RTCScreenOrientation;

typedef enum {
    RTMP_MXV_NULL = 0,
    RTMP_MXV_MAIN,
    RTMP_MXV_B_LEFT,
    RTMP_MXV_B_RIGHT,
    RTMP_MXV_CUSTOM,
}RTMPMixVideoType;

typedef enum {
    RTMP_NA_Nor = 0,		// Normal
    RTMP_NA_Fast,			// When network is bad, we will drop some video frame.
    RTMP_NA_AutoBitrate		// When network is bad, we will adjust video bitrate to match.
    
}RTMPNetAdjustMode;

typedef enum {
    RTMPC_V_T_HOR_LEFT = 0,
    RTMPC_V_T_HOR_CENTER,
    RTMPC_V_T_HOR_RIGHT
}RTMPCVideoTempHor;

typedef enum {
    RTMPC_V_T_VER_TOP = 0,
    RTMPC_V_T_VER_CENTER,
    RTMPC_V_T_VER_BOTTOM
}RTMPCVideoTempVer;

typedef enum {
    RTMPC_V_T_DIR_HOR = 0,
    RTMPC_V_T_DIR_VER
}RTMPCVideoTempDir;

typedef enum {
    RTC_Nomal_Message_Type = 0,//普通文本消息
    RTC_Barrage_Message_Type = 1   //弹幕消息
}RTCMessageType;

// 相机类型
typedef enum {
    AnyRTCCameraTypeNomal = 0,
    AnyRTCCameraTypeBeauty = 1
}AnyRTCCameraType;

//滤镜常量
typedef enum : char {
    //美颜滤镜
    AnyCameraDeviceFilter_Beautiful=0,
    //原始
    AnyCameraDeviceFilter_Original=1,
    //高斯模糊
    AnyCameraDeviceFilter_GaussianBlur=2
    
} AnyCameraDeviceFilter;

typedef enum {
    //表示按比例缩放并且填满view，意味着图片可能超出view，可能被裁减掉
    AnyRTCVideoRenderScaleAspectFill = 0,
    //表示通过缩放来填满view，也就是说图片会变形
    AnyRTCVideoRenderScaleToFill,
    //表示按比例缩放并且图片要完全显示出来，意味着view可能会留有空白
    AnyRTCVideoRenderScaleAspectFit
    
}AnyRTCVideoRenderMode;

#endif	// __RTC_COMMON_H__
