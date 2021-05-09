
if(typeof Radipi === "undefined"){
var Radipi = {};
}

Radipi.Const = function(){};

Radipi.hMax = 24; // hour:00-23
Radipi.mMax = 60;// min :00-59

Radipi.scriptPath = "/home/radipi/Script/";

Radipi.volup="/changevol?param=4 %2B"
Radipi.voldown="/changevol?param=4 -"

Radipi.radikoRandom="/radiko?param=R"

Radipi.getAudio="/getAudio"

Radipi.toggle="/command?param=echo 'cycle pause' | socat - /tmp/remocon.socket"
Radipi.quit="/quit"

Radipi.backward="/mpvSocketDelay?param= seek '\"0\" ,\"absolute-percent\"'"
Radipi.back10p="/mpvSocket?param= seek '\"-10\" ,\"relative-percent\"'"
Radipi.back20sec="/mpvSocket?param= seek -20"
Radipi.for20sec="/mpvSocket?param= seek 20"
Radipi.for10p="/mpvSocket?param= seek '\"10\" ,\"relative-percent\"'"
Radipi.forward="/mpvSocketDelay?param= quit 0"

Radipi.volumeScript = "setVolume.sh";
Radipi.killScript = "killsound.sh";
Radipi.radikoScript = "playradiko.sh";
Radipi.streamingScript= "playStreaming.sh";
Radipi.playMp3Script = "playLocalfile.sh";
Radipi.getMp3NameScript = "getMp3Name.sh";
Radipi.fmScript= "playFM.sh";

Radipi.nowplayingID = "presentID";
Radipi.nowplayingDirID = "presentDirID";

Radipi.areaText = "areaName";
Radipi.areaValue = "areaID";
Radipi.radikoText = "radikoName";
Radipi.radikoValue = "radikoID";
Radipi.streamingText = "streamingText";
Radipi.streamingValue = "streamingValue";
Radipi.dirText = "dirText";
Radipi.dirValue = "dirValue";
Radipi.fmText = "fmName";
Radipi.fmValue = "fmFreq";

Radipi.timefreePrefix = "time";

Radipi.sleepCommand = "sleep 1 ";
Radipi.mpvCommand = "mpv --no-video --msg-level=all=info --msg-time  ";
Radipi.weekdays =  new Array('Sun','Mon','Tue','Wed','Thr','Fri','Sat');

function readConfig(){
Radipi.radikoListInfo = getFile("config/radikoList.csv");
Radipi.areaListInfo = getFile("config/areaList.csv");
Radipi.streamingListInfo = getFile("config/streamingList.csv");
Radipi.dirListInfo = getFile("config/dirList.csv");
Radipi.fmListInfo = getFile("config/fmList.csv");
}
