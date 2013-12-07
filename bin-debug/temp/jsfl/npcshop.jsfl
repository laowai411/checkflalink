//clear console
fl.outputPanel.clear();
//fla url
var flaURL = "file:///F|/xymmo/assets_src/ui/npcshop.fla";
//the out put link data url
var outPutURL = "file:///E|/Xyyo/checkflalink/bin-debug/temp/linkURL/npcshop.xml";

var runStateURL = outPutURL.substr(0, outPutURL.lastIndexOf("/"))+"/running.txt";

FLfile.write(runStateURL, "running");
fl.outputPanel.trace("running state file is complete!!!\n"+runStateURL);

//link cache
var linkMap = new Object();

//remove old link data
FLfile.remove(outPutURL);
//create new link data
FLfile.write(outPutURL, "<xml>");
fl.outputPanel.trace("linkXML create!!!\n"+outPutURL);
//no show long time info
//fl.showIdleMessage(false);

//open fla
var doc = fl.openDocument(flaURL);
fl.outputPanel.trace("doc open!!!"+flaURL);	
var itemList = doc.library.items;
var len = itemList.length;
fl.outputPanel.trace("itemList.length: "+len);

for(var j=0; j<len; j++)
{
	var link = itemList[j].linkageClassName;
	if(link != undefined)
	{
		if(linkMap[link] != undefined)
		{
			linkMap[link].push(flaURL);				
		}
		else
		{
			linkMap[link] = new Array();
			linkMap[link].push(flaURL);
		}
	}
}
doc.close(false);
fl.outputPanel.trace(flaURL+" search complete!\n");
	
for(var link in linkMap)
{	
	FLfile.write(outPutURL, "\n\t<link id=\""+link+"\">", "append");
	for(var index in linkMap[link])
	{
		var tempLinkURL = FLfile.uriToPlatformPath(linkMap[link][index]);
		FLfile.write(outPutURL, "\n\t\t<srcFla>"+tempLinkURL+"</srcFla>", "append");
	}	
	FLfile.write(outPutURL, "\n\t</link>", "append");
}
FLfile.write(outPutURL, "\n</xml>", "append");

fl.outputPanel.trace("xml create complete!"+outPutURL);

//create complete state file
FLfile.write(outPutURL.substr(0, outPutURL.lastIndexOf("/"))+"/complete.txt", "complete");

