import os
import shutil

# Get the directory of the Python script itself
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define the target file path relative to the script's directory
file_path = os.path.join(script_dir, '../srsRAN_4G/srsue/src/stack/mac_nr/proc_ra_nr.cc')
backup_path = file_path + '.bak'

# Ensure we create a backup of the original file before modifying anything
shutil.copyfile(file_path, backup_path)

# Read the file contents
with open(file_path, 'r') as file:
    lines = file.readlines()

# Define the new code to insert
new_code = [
    "    // RCB: random wait\n",
    "    preamble_backoff = 200;\n",
    "    uint32_t random_wait = (rand() % preamble_backoff) * (1 << preamble_transmission_counter);\n",
    "    backoff_wait = std::min(random_wait, static_cast<uint32_t>(3000));\n"
]

# Initialize flags
in_target_block = False

# Open the file to write the modified content
with open(file_path, 'w') as file:
    for line in lines:
        # Check for the start of the block to modify
        if "// try again, if RA failed" in line:
            # Write the line and set flag to modify the next lines
            file.write(line)
            in_target_block = True
            continue

        # If in target block, comment out specific lines and add new code
        if in_target_block:
            if "if (preamble_backoff)" in line:
                file.write("    // if (preamble_backoff) {\n")
            elif "backoff_wait = rand() % preamble_backoff;" in line:
                file.write("    //   backoff_wait = rand() % preamble_backoff;\n")
            elif "} else {" in line:
                file.write("    // } else {\n")
            elif "backoff_wait = 0;" in line:
                file.write("    //   backoff_wait = 0;\n")
            elif "}" in line:
                file.write("    // }\n")
                # Insert new code after commenting out the block
                file.writelines(new_code)
                in_target_block = False  # End of target block
            continue  # Skip writing original lines in the target block

        # Write all other lines unchanged
        file.write(line)

print(f"Modifications complete. A backup of the original file has been saved as {backup_path}.")
