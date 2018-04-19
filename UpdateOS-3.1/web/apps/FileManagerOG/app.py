import os.path
import time
import glob
import json
import cherrypy
import urllib
import time
import socket
from cherrypy.lib import static
import imp


current_dir = os.path.dirname(os.path.abspath(__file__))

file_operations = imp.load_source('file_operations', current_dir + '/file_operations.py')

def get_immediate_subdirectories(dir) :
    return [name for name in os.listdir(dir)
            if os.path.isdir(os.path.join(dir, name))]

config = { '/': 
        {
 		'tools.staticdir.on': True,
		'tools.staticdir.dir': current_dir + '/static/',
		'tools.staticdir.index': 'index.html',
        }
}
base = '/files'
name = 'Patch Manager'

class Root():

    def tester(self, name):
        return "TESTdf"
        print "cool"
    tester.exposed = True

    def flash(self):
        os.system("oscsend localhost 4001 /led/flash i 4")
        return "done"
    flash.exposed = True

    def resync(self):
        os.system("oscsend localhost 4001 /reload i 1")
        return "done"
    resync.exposed = True

    def media(self, fpath, cb):
        cherrypy.response.headers['Cache-Control'] = "no-cache, no-store, must-revalidate"
        cherrypy.response.headers['Pragma'] = "no-cache"
        cherrypy.response.headers['Expires'] = "0"
        src = file_operations.BASE_DIR + fpath
        return static.serve_file(src)
    media.exposed = True

    def download(self, fpath, cb):
        src = file_operations.BASE_DIR + fpath
        dl = open(src, 'r').read()
        fname = os.path.basename(fpath)
        cherrypy.response.headers['content-type']        = 'application/octet-stream'
        cherrypy.response.headers['content-disposition'] = 'attachment; filename={}'.format(fname)
        return dl
    download.exposed = True

    def upload(self, dst, **fdata):
        upload = fdata['files[]']
        folder = dst
        filename = upload.filename
        size = 0
        filepath = file_operations.BASE_DIR + folder + '/' + filename 
        filepath = file_operations.check_and_inc_name(filepath)
        with open(filepath, 'wb') as newfile:
            while True:
                data = upload.file.read(8192)
                if not data:
                    break
                size += len(data)
                newfile.write(data)
        print "saved file, size: " + str(size)
        p, ext = os.path.splitext(filepath)
        cherrypy.response.headers['Content-Type'] = "application/json"
        return '{"files":[{"name":"x","size":'+str(size)+',"url":"na","thumbnailUrl":"na","deleteUrl":"na","deleteType":"DELETE"}]}'
        
    upload.exposed = True
  
    def fmdata(self, **data):
        
        ret = ''
        if 'operation' in data :
            cherrypy.response.headers['Content-Type'] = "application/json"
            if data['operation'] == 'get_node' :
                return file_operations.get_node(data['path'])
            if data['operation'] == 'create_node' :
                return file_operations.create(data['path'], data['name'])
            if data['operation'] == 'rename_node' :
                return file_operations.rename(data['path'], data['name'])
            if data['operation'] == 'delete_node' :
                return file_operations.delete(data['path'])
            if data['operation'] == 'move_node' :
                return file_operations.move(data['src'], data['dst'])
            if data['operation'] == 'copy_node' :
                return file_operations.copy(data['src'], data['dst'])
            if data['operation'] == 'unzip_node' :
                return file_operations.unzip(data['path'])
            if data['operation'] == 'download_node' :
                return file_operations.download(data['path'])
            if data['operation'] == 'zip_node' :
                return file_operations.zip(data['path'])
              
        else :
            cherrypy.response.headers['Content-Type'] = "application/json"
            return "no operation specified"

    fmdata.exposed = True


