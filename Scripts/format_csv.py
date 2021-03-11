import sys, os, csv

DEFAULT_OPTIONS = {
    "field_terminator": ",",
    "row_terminator": "\n",
    "output_file": None
}

def parse_options(option_args, default):
    options = default if default else {}

    for o in option_args:
        option_data = o.split("=")
    
        if len(option_data) < 2:
            return None
        
        if option_data[0].startswith('--'):
            option_key = option_data[0][2:len(option_data[0])]
        
            if not option_key in default:
                return None
            options[option_key] = option_data[1]
        elif option_data[0].startswith('-'):
            option_key = option_data[0][1]
            for i in options:
                if i.startswith(option_key):
                    options[i] = option_data[1]

    return options



def help():
    print("""Usage:
python format_csv.py <filename> [-f=<field_terminator>] [-r=<row_terminator>] [-o=<output_file>]
    """)


def main(args, options=DEFAULT_OPTIONS):
    file_path = args[1]
    
    if not os.path.exists(file_path):
        print("File not found %s" % file_path)
        return
    
    options = parse_options(args[2:len(args)], default=options)
    if options is None:
        return help()

    if options["output_file"] is None:
        options["output_file"] = file_path

    input_file = open(file_path, "r")
    output_file = open(options["output_file"], "a")

    for row_split in csv.reader(input_file.readlines(), skipinitialspace=True):
        row = options["field_terminator"].join(row_split)
        row += options["row_terminator"]
        output_file.write(row)

    input_file.close()
    output_file.close()

if __name__ == "__main__":
    args = sys.argv
    if len(args) < 2:
        help()
    else:
        main(args)