from flask import Flask,render_template,request
from datetime import datetime
import subprocess
import json
import sys

app = Flask(__name__)

@app.route('/')
def index():
    return render_template("index.html")

@app.route('/quit')
def stop():
    cmd="/home/radipi/Script/killsound.sh TERM"
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    return "quit"

@app.route('/getAudio')
def getAudio():
    cmd="/home/radipi/Script/getAudioInfo.sh"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout

    mess=o.decode().strip()
    return str(mess)

@app.route('/speed')
def speed():
    prm=request.args.get("param")
    if prm == "up":
        cmd="bash -cvx 'speed=$(bash /home/radipi/Script/mpvSocket.sh /tmp/remocon.socket get_property \\\"speed\\\" | sed \'s/,.*//g\' | cut -d: -f2 | tail -1);speed=$(echo $speed+0.1 | bc | sed \'s/^/0/g\');/home/radipi/Script/mpvSocket.sh /tmp/remocon.socket speed ${speed} 0'"
    else:
        cmd="bash -cvx 'speed=$(bash /home/radipi/Script/mpvSocket.sh /tmp/remocon.socket get_property \\\"speed\\\" | sed \'s/,.*//g\' | cut -d: -f2 | tail -1);speed=$(echo $speed-0.1 | bc | sed \'s/^/0/g\');/home/radipi/Script/mpvSocket.sh /tmp/remocon.socket speed ${speed} 0'"
    print(cmd)
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    print(o)
    return getAudio()




@app.route('/command')
def command():
    cmd=request.args.get("param")
    print(cmd)
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    print(o)
    return getAudio()


@app.route('/radiko')
def radiko():
    killcmd="/home/radipi/Script/killsound.sh TERM 2>&1"
    subprocess.run(killcmd,shell=True,stdout=subprocess.PIPE).stdout

    station=request.args.get("param")
    cmd="/home/radipi/Script/playradiko.sh "+station
    print(cmd)
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout

    cmd="sleep 2 && /home/radipi/Script/getAudioInfo.sh"

    return subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout 


@app.route('/changevol')
def changevol():
    volpara=request.args.get("param")
    cmd="bash /home/radipi/Script/setVolume.sh "+volpara
    print(cmd)
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    mess=o.decode().strip().split('\n')
    return mess[len(mess)-1]

@app.route('/mpvSocket')
def mpvSocket():
    socket=request.args.get("param")
    cmd="/home/radipi/Script/mpvSocket.sh /tmp/remocon.socket "+socket
    print(cmd)
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout

    return getAudio()

@app.route('/mpvSocketDelay')
def mpvSocketDelay():
    socket=request.args.get("param")
    cmd="/home/radipi/Script/mpvSocket.sh /tmp/remocon.socket "+socket
    print(cmd)
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout

    cmd="sleep 2 && /home/radipi/Script/getAudioInfo.sh"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    mess=o.decode().strip()
    return str(mess)

@app.route('/remocon')
def remocon():
    keyID=request.args.get("param")
    cmd="cat /tmp/lircrc | grep " + keyID +" | sed -n 1p | cut -d# -f2- | bash"
    print(cmd)
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    res=o.decode().strip()

    return str(res)

@app.route('/mntRadio')
def mntRadio():
    args=request.args.get("param")
    kyd=request.args.get("keyword")
    cmd="bash /home/radipi/Script/playLocalfile.sh "+args+" "+kyd
    print(cmd)

    # if number = 0, just list result. if not, stop & play
    if " 0 " in args:
        o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
        mess=o.decode().strip()
        mess="<br />".join(mess.split("\n"))
    else:
        discard = stop();
        o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
        cmd="sleep 2 && /home/radipi/Script/getAudioInfo.sh"
        o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
        mess=o.decode().strip()

    return str(mess)

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
