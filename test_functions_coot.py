
def key_binding_func_50():
    active_atom = active_residue()
    if (not active_atom):
        add_status_bar_text("No active residue")
    else:
        imol      = active_atom[0]
        chain_id  = active_atom[1]
        res_no    = active_atom[2]
        ins_code  = active_atom[3]
        atom_name = active_atom[4]
        alt_conf  = active_atom[5]
        f = open("/Users/matt/Dropbox/programming/cootControl/output_active_atom.txt", "w")
        f.write(str(active_residue()))
        f.close()


add_key_binding("Send active atom to file", "W", lambda: key_binding_func_50())

