
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

        imol_name = molecule_name(imol)
        res_name = residue_name(imol, chain_id, res_no, ins_code)
        space_group = show_spacegroup(imol);

        f = open("/Users/matt/Dropbox/programming/cootControl/output_active_atom.txt", "w")
        f.write(str(imol_name).split('/')[-1] + '\n')
        f.write(str(imol) + '\n')
        f.write(str(chain_id) + '\n')
        f.write(str(res_no) + '\n')
        f.write(str(res_name) + '\n')
        #f.write(str(space_group) + '\n')
        #f.write(str(ins_code) + '\n')
        #f.write(str(atom_name) + '\n')
        #f.write(str(alt_conf) + '\n')

        f.close()


add_key_binding("Send active atom to file", "W", lambda: key_binding_func_50())

def get_molecule_info():
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

        imol_name = molecule_name(imol)
        res_name = residue_name(imol, chain_id, res_no, ins_code)
        space_group = show_spacegroup(imol);

        number_residues_in_chain = chain_n_residues(chain_id, imol)

        f = open("/Users/matt/Dropbox/programming/cootControl/molecule_sequence.txt", "w")
        for resi in range(0, number_residues_in_chain):
            name = resname_from_serial_number(imol, chain_id, resi)
            numb = seqnum_from_serial_number(imol, chain_id, resi)
            f.write(str(numb) + ' ' + name + '\n')
        f.close()

add_key_binding("get molecule info and send to file", "a", lambda: get_molecule_info())

