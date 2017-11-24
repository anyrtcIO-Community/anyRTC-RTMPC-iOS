#ifndef __RTC_CORE_H__
#define __RTC_CORE_H__
#include <string>
#include "LIV_Export.h"

class LIV_API RTCCore
{
public:
	virtual ~RTCCore() {};
	static RTCCore& Inst();

	/**
	* 初始化AnyRTC的开发者信息(详情请见:https://www.anyrtc.io)
	* @param:	strDevelopID - 开发者ID
	* @param:	strAppId - 应用ID
	* @param:	strKey - 开发者秘钥
	* @param:	strToken - TOKEN
	* @param:	strBundleId - Android是packagename   iOS是bundleid   web是domain
	*/
	virtual void InitEngineWithAnyrtcInfo(const char*strDevelopID, const char*strAppId,
		const char*strKey, const char*trToken, const std::string&strBundleId) = 0;
	/**
	* 配置私有云服务地址
	* @param:	strSvrAddr - 私有云的IP
	* @param:	nSvrPort - 私有云的端口
	*/
	virtual void ConfigServerForPriCloud(const char*strSvrAddr, int nSvrPort) = 0;

	/**
	* 是否是横屏模式
	*/
	virtual bool ScreenIsLandscape() = 0;
	/**
	* 使用横屏模式
	*/
	virtual void SetScreenToLandscape() = 0;
	/**
	* 使用竖屏模式
	*/
	virtual void SetScreenToPortrait() = 0;

	/**
	* 设置直播为音频模式
	*/
	virtual void SetLiveToAuidoOnly(bool enabled, bool audioDetect) = 0;
	/**
	* 是否是纯音频直播模式
	*/
	virtual bool LiveIsAuidoOnly() = 0;
	/**
	* 是否开启音频检测
	*/
	virtual bool LiveIsAudioDetect() = 0;
    
    virtual void UserThreedFilter(bool userThreeFilter) = 0;
    
    virtual bool UserIsThreeFilter() = 0;

	/**
	* 设置音频采集设备
	*/
	virtual void SwitchAudioCapture(const char*strAudioDev) = 0;

	/**
	* 设置音频播放设备
	*/
	virtual void SwitchAudioSpeaker(const char*strAudioDev) = 0;

#ifdef WIN32
	/**
	* 获取设备信息,仅限Windows平台
	*/
	static const int GetAudDevCount();
	static const int GetSpkDevCount();
	static const int GetVidDevCount();
	static const int RefreshVidDevCount();
	static const char* GetAudDevNameByIndex(int index);
	static const char* GetSpkDevNameByIndex(int index);
	static const char* GetVidDevNameByIndex(int index);
#else
	static void SetCameraMirror(bool enabled);
#endif

protected:
	virtual void InitDevice() = 0;

protected:
	RTCCore() {};
};

#endif	// __RT_CORE_H__
