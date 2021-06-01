import cwiid, time
import subprocess
import os
import errno
import configparser
import traceback

commandfile="lircrc"
killscript="/home/radipi/Script/killsound.sh"

configfile = "settingMote"
config = configparser.ConfigParser()

#[DEFAULT]
#BTN_UP=volup
#BTN_DOWN=voldown
#BTN_LEFT=
#BTN_RIGHT=
#BTN_A=decide
#BTN_B=broadSW
#BTN_PLUS=volup
#BTN_MINUS=voldown
#BTN_1=
#BTN_2=

if not os.path.exists(configfile):
    print ('\n---\nCONFIGFILE NOT FOUND.\nmake configfile('+configfile+') at same directory with python script.\n---\n')
    raise FileNotFoundError(errno.ENOENT, os.strerror(errno.ENOENT), configfile)

config.read(configfile,encoding="utf-8")

#config["DEFAULT"][BTN_UP]

button_delay = 0.1
connectTry=3


def connect():
    global wii
    try:
        time.sleep(1)
        wii=cwiid.Wiimote()
    except:
        return False
    return True

print ('Please press buttons 1 + 2 on your Wiimote now ...')

## This code attempts to connect to your Wiimote and if it fails the program quits
#try:
#  wii=cwiid.Wiimote()
#except RuntimeError:
#  print ("Cannot connect to your Wiimote. Run again and make sure you are holding buttons 1 + 2!")
#  #print(traceback.print_stack())
#  exit()

result=False

for i in range(connectTry):
    print("[%d/%d]connecting..." % (i+1,connectTry))
    result=connect()
    if result:
        print ("connected!")
        break;

if not result:
  print ("Cannot connect to your Wiimote. Run again and make sure you are holding buttons 1 + 2!")
  exit()

print ('for disconnect and quit, press HOME button.\n')

time.sleep(1)

wii.rpt_mode = cwiid.RPT_BTN

led=0
led ^= cwiid.LED1_ON
wii.led=led

battery = wii.state["battery"]
if (battery <= 30):
    print('change battery.')

while True:

  buttons = wii.state['buttons']
  battery = wii.state["battery"]

  # Detects whether + and - are held down and if they are it quits the program
  if (buttons - cwiid.BTN_HOME == 0):
    print ('\nClosing connection ...\n')
    # NOTE: This is how you RUMBLE the Wiimote
    cmd=killscript+" TERM"
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    time.sleep(1)
    exit(wii)

  # The following code detects whether any of the Wiimotes buttons have been pressed and then prints a statement to the screen!)
  if (buttons & cwiid.BTN_LEFT):
    print ('Left pressed\n')
    #print (config["DEFAULT"]["BTN_LEFT"])
    cmd="cat "+ commandfile+ " | grep "+ config["DEFAULT"]["BTN_LEFT"]+ " | sed -n 1p | cut -d# -f2- | bash"
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    #print("[Run] > "+cmd)
    #print (o.decode().strip().split('\n'))
    time.sleep(button_delay)

  if(buttons & cwiid.BTN_RIGHT):
    print ('Right pressed\n')
    #print (config["DEFAULT"]["BTN_RIGHT"])
    cmd="cat "+ commandfile+ " | grep "+ config["DEFAULT"]["BTN_RIGHT"]+ " | sed -n 1p | cut -d# -f2- | bash"
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    #print("[Run] > "+cmd)
    #print (o.decode().strip().split('\n'))
    time.sleep(button_delay)

  if (buttons & cwiid.BTN_UP):
    print ('Up pressed\n')
    #print (config["DEFAULT"]["BTN_UP"])
    cmd="cat "+ commandfile+ " | grep "+ config["DEFAULT"]["BTN_UP"]+ " | sed -n 1p | cut -d# -f2- | bash"
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    #print("[Run] > "+cmd)
    #print (o.decode().strip().split('\n'))
    time.sleep(button_delay)

  if (buttons & cwiid.BTN_DOWN):
    print ('Down pressed\n')
    #print (config["DEFAULT"]["BTN_DOWN"])
    cmd="cat "+ commandfile+ " | grep "+ config["DEFAULT"]["BTN_DOWN"]+ " | sed -n 1p | cut -d# -f2- | bash"
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    #print("[Run] > "+cmd)
    #print (o.decode().strip().split('\n'))
    time.sleep(button_delay)

  if (buttons & cwiid.BTN_A):
    print ('Button A pressed\n')
    #print (config["DEFAULT"]["BTN_A"])
    cmd="cat "+ commandfile+ " | grep "+ config["DEFAULT"]["BTN_A"]+ " | sed -n 1p | cut -d# -f2- | bash"
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    #print("[Run] > "+cmd)
    time.sleep(button_delay)


  if (buttons & cwiid.BTN_B):
    print ('Button B pressed\n')
    #print (config["DEFAULT"]["BTN_B"])
    cmd='cat '+ commandfile+ ' | grep '+ config["DEFAULT"]["BTN_B"]+ ' | sed -n 1p | cut -d# -f2- | bash'
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    #print("[Run] > "+cmd)
    time.sleep(button_delay)

  if (buttons & cwiid.BTN_HOME):
    wii.rpt_mode = cwiid.RPT_BTN | cwiid.RPT_ACC
    check = 0
    while check == 0:
      print(wii.state['acc'])
      time.sleep(0.01)
      check = (buttons & cwiid.BTN_HOME)
    time.sleep(button_delay)

  if (buttons & cwiid.BTN_PLUS):
    print ('Plus Button pressed\n')
    #print (config["DEFAULT"]["BTN_PLUS"])
    cmd="cat "+ commandfile+ " | grep "+ config["DEFAULT"]["BTN_PLUS"]+ " | sed -n 1p | cut -d# -f2- | bash"
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    #print("[Run] > "+cmd)
    #print (o.decode().strip().split('\n'))
    time.sleep(button_delay)

  if (buttons & cwiid.BTN_MINUS):
    print ('Minus Button pressed\n')
    #print (config["DEFAULT"]["BTN_MINUS"])
    cmd="cat "+ commandfile+ " | grep "+ config["DEFAULT"]["BTN_MINUS"]+ " | sed -n 1p | cut -d# -f2- | bash"
    o = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE).stdout
    #print("[Run] > "+cmd)
    #print (o.decode().strip().split('\n'))
    time.sleep(button_delay)

  if (buttons & cwiid.BTN_1):
    print ('Button 1 pressed\n')
    #print (config["DEFAULT"]["BTN_1"])
    cmd="cat "+ commandfile+ " | grep "+ config["DEFAULT"]["BTN_1"]+ " | sed -n 1p | cut -d# -f2- | bash"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    #print("[Run] > "+cmd)
    print (o.decode().strip().split('\n'))
    time.sleep(button_delay)

  if (buttons & cwiid.BTN_2):
    print ('Button 2 pressed\n')
    #print (config["DEFAULT"]["BTN_2"])
    cmd="cat "+ commandfile+ " | grep "+ config["DEFAULT"]["BTN_2"]+ " | sed -n 1p | cut -d# -f2- | bash"
    o = subprocess.run(cmd,shell=True,stdout=subprocess.PIPE).stdout
    #print("[Run] > "+cmd)
    print (o.decode().strip().split('\n'))
    time.sleep(button_delay)
