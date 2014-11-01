import time
import thread
import socket
import OSC
import time, threading
import sys
from pymouse import PyMouse
from pykeyboard import PyKeyboard

m = PyMouse()
k = PyKeyboard()

receive_address = '192.168.1.65', 10000  #for home wiress connection Mattbook
#receive_address = '206.87.218.197', 10000  #for work wiress connection Mattbook
#receive_address = '169.254.25.196', 10000  #for ad hoc wireless MattBook
#receive_address = '169.254.245.198', 10000  #for ad hoc wireless piglet
#receive_address = '127.0.0.1', 3000         #for iPhone simulation

s = OSC.OSCServer(receive_address)
s.addDefaultHandlers()


rotate_sensitivity = 0.8
screen_width = 1200
screen_height = 700 #boundary for full-screen coot

# ------ Mouse controls ---------
global scrollpos
global xlast
global ylast
global ypos
global xpos
global scrollpos
ypos = 500.
xpos = 500.
scrollpos = None

def handler_rotate_xy(addr, tags, args, source):
    global ypos
    global xpos
    if addr=="/RotateView/x":
        #xpos = (args[0]*screen_width)*rotate_sensitivity+screen_width/4
        xpos = (args[0]*screen_width)
        #print args[0]
    elif addr=="/RotateView/y":
        #ypos = (args[0]*screen_height)*rotate_sensitivity+(screen_height/6) - 100
        #print args[0]
        ypos = (args[0]*screen_height+40)
    m.move(xpos, ypos)
    print xpos, ypos


def handler_rotate_xy_activate(addr, tags, args, source):
    global xpos
    global ypos
    if addr=="/RotateView/z":
        if args[0] == 1.0:
            time.sleep(0.01)
            m.press(xpos, ypos, 1)
            #print 'rotate_hold', args[0]
        elif args[0] == 0.0:
            m.release(xpos, ypos, 1) 
            #time.sleep(0.2)
            #print 'rotate_release', args[0]

def handler_translate_xy(addr, tags, args, source):
    global ypos
    global xpos
    if addr=="/TranslateView/x":
        xpos = (args[0]*screen_width)
    elif addr=="/TranslateView/y":
        ypos = (args[0]*screen_height+50)
    m.move(xpos, ypos)

def handler_translate_xy_activate(addr, tags, args, source):
    global xpos
    global ypos
    if addr=="/TranslateView/z":
        if args[0] == 1.0:
            #time.sleep(0.01)
            k.press_key('control')
            currentx, currenty = m.position()
            m.press(currentx, currenty, 1)
            
        elif args[0] == 0.0:
            currentx, currenty = m.position()
            m.release(currentx, currenty, 1) 
            k.release_key('control')

            

def handler_mouse_click(addr, tags, args, source):
    global xpos
    global ypos
    if addr=="/Click/x":
        currentx, currenty = m.position()
        m.click(currentx, currenty, 1)

def handler_zoom(addr, tags, args, source):
    global ypos
    global xpos
    if addr=="/Zoom/x":
        ypos = (args[0]*screen_height+100)
    m.move(xpos, ypos)

def handler_zoom_activate(addr, tags, args, source):
    global xpos
    global ypos
    if addr=="/Zoom/z":
        if args[0] == 1.0:
            #time.sleep(0.15)
            currentx, currenty = m.position()
            m.press(currentx, currenty, 2)
        elif args[0] == 0.0:
            currentx, currenty = m.position()
            m.release(currentx, currenty, 2) 

def handler_2FoFc(addr, tags, args, source):
    if addr=="/_2FoFc/x":
        #scrollvalue = int(args[0])
        print args[0]
        m.scroll(vertical=args[0])


'''
def move_mouse():
    global xpos
    global ypos
    timer = 300
    while timer > 1:
        time.sleep(0.1)
        print "from function", xpos, ypos
        # print 'lala'
        m.drag(xpos, ypos)
        timer -= 1, handler_zoom) # adding ou
        #print timer
thread.start_new_thread(move_mouse, ())
'''

s.addMsgHandler("/RotateView/x", handler_rotate_xy) # adding our function
s.addMsgHandler("/RotateView/y", handler_rotate_xy) # adding our function
s.addMsgHandler("/RotateView/z", handler_rotate_xy_activate) # adding our function
s.addMsgHandler("/TranslateView/x", handler_translate_xy) # adding our function
s.addMsgHandler("/TranslateView/y", handler_translate_xy) # adding our function
s.addMsgHandler("/TranslateView/z", handler_translate_xy_activate) # adding our function
s.addMsgHandler("/Click/x", handler_mouse_click) # adding our function
s.addMsgHandler("/Zoom/x", handler_zoom)
s.addMsgHandler("/Zoom/z", handler_zoom_activate) # adding our function
s.addMsgHandler("/_2FoFc/x", handler_2FoFc) # adding our function

# ----- Key controls -------------

def handler_iPhone_derp(addr, tags, args, source):
    if addr=="/derp":
        print args[0]

def handler_iPhone_slider(addr, tags, args, source):
    if addr=="/slider":
        print args[0]

def handler_AddWater(addr, tags, args, source):
    if addr=="/AddWater/x":
        if args[0] == 1.0:
            k.tap_key('w')

def handler_NextResidue(addr, tags, args, source):
    if addr=="/NextResidue/x":
        if args[0] == 1.0:
            print args[0]
            k.tap_key('space')

def handler_PreviousResidue(addr, tags, args, source):
    if addr=="/PreviousResidue/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('space')
            k.release_key('shift')

def handler_trimSideChain(addr, tags, args, source):
    if addr=="/Trim/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('k')
            k.release_key('shift')

def handler_FillSideChain(addr, tags, args, source):
    if addr=="/FillSideChain/x":
        if args[0] == 1.0:
            k.tap_key('k')

def handler_FlipPeptBond(addr, tags, args, source):
    if addr=="/FlipPeptBond/x":
        if args[0] == 1.0:
            k.tap_key('q')

def handler_TripleRefine(addr, tags, args, source):
    if addr=="/TripleRefine/x":
        if args[0] == 1.0:
            k.tap_key('t')

def handler_GoToBlob(addr, tags, args, source):
    if addr=="/GoToBlob/x":
        if args[0] == 1.0:
            k.tap_key('g')

def handler_AutoFitRotamer(addr, tags, args, source):
    if addr=="/AutoFitRotamer/x":
        if args[0] == 1.0:
            k.tap_key('j')

def handler_ManualRefineRes(addr, tags, args, source):
    if addr=="/ManualRefineRes/x":
        if args[0] == 1.0:
            k.tap_key('r')

def handler_AutoRefineRes(addr, tags, args, source):
    if addr=="/AutoRefineRes/x":
        if args[0] == 1.0:
            k.tap_key('x')

def handler_AddTerminalResidue(addr, tags, args, source):
    if addr=="/AddTerminalResidue/x":
        if args[0] == 1.0:
            k.tap_key('y')

def handler_NeighborsRefine(addr, tags, args, source):
    if addr=="/NeighborsRefine/x":
        if args[0] == 1.0:
            k.tap_key('h')

def handler_ToggleGhosts(addr, tags, args, source):
    if addr=="/ToggleGhosts/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key(';')
            k.release_key('shift')

def handler_ToggleHydrogens(addr, tags, args, source):
    if addr=="/AddWater/x":
        if args[0] == 1.0:
            k.tap_key('[')
        else:
            k.tap_key(']')

def handler_Accept(addr, tags, args, source):
    if addr=="/Accept/x":
        if args[0] == 1.0:
            k.tap_key('return')

def handler_Regularize(addr, tags, args, source):
    if addr=="/Regularize/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('b')
            k.release_key('shift')

#mutate residues

reslist = 'RHKDESTCNQAVILMFYWGP'


def handler_DeleteWater(addr, tags, args, source):
    if addr=="/DeleteWater/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('D')
            k.release_key('shift')

def handler_set2FoFc(addr, tags, args, source):
    if addr=="/set2FoFc/x":
        if args[0] == 1.0:
            k.tap_key('v')


def handler_setFoFc(addr, tags, args, source):
    if addr=="/setFoFc/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('V')
            k.release_key('shift')

def handler_setRef2FoFc(addr, tags, args, source):
    if addr=="/setRef2FoFc/x":
        if args[0] == 1.0:
            k.tap_key('z')


def handler_setRefFoFc(addr, tags, args, source):
    if addr=="/setRefFoFc/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('Z')
            k.release_key('shift')

def handler_setUndo(addr, tags, args, source):
    if addr=="/setUndo/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('a')
            k.release_key('shift')

def handler_undo(addr, tags, args, source):
    if addr=="/undo/x":
        if args[0] == 1.0:
            k.tap_key('s')

def handler_redo(addr, tags, args, source):
    if addr=="/redo/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('s')
            k.release_key('shift')

def handler_AcceptBaton(addr, tags, args, source):
    if addr=="/AcceptBaton/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('f')
            k.release_key('shift')

def handler_TryAnother(addr, tags, args, source):
    if addr=="/TryAnother/x":
        if args[0] == 1.0:
            k.press_key('shift')  
            k.tap_key('h')
            k.release_key('shift')  

def handler_BatonLengthen(addr, tags, args, source):
    if addr=="/BatonLengthen/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('q')
            k.release_key('shift')

def handler_BatonShorten(addr, tags, args, source):
    if addr=="/BatonShorten/x":
        if args[0] == 1.0:
            k.press_key('shift')
            k.tap_key('w')
            k.release_key('shift')


s.addMsgHandler("/AddWater/x", handler_AddWater) # adding our function
s.addMsgHandler("/NextResidue/x", handler_NextResidue) # adding our function
s.addMsgHandler("/PreviousResidue/x", handler_PreviousResidue) # adding our function
s.addMsgHandler("/Trim/x", handler_trimSideChain) # adding our function
s.addMsgHandler("/FlipPeptBond/x", handler_FlipPeptBond)
s.addMsgHandler("/TripleRefine/x", handler_TripleRefine)
s.addMsgHandler("/GoToBlob/x", handler_GoToBlob)
s.addMsgHandler("/AutoFitRotamer/x", handler_AutoFitRotamer)
s.addMsgHandler("/ManualRefineRes/x", handler_ManualRefineRes)
s.addMsgHandler("/AutoRefineRes/x", handler_AutoRefineRes)
s.addMsgHandler("/AddTerminalResidue/x", handler_AddTerminalResidue)
s.addMsgHandler("/NeighborsRefine/x", handler_NeighborsRefine)
s.addMsgHandler("/ToggleGhosts/x", handler_ToggleGhosts)
s.addMsgHandler("/FillSideChain/x", handler_FillSideChain)
s.addMsgHandler("/Accept/x", handler_Accept)
s.addMsgHandler("/DeleteWater/x", handler_DeleteWater)
s.addMsgHandler("/Regularize/x", handler_Regularize)
s.addMsgHandler("/derp", handler_iPhone_derp)
s.addMsgHandler("/slider", handler_iPhone_slider)
s.addMsgHandler("/set2FoFc/x", handler_set2FoFc)
s.addMsgHandler("/setFoFc/x", handler_setFoFc)
s.addMsgHandler("/setRef2FoFc/x", handler_setRef2FoFc)
s.addMsgHandler("/setRefFoFc/x", handler_setRefFoFc)
s.addMsgHandler("/setUndo/x", handler_setUndo)
s.addMsgHandler("/undo/x", handler_undo)
s.addMsgHandler("/redo/x", handler_redo)
s.addMsgHandler("/AcceptBaton/x", handler_AcceptBaton)
s.addMsgHandler("/TryAnother/x", handler_TryAnother)
s.addMsgHandler("/BatonLengthen/x", handler_BatonLengthen)
s.addMsgHandler("/BatonShorten/x", handler_BatonShorten)

st = threading.Thread( target = s.serve_forever )
st.start()


try :
    while 1 :
        time.sleep(5)

except KeyboardInterrupt :
    print "\nClosing OSCServer."
    s.close()
    print "Waiting for Server-thread to finish"
    st.join() ##!!!
    print "Done"