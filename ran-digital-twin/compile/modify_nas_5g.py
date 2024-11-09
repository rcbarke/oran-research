#
# modify_nas_5g.py
#
# Ryan Barker
# Clemson University IS-WiN Laboratory 
# ORAN team
# 
# Description: This script searches for a specific code stanza within the 
# `nas_5g.cc` file in the srsRAN 4G source code and comments it out if found.
# The target stanza configures slicing in NAS registration requests, which may 
# need to be disabled in certain configurations for testing or custom deployments.
#
# The script locates the stanza and adds comment markers to each line, effectively 
# disabling it without modifying surrounding code.
#
# Usage: python3 modify_nas_5g.py
# 
import re

# Define the file path
file_path = './srsRAN_4G/srsue/src/stack/upper/nas_5g.cc'

# Define the target code stanza to comment out
code_stanza = """
  if (cfg.enable_slicing) {
    reg_req.requested_nssai_present = true;
    s_nssai_t nssai;
    set_nssai(nssai);
    reg_req.requested_nssai.s_nssai_list.push_back(nssai);
  }
"""

# Regular expression to match the target code stanza
pattern = re.compile(r"  if \(cfg\.enable_slicing\) {\s*\n\s*reg_req\.requested_nssai_present = true;\s*\n\s*s_nssai_t nssai;\s*\n\s*set_nssai\(nssai\);\s*\n\s*reg_req\.requested_nssai\.s_nssai_list\.push_back\(nssai\);\s*\n\s*}", re.MULTILINE)

# Read the file and search for the stanza
with open(file_path, 'r') as file:
    content = file.read()

# Check if the stanza is in the file
if pattern.search(content):
    # Replace the target stanza with the commented version
    commented_stanza = re.sub(r"^", "//", code_stanza.strip(), flags=re.MULTILINE)
    content = pattern.sub(commented_stanza, content)

    # Write the modified content back to the file
    with open(file_path, 'w') as file:
        file.write(content)
    print("Code stanza found and commented out successfully.")
else:
    print("Code stanza not found.")

