import json
import os
import shutil
import cherrypy

BASE_DIR = "/"

#TODO check all the paths here 
def check_path(path) :
    path = os.path.normpath(path)
    print path
    if path.startswith("/usbdrive") or path.startswith("/sdcard") : return True
    else : return False

def check_and_inc_name(path) :
    newpath = path
    count = 2
    while os.path.isdir(newpath) or os.path.isfile(newpath):
        p, e = os.path.splitext(path)
        newpath = p + " " + str(count) + e
        count += 1

    return newpath

#TODO don't return ok if error what the hell
def rename(old, new):
    src = BASE_DIR + old 
    dst = os.path.dirname(src) + '/' + new
    if src != dst :
        dst = check_and_inc_name(dst)
        os.rename(src, dst)
    return '{"ok":"ok"}'

def create(dst, name):
    dst = BASE_DIR + dst + '/' + name
    dst = check_and_inc_name(dst)
    os.mkdir(dst)
    return '{"ok":"ok"}'

def move(src, dst):
    src = BASE_DIR + src
    dst = BASE_DIR + dst + '/' + os.path.basename(src)  
    dst = check_and_inc_name(dst)
    shutil.move(src, dst)
    return '{"ok":"ok"}'

def unzip(zip_path):
    zip_path = BASE_DIR + zip_path
    zip_parent_folder =os.path.dirname(zip_path)
    os.system("unzip -o \""+zip_path+"\" -d \""+zip_parent_folder+"\" -x '__MACOSX/*'")
    return '{"ok":"ok"}'

def zip(folder):
    folder = BASE_DIR + folder
    zipname = os.path.basename(folder)+".zip"
    if os.path.isdir(folder) :
        os.system("cd \""+os.path.dirname(folder)+"\" && zip -r \""+zipname+"\" \""+os.path.basename(folder)+"\"")
    return '{"ok":"ok"}'

def copy(src, dst):
    src = BASE_DIR + src
    dst = BASE_DIR + dst 
    dst = dst + '/' + os.path.basename(src)
    dst = check_and_inc_name(dst)
    if os.path.isfile(src) :
        shutil.copy(src, dst)
    if os.path.isdir(src) :
        shutil.copytree(src, dst)
    return '{"ok":"ok"}'

def delete(src):
    src = BASE_DIR + src 
    if os.path.isfile(src) :
        os.remove(src)
    if os.path.isdir(src) :
        shutil.rmtree(src)
    return '{"ok":"ok"}'

def get_node(fpath):
    if fpath == '#' :
        return get_files(BASE_DIR)
    else :
        fpath = fpath
        return get_files(BASE_DIR + fpath)

def convert_bytes(num):
    for x in ['bytes', 'KB', 'MB', 'GB', 'TB']:
        if num < 1024.0:
            if x == 'bytes' : return "%d %s" % (int(num), x)
            else : return "%3.1f %s" % (num, x)
        num /= 1024.0

def file_to_dict(fpath):
    return {
        'name': os.path.basename(fpath),
        'children': False,
        'type': 'file',
        'size': str(convert_bytes(os.stat(fpath).st_size)), 
        'path': fpath.split(BASE_DIR,1)[1],
        }

def folder_to_dict(fpath):
    return {
        'name': os.path.basename(fpath),
        'children': True,
        'type': 'folder',
        'path': fpath.split(BASE_DIR,1)[1],
        }

def get_files(rootpath):
    root, folders, files = os.walk(rootpath).next()
    contents = []

    # some reason root is // when rootpath is /, fix it
    if root == "//" : root = "/"

    folders = sorted(folders, key=lambda s: s.lower())
    files = sorted(files, key=lambda s: s.lower())
    # add to the list if they are cool
    for folder in folders :
        if not folder[0] == '.' :
            path = os.path.join(root, folder)
            #if check_path(path):
            contents += [folder_to_dict(path)]
    
    for ffile in files :
        if not ffile[0] == '.' :
            path = os.path.join(root, ffile)
            #if check_path(path):
            contents += [file_to_dict(path)]

    #print json.dumps(contents, indent=4, encoding='utf-8')
    return json.dumps(contents, indent=4, encoding='utf-8')


