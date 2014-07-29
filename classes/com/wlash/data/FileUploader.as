/*utf8*/
//**********************************************************************************//
//	name:	FileUploader 1.1
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Wed Sep 21 2011 22:14:19 GMT+0800
//	description: This file was created by "post.fla" file.
//				1.0 此类是根据同人人网提供的FileUploader类修改而成,
//				多文件上传,并附带提交参数,
//				TODO 把得到的postData分离出来
//				1.1 优化
//**********************************************************************************//

package com.wlash.data{
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class FileUploader extends Object {

		public function FileUploader() {
		}

		public static const BOUNDARY_LENGTH:uint = 0x12;
		public static const LINE_BRAKE:uint = 0x0d0a;
		public static const LINE2_BRAKE:uint = 0x0d0a0d0a;
		public static const BOUNDARY:uint = 0x2d2d;
		
		public static const DEFAULT_CONTENT_TYPE:String = "application/octet-stream";
		public static const DEFAULT_FILENAME:String = "default.jpg";
		
		public static function upload2(request:URLRequest, files:Array, filenames:Array=null):URLLoader {
			var urlLoader:URLLoader	=	new URLLoader();
			upload(urlLoader, request, files,filenames);
			return urlLoader;
		}
		
		public static function upload(loader:URLLoader,request:URLRequest,files:Array, filenames:Array=null):void {
			// generate boundary
			var i:int,tmp:String;
			var boundary:ByteArray = new ByteArray();
			boundary.endian = Endian.BIG_ENDIAN;
			boundary.writeShort(BOUNDARY);
			for (i = 0; i < BOUNDARY_LENGTH-2; i++) {
				boundary.writeByte(int(97 + Math.random() * 26));
			}
			boundary.position = 0;

			// prepare new request
			var req:URLRequest = new URLRequest(request.url);
			req.contentType = 'multipart/form-data; boundary=' + boundary.readUTFBytes(BOUNDARY_LENGTH);
			req.method = URLRequestMethod.POST;

			// prepare post data
			var postData:ByteArray = new ByteArray();
			postData.endian = Endian.BIG_ENDIAN;

			// write parameters
			var pars:URLVariables = request.data as URLVariables;
			
			for (var par:String in pars) {
				// -- + boundary
				postData.writeShort(BOUNDARY);
				postData.writeBytes(boundary);

				// line break
				postData.writeShort(LINE_BRAKE);

				// content disposition
				tmp = 'Content-Disposition: form-data; name="' + par + '"';
				postData.writeUTFBytes(tmp);

				// 2 line breaks
				postData.writeInt(LINE2_BRAKE);

				// parameter
				postData.writeUTFBytes(pars[par]);

				// line break
				postData.writeShort(LINE_BRAKE);
			}
			

			// write files
			var len:int	=	files.length;
			for (i = 0; i < len; ++i) {
				// -- + boundary
				postData.writeShort(BOUNDARY);
				postData.writeBytes(boundary);

				// line break
				postData.writeShort(LINE_BRAKE);

				// content disposition
				var fieldName:String = "FileData"+i;
				
				//if (fieldNames && fieldNames[i]) fieldName = fieldNames[i];
				tmp = 'Content-Disposition: form-data; name="' + fieldName + '"; filename="';
				postData.writeUTFBytes(tmp);

				var contentType:String;
				var filename:String	=	null;
				var file:ByteArray;
				// file data
				var fileObj:Object = files[i];
				if (fileObj is ByteArray) {
					contentType	=	DEFAULT_CONTENT_TYPE;
					file	=	fileObj as ByteArray;
					if (filenames && filenames[i]) {
						filename = filenames[i];
					}else {
						filename	=	DEFAULT_FILENAME;
					}
				}else if (fileObj.file is ByteArray) {
					file		=	fileObj.file;
					if (fileObj.contentType is String) {
						contentType	=	fileObj.contentType;
					}
					if (fileObj.filename is String) {
						filename	=	fileObj.filename;
					}else {
						filename	=	DEFAULT_FILENAME;
					}
				}else {
					throw new Error("not found ByteArray in files");
				}
				
				
				postData.writeUTFBytes(filename);

				// missing "
				postData.writeByte(0x22);

				// line break
				postData.writeShort(LINE_BRAKE);

				
				//if (contentTypes && contentTypes[i]) contentType = contentTypes[i];
				tmp = 'Content-Type: ' + contentType;
				postData.writeUTFBytes(tmp);

				// 2 line breaks
				postData.writeInt(LINE2_BRAKE);

				postData.writeBytes(file);

				// line break
				postData.writeShort(LINE_BRAKE);
			}
			// end of writting files
			/*
			// -- + boundary
			postData.writeShort(0x2d2d);
			postData.writeBytes(boundary);

			// line break
			postData.writeShort(0x0d0a);

			// upload field
			tmp = 'Content-Disposition: form-data; name="Upload"';
			postData.writeUTFBytes(tmp);

			// 2 line breaks
			postData.writeInt(0x0d0a0d0a);

			// submit
			tmp = 'Submit Query';
			postData.writeUTFBytes(tmp);

			// line break
			postData.writeShort(0x0d0a);
*/
			// -- + boundary + --
			postData.writeShort(0x2d2d);
			postData.writeBytes(boundary);
			postData.writeShort(0x2d2d);

			// line break
			postData.writeShort(LINE_BRAKE);

			req.data = postData;
			loader.load(req);
		}

		
	}
}