
if(typeof Radipi === "undefined"){
var Radipi = {};
}

Radipi.Const = function(){};

Radipi.getAudioInterval=7000;

Radipi.scriptPath = "/home/radipi/Script/";
Radipi.setList="/home/radipi/Script/streamingListBase"

Radipi.volup="/changevol?param=4 %2B"
Radipi.voldown="/changevol?param=4 -"

Radipi.radiko="/radiko?param="
Radipi.JOAKFM="/radiko?param=JOAK-FM"
Radipi.BBCWorld="/streaming?param=BBCWorld&setList=/home/radipi/Script/streamingListBase"
Radipi.radikoRandom="/radiko?param=R"

Radipi.playStreaming="/streaming?param="
Radipi.randomStreaming="/streaming?param=R&setList=/home/radipi/Script/streamingListBase"

Radipi.setConfig="/setConfig?param=bash /home/radipi/Script/setConfig.sh true"

Radipi.radipiDrive="/mntRadio?param=/mnt/radipiDrive/"
Radipi.mnt1="/mntRadio?param=/mnt/radipiDrive/"
Radipi.mnt2="/mntRadio?param=/mnt/radipiDrive/"
Radipi.mnt3="/mntRadio?param=/mnt/radipiDrive/"
Radipi.ch1 ="/timetable?ch=1&param=/tmp/sheet1"
Radipi.ch2 ="/timetable?ch=2&param=/tmp/sheet2"
Radipi.ch3 ="/timetable?ch=3&param=/tmp/sheet3"

Radipi.FMtuner="/fmtuner?param=playFM.sh"
Radipi.timefree="/timefree?param=timefree.sh"

Radipi.getAudio="/getAudio"

Radipi.autoPlay="/autoPlay?param=on"

Radipi.toggle="/command?param=echo 'cycle pause' | socat - /tmp/remocon.socket"
Radipi.quit="/quit"

Radipi.speedup="/speed?param=up"
Radipi.speeddown="/speed?param=down"

Radipi.backward="/mpvSocketDelay?param= seek '\"0\" ,\"absolute-percent\"'"
Radipi.back10p="/mpvSocket?param= seek '\"-10\" ,\"relative-percent\"'"
Radipi.back20sec="/mpvSocket?param= seek -20"
Radipi.for20sec="/mpvSocket?param= seek 20"
Radipi.for10p="/mpvSocket?param= seek '\"10\" ,\"relative-percent\"'"
Radipi.forward="/mpvSocketDelay?param= quit 0"
