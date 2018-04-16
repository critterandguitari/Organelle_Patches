import os

def get_immediate_subdirectories(dir):
    if os.path.isdir(dir):
        return [name for name in os.listdir(dir) if os.path.isdir(os.path.join(dir, name))]  
    else :
        return []

