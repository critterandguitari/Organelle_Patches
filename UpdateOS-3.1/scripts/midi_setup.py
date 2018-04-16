import os
import subprocess
import imp
import sys
import time
import threading

#vars
midiIn = 0
midiOut = 1
midiInGate = 1
midiOutGate = 1
midiDeviceIdx = 0
midiDevices = [ ]
midiDevice = '28:0'

# usb or sd card
user_dir = os.getenv("USER_DIR", "/usbdrive")

# imports
current_dir = os.path.dirname(os.path.abspath(__file__))
og = imp.load_source('og', current_dir + '/og.py')

# UI elements
menu = og.Menu()
banner = og.Alert()

# lock for updating menu
menu_lock = threading.Lock()


def run_cmd(cmd) :
    ret = False
    try:
        ret = subprocess.check_output(['bash', '-c', cmd], close_fds=True)
    except: 
        pass
    return ret


def quit():
    og.end_app()


def update_menu():
    menu_lock.acquire()
    try :
        pass
    finally :
        menu_lock.release()

# bg connection checker
def check_status():
    while True:
        time.sleep(1)
        update_menu()
        og.redraw_flag = True


# build main menu
menu.items = []
menu.header='MIDI Setup'

# start it up
og.start_app()

def getStrVal(key, dval) :
    s = run_cmd("grep '# " + key +",' < "+user_dir+"/patch_loaded.sh| awk -F, ' { print $2 }'").strip()
    if(len(s)>0) :
        return s
    return dval

def getIntVal(key, dval) :
    s = run_cmd("grep '# " + key +",' < "+user_dir+"/patch_loaded.sh| awk -F, ' { print $2 }'").strip()
    if(len(s)>0) :
        return int(s)
    return dval

midiIn=getIntVal('midiIn',0)
midiOut=getIntVal('midiOut',1)
midiInGate=getIntVal('midiInGate',1)
midiOutGate=getIntVal('midiOutGate',1)
midiDevice=getStrVal('midiDevice',"28:0")

def midiInGateSelect():
        global midiInGate
        og.clear_screen()
        og.println(1,"Input")
        ms = "Enabled" if midiInGate>0 else "Disabled"
        og.println(2,ms)
        og.flip()
        og.enc_but_flag = False
        while True :
            og.enc_input()
            if (og.enc_turn_flag): 
                if(og.enc_turn and midiInGate==0): 
                    midiInGate=1
                elif(og.enc_turn==0 and midiInGate==1):
                    midiInGate=0
                og.clear_screen()
                og.println(1,"Input")
                ms = "Enabled" if midiInGate>0 else "Disabled"
                og.println(2,ms)
                og.flip()
            elif (og.enc_but_flag and og.enc_but==1):
                print midiInGate
                menu.items[menu.selection][0] = 'Midi In : ' + ("Enabled" if midiInGate>0 else "Disabled"); 
                break

def midiOutGateSelect():
        global midiOutGate
        og.clear_screen()
        og.println(1,"Output")
        ms = "Enabled" if midiOutGate>0 else "Disabled"
        og.println(2,ms)
        og.flip()
        og.enc_but_flag = False
        while True :
            og.enc_input()
            if (og.enc_turn_flag): 
                if(og.enc_turn and midiOutGate==0): 
                    midiOutGate=1
                elif(og.enc_turn==0 and midiOutGate==1):
                    midiOutGate=0
                og.clear_screen()
                og.println(1,"Output")
                ms = "Enabled" if midiOutGate>0 else "Disabled"
                og.println(2,ms)
                og.flip()
            elif (og.enc_but_flag and og.enc_but==1):
                print midiOutGate
                menu.items[menu.selection][0] = 'Midi Out : ' + ("Enabled" if midiOutGate>0 else "Disabled"); 
                break


def midiInSelect():
        global midiIn
        og.clear_screen()
        og.println(1,"Input Channel")
        ms = str(midiIn) if midiIn>0 else "Omni"
        og.println(2,ms)
        og.flip()
        og.enc_but_flag = False
        while True :
            og.enc_input()
            if (og.enc_turn_flag): 
                if(og.enc_turn and midiIn<16) : 
                    midiIn+=1
                elif(og.enc_turn==0 and midiIn>0):
                    midiIn-=1
                og.clear_screen()
                og.println(1,"Input Channel")
                ms = str(midiIn) if midiIn>0 else "Omni"
                og.println(2,ms)
                og.flip()
            elif (og.enc_but_flag and og.enc_but==1):
                print midiIn
                menu.items[menu.selection][0] = 'Midi In Ch.: ' + (str(midiIn) if midiIn>0 else "Omni")
                break

def midiOutSelect():
        global midiOut
        og.clear_screen()
        og.println(1,"Output Channel")
        og.println(2,str(midiOut))
        og.flip()
        og.enc_but_flag = False
        while True :
            og.enc_input()
            if (og.enc_turn_flag): 
                if(og.enc_turn and midiOut<16) : 
                    midiOut+=1
                elif(og.enc_turn==0 and midiOut>1):
                    midiOut-=1
                og.clear_screen()
                og.println(1,"Output Channel")
                og.println(2,str(midiOut))
                og.flip()
            elif (og.enc_but_flag and og.enc_but==1):
                print midiOut
                menu.items[menu.selection][0] = 'Midi Out Ch.: ' + (str(midiOut))
                break


def midiDeviceSelect():
    global midiDevice,midiDeviceIdx,midiDevices
    devices = run_cmd("aplaymidi -l")
    
    #remove empty lines, and header
    midiDevices = [ x for x in devices.split("\n") if not len(x)==0]
    if len(midiDevices)>0 : midiDevices.pop(0);

    og.clear_screen()
    og.println(1,"Midi Device")
    midiDeviceIdx=0
    print(midiDevices)
    for x in midiDevices:
        #print(midiDevices[midiDeviceIdx][9:42].strip() + midiDevices[midiDeviceIdx][4:8].strip())
        if midiDevice == (midiDevices[midiDeviceIdx][9:42].strip() + ":" + midiDevices[midiDeviceIdx][4:8].strip()) : break
        midiDeviceIdx+=1

    if midiDeviceIdx>=len(midiDevices): midiDeviceIdx=0

    device = midiDevices[midiDeviceIdx][42:].strip()  if len(midiDevices)>0 else "None"
    og.println(2,device)
    og.flip()
    og.enc_but_flag = False
    while True :
        og.enc_input()
        if (og.enc_turn_flag and len(midiDevices)>0): 
            if(og.enc_turn and midiDeviceIdx < len(midiDevices)-1) : 
                midiDeviceIdx+=1
            elif(og.enc_turn==0 and midiDeviceIdx>0):
                midiDeviceIdx-=1
            og.clear_screen()
            og.println(1,"Midi Device")
            device = midiDevices[midiDeviceIdx][42:].strip()
            og.println(2,device)
            og.flip()
        elif (og.enc_but_flag and og.enc_but==1):
            if(len(midiDevices)==0): midiDevice = "28:0"
            else: midiDevice = midiDevices[midiDeviceIdx][9:42].strip() + ":" + midiDevices[midiDeviceIdx][4:8].strip()
            print midiDevice
            menu.items[menu.selection][0] = 'Midi Device: ' + midiDevice
            break


def save():
    og.clear_screen()
    og.flip()
    f = open(user_dir + "/patch_loaded.sh", "w")
    # write parameters for possible reading
    f.write("# MIDI PARAMETERS:START\n")
    f.write("# midiIn," + str(midiIn) + "\n")
    f.write("# midiOut," + str(midiOut) + "\n")
    f.write("# midiInGate,"  + str(midiInGate) +"\n")
    f.write("# midiOutGate," + str(midiOutGate) +"\n")
    f.write("# midiDevice," + str(midiDevice) + "\n")
    f.write("# MIDI PARAMETERS:END\n")
    # write script to be executed
    f.write("oscsend localhost 4000 /midiInCh i " + str(midiIn) + "\n")
    f.write("oscsend localhost 4000 /midiOutCh i " + str(midiOut) + "\n")
    f.write("oscsend localhost 4000 /midiInGate i " + str(midiInGate) + "\n")
    f.write("oscsend localhost 4000 /midiOutGate i " + str(midiOutGate) + "\n")
    f.write("aconnect \"" + str(midiDevice) + "\" \"Pure Data:0\"\n")
    f.write("aconnect \"Pure Data:1\" \"" + str(midiDevice) + "\"\n")
    f.close()
    os.system("aconnect -x")
    os.system("chmod +x "+user_dir+"/patch_loaded.sh")
    og.clear_screen()
    og.println(1,"Midi configuration")
    og.println(2,"SAVED")
    og.flip()
    os.system('oscsend localhost 4001 /midiConfig i 1')
    time.sleep(0.5)
    pass



menu.items.append(['Midi In : ' + ("Enabled" if midiInGate>0 else "Disabled") , midiInGateSelect])
menu.items.append(['Midi In Ch.: ' + (str(midiIn) if midiIn>0 else "Omni") , midiInSelect])
menu.items.append(['Midi Out : ' + ("Enabled" if midiOutGate>0 else "Disabled") , midiOutGateSelect])
menu.items.append(['Midi Out Ch.: ' + (str(midiOut)) , midiOutSelect])
menu.items.append(['Midi Device: ' + midiDevice, midiDeviceSelect])
menu.items.append(['Save', save])
menu.items.append(['< Home', quit])
menu.selection = 0

# bg thread
menu_updater = threading.Thread(target=check_status)
menu_updater.daemon = True # stop the thread when we exit

og.redraw_flag = True

# start thread to update connection status
menu_updater.start()

# enter menu
menu.perform()



