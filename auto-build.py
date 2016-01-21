import inotify.adapters
import os
import threading
import time

COUNT = -1
RUN = True

def run():
    global COUNT
    
    while RUN:
        time.sleep(1)
        if COUNT == 0:
            make()
            COUNT = -1
        
        if COUNT > 0:
            COUNT = 0

t = threading.Thread(target=run)
t.start()


def make():
    print "Making"
    os.system("latexmk spine.tex")


WRITING_SET = frozenset(('IN_MOVED_TO', 'IN_MODIFY', 'IN_CREATE',
                         'IN_CLOSE_WRITE'))
def is_writing(type_names):
    return bool(WRITING_SET.intersection(type_names))


i = inotify.adapters.Inotify()
i.add_watch('/home/joao/Dropbox/Faculdade/PhD/tese/tex')

while True:
    try:
        for event in i.event_gen():
            if event is not None:
                (header, type_names, watch_path, filename) = event
                if filename == 'spine.tex' and is_writing(type_names):
                    COUNT += 1
                    print COUNT
    except KeyboardInterrupt:
        RUN = False
        break
    except IOError:
        pass
