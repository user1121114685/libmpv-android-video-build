package main

import (
	"log"
	"os"
	"strings"
	"time"
)

//  本程序设计的目的是为了方便快捷打补丁，
//  本程序最重要的是安全，不出错，而不是运行速度  和代码优雅 切记
// 下面的有些补丁可能会被更新到主仓库，也可能出现新的问题而出现新的补丁

func main() {
	//gpl := flag.Bool("gpl", false, "是否是gpl补丁")
	//flag.Parse()

	// 参考这里 写路径 buildscripts/include/download-deps.sh  本程序运行的时候是在 buildscripts 目录下
	mpv_path := "./deps/mpv"
	ffmpeg_path := "./deps/ffmpeg"
	//libx64_path := "./deps/libx264"
	//libplacebo_path := "./deps/libplacebo"

	//  下面是mpv 补丁 mpv_lavc_set_java_vm.patch
	insertFile(mpv_path+"/libmpv/client.h", "MPV_EXPORT void mpv_wakeup(mpv_handle *ctx);", "MPV_EXPORT int av_jni_set_java_vm(void *vm, void *log_ctx);")
	insertFile(mpv_path+"/player/client.c", "#include <assert.h>", "#include <libavcodec/jni.h>")
	insertFile(mpv_path+"/libmpv/client.h", "MPV_EXPORT void mpv_wakeup(mpv_handle *ctx);", "MPV_EXPORT int mpv_lavc_set_java_vm(void *vm);")
	insertFile(mpv_path+"/player/client.c", "#include <assert.h>", "#include <libavcodec/jni.h>")
	insertFile(mpv_path+"/player/client.c", "// map client API types to internal types", "int mpv_lavc_set_java_vm(void *vm) {\n    return av_jni_set_java_vm(vm, NULL);\n}")

// 	insertFile(mpv_path+"/meson.build", "link_flags = []", "dependencies +=cc.find_library('c++', required : true)\nlink_flags +=['-stdlib=libc++']")

	replaceFile(mpv_path+"/MPV_VERSION", "-UNKNOWN", "-little_lucky2_"+time.Now().Format("20060102"))

	// 	//下面是 ffmpeg 补丁
	replaceFile(ffmpeg_path+"/libavformat/dashdec.c", "xmlNodeSetContent(node, root_url);", "char* root_url_content = xmlEncodeSpecialChars(NULL, root_url);\n        xmlNodeSetContent(node, root_url_content);\n        xmlFree(root_url_content);")
	replaceFile(ffmpeg_path+"/libavformat/dashdec.c", "xmlNodeSetContent(baseurl_nodes[i], tmp_str);", "char* tmp_str_content = xmlEncodeSpecialChars(NULL, tmp_str);\n            xmlNodeSetContent(baseurl_nodes[i], tmp_str_content);\n            xmlFree(tmp_str_content);")

	// 	// 下面 是gpl 单独补丁
	// 	if !*gpl {
	// 		return
	// 	}
	// 	// gpl mpv 补丁
	// 	insertFile(mpv_path+"/meson.build", "# the dependency order of libass -> ffmpeg is necessary due to", "# fftools-ffi\nlibfftools_ffi = dependency('fftools-ffi')")
	// 	replaceFile(mpv_path+"/meson.build", "libswscale]", "libswscale,\n                libfftools_ffi]")
	// 	replaceFile(mpv_path+"/meson.build", "'ta/ta_utils.c'", "'ta/ta_utils.c',\n    ## fftools-ffi hack\n    'fftools-ffi.c'")
	// 	addFile(mpv_path+"/fftools-ffi.c", "#include \"fftools-ffi/dart_api.h\"\n\nvoid* a = FFToolsFFIInitialize;\nvoid* b = FFToolsFFIExecuteFFmpeg;\nvoid* c = FFToolsFFIExecuteFFprobe;\nvoid* d = FFToolsCancel;")
	// 	// gpl libx64 补丁
	// 	replaceFile(libx64_path+"/configure", "i*86)", "*86)")
}

func insertFile(file, targetField, insertTarget string) {
	// 读取文件
	data, err := os.ReadFile(file)
	if err != nil {
		log.Println(err)
		return
	}

	// 查找并插入字符串

	newString := targetField + "\n" + insertTarget

	// 检查字符串是否已经存在
	if !strings.Contains(string(data), insertTarget) {
		modifiedData := strings.Replace(string(data), targetField, newString, 1)

		// 写入修改后的内容
		err = os.WriteFile(file, []byte(modifiedData), os.FileMode(0644))
		if err != nil {
			log.Println(err)
		}
		log.Println("已插入字符串 ", insertTarget, " 位置在 ", file)
	}
}

func replaceFile(file, targetField, insertTarget string) {
	// 读取文件
	data, err := os.ReadFile(file)
	if err != nil {
		log.Println(err)
		return
	}

	// 检查字符串是否已经存在
	if !strings.Contains(string(data), insertTarget) {
		modifiedData := strings.Replace(string(data), targetField, insertTarget, 1)

		// 写入修改后的内容
		err = os.WriteFile(file, []byte(modifiedData), os.FileMode(0644))
		if err != nil {
			log.Println(err)
		}
		log.Println("已替换字符串 ", insertTarget, " 位置在 ", file)
	}
}
func addFile(file, writeData string) {
	// 写入修改后的内容
	err := os.WriteFile(file, []byte(writeData), os.FileMode(0644))
	if err != nil {
		log.Println(err)
	}
	log.Println("新增文件位置在 ", file)
}
