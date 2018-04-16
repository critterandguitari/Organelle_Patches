import cherrypy
import os

current_dir = os.path.dirname(os.path.abspath(__file__))

config = { '/': 
        {
        },
		'/favicon.ico': {
			'tools.staticfile.on': True,
			'tools.staticfile.filename': current_dir + '/static/fav.png'
		},
        '/static/bootstrap.min.css': {
            'tools.staticfile.on': True,
            'tools.staticfile.filename': current_dir + '/static/bootstrap.min.css'
        },
        '/static/fonts' : {
            'tools.staticdir.on': True,
            'tools.staticdir.dir': current_dir + '/static/fonts'
        }
}
base = '/'

class Root(object):
    nnapps = None
    links = ''
    def __init__(self, apps):
        self.apps = apps
        for app in apps : 
            self.links += '<a href="'+app.base+'" class="btn btn-default" role="button" style="margin:6px 0;">'+app.name+'</a></br>'

    @cherrypy.expose
    def index(self):
        return """
<html>
<head>
<title>Organelle Home</title>
<link rel="stylesheet" href="/static/bootstrap.min.css">
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
</head>
<body>

<div style="border:1px solid; border-radius: 6px; padding: 16px; width: 500px; margin:16px auto;">

<h2>Welcome to the Organelle!<h2>

""" + self.links + """
</div>

</body>
</html>
"""


