import subprocess

from . import export
from . import colors

def reload():
    """Run scripts to reload all program's colorsheme config"""
    # subprocess.run(["sh", "./scripts/reload.sh"])

def main():
    config = colors.get()
    export.all(config)
    reload()

if __name__ == "__main__":
    main()
