from flask import Flask,render_template,request
from datetime import datetime
import subprocess
import json
import re
import time

app = Flask(__name__)

@app.route('/')
def index():
    return render_template("index.html")

@app.route('/quit')
def stop():
    cmd="/home/radipi/Script/killsound.sh TERM"
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    cmd="echo autoPlay=off | tee /home/radipi/Script/radioMode"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    return "quit"

@app.route('/getAudio')
def getAudio():
    cmd="/home/radipi/Script/getAudioInfo.sh"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout

    mess=o.decode().strip()
    mess="<br />".join(mess.split("\n"))
    return str(mess)

@app.route('/setList')
def setList():
    stationInfo=request.args.get("param")

    cmd="/home/radipi/Script/playStreaming.sh show '' "+stationInfo+" | cut -d, -f-2"

    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout

    mess=o.decode().strip()
    return str(mess)


@app.route('/command')
def command():
    cmd=request.args.get("param")
    print(cmd)
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    return getAudio()

@app.route('/setConfig')
def setConfig():
    cmd=request.args.get("param")
    print(cmd)
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout

    mess=o.decode().strip()
    mess="<br />".join(mess.split("\n"))
    return str(mess)


@app.route('/radiko')
def radiko():
    killcmd="/home/radipi/Script/killsound.sh TERM 2>&1"
    subprocess.run(killcmd,shell=True,stdout=subprocess.PIPE).stdout

    station=request.args.get("param")
    val=request.args.get("value")

    if not val:
 	   cmd="/home/radipi/Script/playradiko.sh "+station+" 2>&1"
    else:
 	   cmd="/home/radipi/Script/playradiko.sh "+val+" 2>&1"

    print(cmd)
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout

    cmd="sleep 2"
    subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout 

    return getAudio()

@app.route('/streaming')
def streaming():
    killcmd="/home/radipi/Script/killsound.sh TERM 2>&1"
    subprocess.run(killcmd,shell=True,stdout=subprocess.PIPE).stdout

    ID=request.args.get("param")
    setList=request.args.get("setList")
    streamingID=request.args.get("streamingID")

    if not streamingID:
 	   cmd="/home/radipi/Script/playStreaming.sh "+ID+" '' "+setList+" 2>&1"
    else:
 	   cmd="/home/radipi/Script/playStreaming.sh "+streamingID+" '' "+setList+" 2>&1"

    print(cmd)
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout

    cmd="sleep 2"
    subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout 

    return getAudio()



@app.route('/mntRadio')
def mntRadio():
    path=request.args.get("param")
    val=request.args.get("value")
    num=request.args.get("numbers")
    sort=request.args.get("sort")
    displayFlag=request.args.get("displayFlag")

    # val is blank, AND display checked, override displayFlag (incert blank for $4)
    if val == ""  and displayFlag == "true":
        displayFlag="'' yes"

    cmd="bash /home/radipi/Script/playLocalfile.sh "+path+" "+num+" "+sort+" "+val+" "+displayFlag
    print(cmd)
    
    # if number = 0, just list result. if not, stop & play
    if int(num) == 0:
        o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
        mess=o.decode().strip()
        mess="<br />".join(mess.split("\n"))
    else:
        discard = stop();
        o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
        cmd2="sleep 2 && /home/radipi/Script/getAudioInfo.sh"
        o = subprocess.run(cmd2,shell=True,stdout=subprocess.PIPE).stdout
        mess=o.decode().strip()
        mess="<br />".join(mess.split("\n"))
    return str(mess)


@app.route('/fmtuner')
def fmtuner():
    scriptName=request.args.get("param")
    freq=request.args.get("value")
    num=request.args.get("numbers")
    sort=request.args.get("sort")

    if not freq:
      cmd="/home/radipi/Script/" + scriptName
      o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
      mess=o.decode().strip()
      mess="<br />".join(mess.split("\n"))
      return str(mess)
    
    else:
      discard = stop();
      cmd="/home/radipi/Script/" + scriptName + " " + freq
      o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
      return "fmtuner[" + freq + "]"

@app.route('/autoPlay')
def autoPlay():
    mode=request.args.get("param")
    
    cmd="echo autoPlay=" + mode + " | tee /home/radipi/Script/radioMode"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    cmd="/home/radipi/Script/saveSpreadLocal.sh 2>&1 > /dev/null; /home/radipi/Script/autoPlayByTime.sh /tmp/sheet1 true true"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    mess=o.decode().strip()
    mess="<br />".join(mess.split("\n"))
    return str(mess)

@app.route('/timetable')
def timetable():
    timetable=request.args.get("param")
    channel=request.args.get("ch")
   
    cmd="/home/radipi/Script/autoPlayByTime.sh " + timetable
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    return "channel[" + channel+ "]"

@app.route('/timefree')
def timefree():
    killcmd="/home/radipi/Script/killsound.sh TERM 2>&1"
    subprocess.run(killcmd,shell=True,stdout=subprocess.PIPE).stdout

    scriptName=request.args.get("param")
    IDorURL=request.args.get("value")
    duration=request.args.get("numbers")
    ymdhms=request.args.get("ymdhms")
    httpPattern="https?://[\w/:%#!\$&\?\(\)~\.=\+\-]+"

    # adapt for 3 pattern with timefree.sh

    # if datetime-local is set, remove ":" "," "T"
    if ymdhms != "":
       ymdhms=re.sub(r"[\:\-T]","",ymdhms)+"00"

    # IDorURL(arg 1) must be speceified
    if IDorURL != "":
       ###IDorURL=IDorURL.replace('!','\!')
       ###IDorURL=re.sub("!","\!",IDorURL)

       start_time = time.perf_counter()

       # if IDorURL is URL, extract only radiko URL
       if re.match("http",IDorURL):
            IDorURL=re.findall(httpPattern,IDorURL)[0]

       # make args for timefree.sh
       args=" '"+ IDorURL + "' " + duration + " " + ymdhms;
       cmd="/home/radipi/Script/" + scriptName + args;
       print(cmd)

       o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout

       execution_time = time.perf_counter() - start_time

       if int(execution_time) > 3:
          mess=cmd
       else:
          mess=o.decode().strip()
          mess="<br />".join(mess.split("\n"))
    else:
       mess="value is missing. specify radiko URL or stationID.";

    return str(mess)

@app.route('/changevol')
def changevol():
    volpara=request.args.get("param")
    cmd="/home/radipi/Script/setVolume.sh "+volpara
    print(cmd)
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    mess=o.decode().strip().split('\n')
    return mess[len(mess)-1]

@app.route('/mpvSocket')
def mpvSocket():
    socket=request.args.get("param")
    cmd="/home/radipi/Script/mpvSocket.sh "+socket
    print(cmd)
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout

    return getAudio()

@app.route('/mpvSocketDelay')
def mpvSocketDelay():
    socket=request.args.get("param")
    cmd="/home/radipi/Script/mpvSocket.sh "+socket
    print(cmd)
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout

    cmd="sleep 2"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout

    return getAudio()

@app.route('/random')
def random():
    cmd="cat /tmp/lircrc | grep -v ^$ | grep mpv | shuf | head -1"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    mess=o.decode().strip().split('#')

    o = subprocess.Popen(mess[1],shell=True,stdout=subprocess.PIPE).stdout
    return mess[0]

@app.route('/hello')
def hello():
    hello = "Hello world!<br>"
    time = str(datetime.now())
    return hello+time


if __name__ == "__main__":
    app.run(host="0.0.0.0")
