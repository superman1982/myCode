#设置全局变量 BEGIN
PROJECT="/Users/iosdev/Documents/MyCode/mobile_ipad/src/M1IPad.xcodeproj"
SCHEME="M1IPad"
IDENTITY="com.seeyon.oa.M1IPad"
PROVISIONING_PROFILE="/Users/iosdev/Documents/autBuild/codesign/M1IPadAppID_dis_2014-2.mobileprovision"
OUTDIR="/Users/iosdev/Documents/autBuild/ipa"
PRODUCTDIR=${OUTDIR}
SVN_LOCAL_DIR="/Users/iosdev/Documents/M1_IPA/IOS_ipa_513/ipad"
NUMBER_OF_TODAY="01"
IPAVERSION="_v5.1.3_"

if [ $# -eq 1 ];then
    NUMBER_OF_TODAY=$1
elif [ $# -gt 1 ]; then
	echo '输入的参数格式不对，请输入一个参数或者不带参数'
        exit 4 
fi
    
IPANAME="${SCHEME}""${IPAVERSION}""$(date +%Y%m%d)""${NUMBER_OF_TODAY}"
#设置全局变量 END


#清楚上次的临时文件 BEGIN
cd ${OUTDIR}
rm -rf *.*

if [ $? -eq 0 ]; then
	echo '临时文件删除成功'
        sleep 3s
else 
        echo '临文件时删除失败' 
        exit 4;   
fi
#清除上次的临时文件 END


#clean 工程 BEGIN
xcodebuild -project "${PROJECT}" clean

if [ $? -eq 0 ]
then 
	 echo '工程CLEAN 成功'
         sleep 3s
else
  	 echo '工程CLEANH 失败'
         exit 4;
fi

if [ ! -f $PROVISIONING_PROFILE ]; then
    echo "请下载签名文件"${PROVISIONING_PROFILE}
    exit 4;
fi
#clean 工程 END
 

xcodebuild -project "${PROJECT}" -scheme "${SCHEME}" -configuration Release -sdk iphoneos CONFIGURATION_BUILD_DIR=${OUTDIR} build
 
if [ $? -eq 0 ]; then
    xcrun -sdk iphoneos PackageApplication -v "${PRODUCTDIR}/${SCHEME}.app" -o "${OUTDIR}/${IPANAME}.ipa" ;
    if [ $? -eq 0 ]; then
       	     cp "${OUTDIR}/${IPANAME}.ipa" "${SVN_LOCAL_DIR}"
             if [ $? -eq 0 ]; then
                 echo '成功拷贝到本地仓库'
                 sleep 1s
                 cd "${SVN_LOCAL_DIR}"
                 svn add "${IPANAME}.ipa"
                 svn commit "${IPANAME}.ipa" -m "添加${IPANAME}.ipa"

    exec 8<>/dev/tcp/211.157.139.204/6666
    echo "F:\\UFSeeyon\\3.0seeyon\\tomcat\\webapps\\yyoa\\ios\\share\\5.1.3\\5.1.3IOS.bat" >&8
    cat <&8

             else
                 echo '拷贝到本地仓库失败'
                 exit 4 
             fi   
    fi
fi

