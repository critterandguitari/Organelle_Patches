import os
import subprocess

log_file = os.getenv("USER_DIR", "/usbdrive") + "/wifi_log.txt"

# states
NOT_CONNECTED = 0
CONNECTING = 1
CONNECTED = 2
DISCONNECTING = 3
CONNECTION_ERROR = 4

# current state
state = NOT_CONNECTED
connecting_timer = 0

# AP 
AP_STOPPED = 0
AP_RUNNING = 1
ap_state = AP_STOPPED 


# webserver
WEB_SERVER_STOPPED = 0
WEB_SERVER_RUNNING = 1
web_server_state = WEB_SERVER_STOPPED 

current_net = ''
ip_address = ''

# returns output if exit code 0, false otherwise
def run_cmd(cmd) :
    ret = False
    try:
        ret = subprocess.check_output(['bash', '-c', cmd], close_fds=True)
    except: pass
    return ret

# returns true or false on exit status
def run_cmd_check(cmd) :
    ret = False
    try:
        subprocess.check_output(['bash', '-c', cmd], close_fds=True)
        ret = True
    except: pass
    return ret

def start_web_server():
    global web_server_state
    run_cmd('systemctl start cherrypy')
    web_server_state = WEB_SERVER_RUNNING

def stop_web_server():
    global web_server_state
    run_cmd('systemctl stop cherrypy')
    web_server_state = WEB_SERVER_STOPPED


def start_ap_server():
    global ap_state
    run_cmd('systemctl start createap')
    ap_state = AP_RUNNING

def stop_ap_server():
    global ap_state
    run_cmd('systemctl stop createap')
    ap_state = AP_STOPPED


# true or false connected with ip address
# updates ip and current network when connected
def wifi_connected():
    global ap_state,ip_address, current_net
    ret = False
    if ap_state == AP_RUNNING :
        ip_address = "192.168.12.1"
        current_net = "Organelle"
        return True

    try :
        wifi_info = run_cmd('wpa_cli -i wlan0 status').splitlines()
        if (any("ip_address" in s for s in wifi_info)):
            update_network_info(wifi_info)
            ret = True
    except : pass
    return ret

# get current wifi IP and ssid when connected
# passed the output of wpa_cli status
def update_network_info(info):
    global ip_address, current_net
    try : ip_address = [s for s in info if s.startswith('ip_address')][0][11:]
    except : pass
    try : current_net = [s for s in info if s.startswith('ssid')][0][5:]
    except : pass

# get initial connection state and ip and ssid
def initialize_state():
    global state, web_server_state, ap_state
    
    # wifi state on startup
    if wifi_connected() : 
        state = CONNECTED
    else : state = NOT_CONNECTED

    # web server state on startup
    if (run_cmd_check('systemctl status cherrypy')) : web_server_state = WEB_SERVER_RUNNING
    else : web_server_state = WEB_SERVER_STOPPED

    # ap state on startup
    if (run_cmd_check('systemctl status createap')) : ap_state = AP_RUNNING
    else : ap_state = AP_STOPPED

# assume this is called 1 / sec from the bg thread
def update_state() :
    global state, connecting_timer, web_server_state, ap_state

    # wifi states
    if (state == NOT_CONNECTED):
        if wifi_connected() : state = CONNECTED
    elif (state == CONNECTING) : 
        if wifi_connected() : 
            state = CONNECTED
        else :
            connecting_timer += 1
            if (connecting_timer > 30) : state = CONNECTION_ERROR
    #elif (state == CONNECTED): do nothing
    elif (state == DISCONNECTING): state = NOT_CONNECTED
    #elif (state == CONNECTION_ERROR):  do nothing

    # web server states
    if (run_cmd_check('systemctl status cherrypy')) : web_server_state = WEB_SERVER_RUNNING
    else : web_server_state = WEB_SERVER_STOPPED

    # ap statu=e
    if (run_cmd_check('systemctl status createap')) : ap_state =  AP_RUNNING
    else : ap_state = AP_STOPPED


# shut everything off
def disconnect_all() :
    global state
    state = DISCONNECTING
    run_cmd("wpa_cli -i wlan0 terminate >> "+log_file+" 2>&1")
    run_cmd("dhcpcd -b -x wlan0 >> "+log_file+" 2>&1")
    run_cmd("/root/scripts/create_ap --stop wlan0 >> "+log_file+" 2>&1")   

# shut
def connect(ssid, pw) :
    global state, connecting_timer, current_net

    # disconnect everything
    disconnect_all()
 
    # restart log
    run_cmd("echo WIFI LOG > " + log_file)
   
    # update state
    state = CONNECTING
    connecting_timer = 0
    current_net = ssid

    run_cmd("ip link set wlan0 up >> "+log_file+" 2>&1")
    run_cmd("wpa_supplicant -B -D nl80211,wext -i wlan0 -c <(cat <(echo ctrl_interface=/var/run/wpa_supplicant) <(wpa_passphrase \""+ssid+"\" \""+pw+"\")) >> "+log_file+" 2>&1") 
    run_cmd("dhcpcd -b wlan0 >> "+log_file+" 2>&1")


