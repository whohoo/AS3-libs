/**************************************
*	name:	Split Sequence 1.0
*	author:	whohoo
* 	email:	whohoo@21cn.com
*	date:	2009-6-15 10:47
*	description:把当前时间轴上的序列图片按规则导出
*				不同的swf，主要应用于视频回放。
***************************************/

var dom			=	fl.getDocumentDOM();
var timeline	=	dom.getTimeline();
var lib			=	dom.library;
var libPath;
var totalFrames;

main();

function main(){
	fileURI		=	fl.runScript(fl.configURI+"/Commands/shareJSFL/commonFunc.jsfl", "isSaveFile");
	if(fileURI=="-1")	return;
	
	var swfNum	=	prompt("How many swf would be split?", 3);
	if(swfNum==null){
		fl.trace("cancel export swf.");
		return;
	}
	swfNum	=	Number(swfNum);
	totalFrames	=	timeline.getSelectedFrames()[2];
	if(totalFrames==null || totalFrames<swfNum){
		timeline.setSelectedFrames([timeline.layerCount-1, 0, timeline.frameCount]);
	} 
	totalFrames		=	timeline.frameCount;
	
	
	var frLables	=	getFramesLabel();
	timeline.copyFrames();//copy sequence frames.
	//trace( "totalFrames : " + totalFrames );
	libPath	=	"sequence_"+swfNum+" folder";
	createFolder();
	var len			=	swfNum;
	var items		=	[];
	var startTime	=	new Date();
	
	for(var i=0;i<len;i++){
		items.push(splitMovieClip(i, swfNum));
	}
	dom.exitEditMode();
	//copy all
	var len3	=	timeline.layerCount;
	for(i=0;i<len3;i++){
		timeline.setSelectedFrames([i, 0, totalFrames], false);
	}
	timeline.copyFrames();
	
	timeline.setSelectedFrames([]);
	for(i=0;i<len3;i++){
		if(timeline.layers[i].name!="as"){
			timeline.setSelectedFrames([i, 0, totalFrames], false);
		}else{
			timeline.setSelectedFrames([i, 1, totalFrames], false);
		}
	}
	
	timeline.removeFrames();
	createLog();
	
	
	log("["+fileURI+"/"+dom.name+"] export "+swfNum+" sequences at "+startTime.toString()+": ");
	log("totalFrames: "+totalFrames+", sequences: "+swfNum);
	var actScriptStr	=	createActionscript(items, frLables);
	var domName	=	dom.name.split(".fla")[0];
	log("add tow variables at first frame actionscript layer in "+domName+"_0.swf:");
	log(actScriptStr);
	//trace(actScriptStr);return;
	for(i=0;i<len;i++){
		var exportFileName	=	exportSWF(items[i], i, domName, actScriptStr);
	}
	
	//timeline.insertFrames(totalFrames, false, 0);
	for(i=0;i<len3;i++){
		timeline.setSelectedFrames([i, 0, totalFrames], false);
	}
	timeline.pasteFrames();
	log("done. time: "+(new Date().getTime()-startTime.getTime())/1000+" s");
}

function exportSWF(item, iSeq, domName, actScriptStr){
	var tLine	=	item.timeline;
	var frames	=	tLine.frameCount;
	timeline.currentLayer	=	timeline.layers.length-1;
	timeline.insertFrames(frames, false, 0);
	lib.addItemToDocument({x:0,y:0}, item.name);
	dom.align('left', true);
	dom.align('top', true);
	dom.setElementProperty('symbolType', 'graphic');
	dom.setElementProperty('loop', 'play once');
	var filename	=	fileURI+domName+"_"+iSeq+".swf";
	var layers		=	timeline.layers;
	var curLayer	=	layers[timeline.currentLayer];
	var curFrame	=	curLayer.frames[0];
	
	var numType		=	dom.asVersion==3 ? "int" : "Number";//unuse
	if(actScriptStr && iSeq==0){//only add to first sequence
		curFrame.actionScript	+=	"\r\n"+actScriptStr;
	}
	
	dom.exportSWF(filename, true);
	timeline.setSelectedFrames(0, timeline.frameCount);
	timeline.removeFrames();
	log("export sequence name: "+filename+", totalFrames: "+frames);
	return filename;
}

function splitMovieClip(iSeq, swfNum){
	var seq_path	=	createSeqMc("seq_"+iSeq);
	lib.editItem(seq_path);
	var tLine	=	dom.getTimeline();
	tLine.setSelectedFrames(0, 1);
	tLine.pasteFrames();
	var len	=	totalFrames;
	var i	=	0;
	var isSelected	=	true;
	var selectStart;
	var selectEnd;
	var framesArr	=	[];
	if(iSeq>0){
		selectStart	=	0;
		selectEnd	=	iSeq;
		//tLine.setSelectedFrames(selectStart, selectEnd, isSelected);
		framesArr.push([selectStart, selectEnd]);
		isSelected	=	false;
	}
	
	while(true){
		//trace( "swfNum+i+iSeq : " + (swfNum+i+iSeq) );
		selectStart	=	i+iSeq+1;
		selectEnd	=	selectStart+swfNum-1;
		selectEnd	=	selectEnd>totalFrames ? totalFrames : selectEnd;
		//trace([selectStart, selectEnd]);
		//tLine.setSelectedFrames(selectStart, selectEnd, isSelected);
		framesArr.push([selectStart, selectEnd]);
		if(isSelected)	isSelected	=	false;
		i	+=	swfNum;
		if(i>=len){
			break;
		}
	}
	
	//delete frames
	i	=	framesArr.length;
	while(i--){
		var framesObj	=	framesArr[i];
		selectStart	=	framesObj[0];
		selectEnd	=	framesObj[1];
		tLine.removeFrames(selectStart, selectEnd);
	}
	
	//tLine.removeFrames();
	tLine.setSelectedFrames([]);
	//
	//dom.exportSWF(fileURI+"/seq_"+iSeq+".swf", true);
	return lib.getSelectedItems()[0];
} 

function getFramesLabel(){
	var curLayer	=	timeline.layers[timeline.findLayerIndex("label")];//on label
	if(curLayer==null){
		return [];
	}
	var len			=	timeline.frameCount;
	var curFrame;
	var arr	=	[];
	
	for(var i=0;i<len;i++){
		curFrame	=	curLayer.frames[i];
		
		if(curFrame.startFrame==(i)){
			if(curFrame.labelType=="name"){
				arr.push({name:curFrame.name, frame:i});
			}
			i	+=	curFrame.duration-1;
		}else{
			
		}
	}
	return arr;
}

function createFolder(){
	lib.newFolder(libPath);
}

function createSeqMc(mcName){
	var seq_path	=	libPath+"/"+mcName;
	if(lib.itemExists(seq_path)){
		lib.selectItem(seq_path);
		var i	=	0;
		while(true){
			var new_seq_path	=	mcName+" backup_"+i;
			if(!lib.itemExists(libPath+"/"+new_seq_path)){
				lib.renameItem(new_seq_path);
				break;
			}else{
				i++;
			}
		}
	}
	
	lib.addNewItem('movie clip', seq_path);
	if (lib.getItemProperty('linkageImportForRS') == true) {
		lib.setItemProperty('linkageImportForRS', false);
	}else {
		lib.setItemProperty('linkageExportForAS', false);
		lib.setItemProperty('linkageExportForRS', false);
	}
	
	return seq_path;
}

function createActionscript(items, frLables){
	var actScriptStr	=	"var __seqFrames:Array = [";
	var len				=	items.length;
	for(var i=0;i<len;i++){
		var item	=	items[i];
		actScriptStr	+=	item.timeline.frameCount+", ";
	}
	actScriptStr	=	actScriptStr.substr(0, actScriptStr.length-2);
	actScriptStr	+=	"];\r\n";
	var len2	=	frLables.length;
	actScriptStr	+=	"var __frameLabel:Array = [";
	for(i=0;i<len2;i++){
		var curLabelObj	=	frLables[i];
		actScriptStr	+=	"{ frame:"+(curLabelObj.frame+1)+", name:\""+curLabelObj.name+"\" }, ";
	}
	if(len2>0){
		actScriptStr	=	actScriptStr.substr(0, actScriptStr.length-2);
	}
	actScriptStr	+=	"];";
	return actScriptStr;
}

function createLog(){
	if(!FLfile.exists(fileURI+"/sequence_log.txt")){
		FLfile.write(fileURI+"/sequence_log.txt", "");
	}else{
		log("\r");
	}
}

function log(str) {
	FLfile.write(fileURI+"/sequence_log.txt", str+"\r\n", true);
}


function trace(obj){
	fl.runScript(fl.configURI+"/Commands/shareJSFL/commonFunc.jsfl", "trace", obj);
}

function traceArrObj(name, obj){
	fl.runScript(fl.configURI+"/Commands/shareJSFL/commonFunc.jsfl", "traceArrObj", name, obj);
}