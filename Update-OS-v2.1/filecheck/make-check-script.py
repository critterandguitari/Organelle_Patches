import sha1

base = "/usbdrive/Patches/Update-OS-v2.1/"
#base = "/Users/owen/Organelle_Patches_Dev/Update-OS-v2.1/filecheck/"

for l in sha1.sha1 :
    f = base + l[0]
    print "echo checking \""+f+"\""
    print "if openssl sha1 \""+f+"\" | grep \""+l[1]+"\"; then"
    print "  echo \"file checks out\""
    print "else"
    print "  echo \"error 1\""
    print "  exit 1"
    print "fi"

