if(typeof Radipi === "undefined"){
	var Radipi = {};
}

Radipi.Const = function(){};


Radipi.hMax = 24; // hour:00-23
Radipi.mMax = 60;// min :00-59

Radipi.scriptPath = "/home/radipi/Script/";
Radipi.setList="/home/radipi/Script/streamingListAll"

Radipi.volup="/changevol?param=4 %2B"
Radipi.voldown="/changevol?param=4 -"

Radipi.radiko="/radiko?param="
Radipi.JOAKFM="/radiko?param=JOAK-FM"
Radipi.BBCWorld="/streaming?param=BBCWorld&setList=/home/radipi/Script/streamingListAll"
Radipi.radikoRandom="/radiko?param=R"

Radipi.playStreaming="/streaming?param="
Radipi.randomStreaming="/streaming?param=R&setList=/home/radipi/Script/streamingListAll"

Radipi.radipiDrive="/mntRadio?param=/mnt/radipiDrive"
Radipi.menu1="/mntRadio?param=/mnt/radipiDrive"
Radipi.menu2="/mntRadio?param=/mnt/radipiDrive"
Radipi.menu3="/mntRadio?param=/mnt/radipiDrive"
Radipi.FMtuner="/fmtuner?param=playFM.sh"

Radipi.lircrcmanual="/remocon?param="

Radipi.getAudio="/getAudio"

Radipi.toggle="/command?param=echo 'cycle pause' | socat - /tmp/remocon.socket"
Radipi.quit="/quit"

Radipi.menu="/remocon?param=menu"
Radipi.program="/remocon?param=program"

Radipi.speedup="/speed?param=up"
Radipi.speeddown="/speed?param=down"

Radipi.mnt2021="/mntRadio?param=/mnt/rec2021/"
Radipi.mnt2020="/mntRadio?param=/mnt/rec2020/"


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
