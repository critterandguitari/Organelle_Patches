#!/bin/bash

echo checking "/usbdrive/Patches/Update-OS-v2.1/root/.bash_profile"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/.bash_profile" | grep "d071d7aba87e92e2e14a4fa74bc82eb3db8249fa"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/.jwmrc"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/.jwmrc" | grep "2786c9a615bed471969c3d3177e6f5d31225754a"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/.pdsettings"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/.pdsettings" | grep "5199f695c64c321e17bd4d8945e50bcc1c6407f7"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/mother"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/mother" | grep "5d04fefa1da06cb2399b618517019196da4c50c6"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/mother.pd"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/mother.pd" | grep "b950cb36341cf9887d89aa19767f0e87f02a4da1"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/check-for-usb-drive.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/check-for-usb-drive.sh" | grep "fe629b5abbcf9986fc8f57ca8d2edad4aa5f0d9f"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/check-for-x.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/check-for-x.sh" | grep "6d62613fa54cb34f4bdcbaea0606c624d83d916f"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/eject.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/eject.sh" | grep "4481b5b88f6faf1498880dd308660a2cff562852"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/get-usb-drive-dev.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/get-usb-drive-dev.sh" | grep "835308d9d9d02ad2c83635e14002849e9202dc54"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/info.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/info.sh" | grep "3566c99e099ac75d6ef9163a877794fda64dc0ec"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/killmother.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/killmother.sh" | grep "f66af03751c4380051f49de3331b804a07838ee3"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/killpd.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/killpd.sh" | grep "16eec494fc49058a1617536ea92e2e23cf006f6f"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/midi-config.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/midi-config.sh" | grep "185bd735119a3d94dfc2ea2ec6dd384cc179e4ef"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/mount.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/mount.sh" | grep "06c011e02864412b677b72ac088e52cb49cad9b6"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/oscdump2"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/oscdump2" | grep "26bca988014be9ae7ea3c917681b40499f301933"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/play-sound.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/play-sound.sh" | grep "f036d9de81908249da2effed63aab3030b70b103"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/reload.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/reload.sh" | grep "3937d83543ce2105ffd35c872413a09cc0b77e3e"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/remount-ro.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/remount-ro.sh" | grep "9d3e4925fe6571c95afeddf7984e405ba9cd0fd0"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/remount-rw.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/remount-rw.sh" | grep "26a93c178b75a4573e97c51b44dbc74ca9656e6a"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/restart-mother.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/restart-mother.sh" | grep "219e0ae6cf6ed27bab71450f3864956ecfb121b4"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/save-new-patch.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/save-new-patch.sh" | grep "a2ac4510e01205b40855d2fd7b96028348ac3e61"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/save-patch.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/save-patch.sh" | grep "36ca7776a950f5633cb7415bb9c4174a2a19b3d1"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/savepre.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/savepre.sh" | grep "e759bed80b0719b2380bbfadaa62bde5f6c2a39d"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/set-midi-ch.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/set-midi-ch.sh" | grep "956d0066f5e8875d77698f13d9c391cee3c39afb"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/setup.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/setup.sh" | grep "3e157cfd4191e445338a8a5b94fdea359d8c9fc4"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/shutdown.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/shutdown.sh" | grep "3494fbc21279a6e3b04054b02cc3c1b1cc7e469d"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/splash.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/splash.sh" | grep "fa10c21893e4d664892c213b2b9ff9be792d0d58"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/start-gui.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/start-gui.sh" | grep "064a466e5843eb696c3c6c776a6ae42dfb53be12"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/start-mother.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/start-mother.sh" | grep "718cf7e69aa95adc9ac07790d275c3fd7b9c6aa8"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/stop-gui.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/stop-gui.sh" | grep "0b52876310247c3a2e5160aea12ee236257e776f"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/usb-dev-removed.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/usb-dev-removed.sh" | grep "417f4c48ebdee6ce90776f97978ff1f8cb31fda3"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/welcome.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/welcome.sh" | grep "d477ddf437ae0781d18de41411f7f292f5b5a6b2"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/scripts/wifi-config.sh"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/scripts/wifi-config.sh" | grep "a55a40e686b2b79d3dc0bf21af39a89939b86b0f"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi
echo checking "/usbdrive/Patches/Update-OS-v2.1/root/version"
if openssl sha1 "/usbdrive/Patches/Update-OS-v2.1/root/version" | grep "da51fa3f73e561cf695cbcf67e9d92d801038cd8"; then
  echo "file checks out"
else
  echo "error 1"
  exit 1
fi

# all good
exit 0
