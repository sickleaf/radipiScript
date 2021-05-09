from flask import Flask,render_template,request
from datetime import datetime
import subprocess
import json

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


@app.route('/command')
def command():
    cmd=request.args.get("param")
    print(cmd)
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    mess=o.decode().strip().split('\n')
    return str(mess)


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
    cmd="/home/radipi/Script/setVolume.sh "+volpara
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

    cmd="/home/radipi/Script/getAudioInfo.sh"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    mess=o.decode().strip()
    return str(mess)

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
