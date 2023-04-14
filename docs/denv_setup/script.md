# Contents of script bash file
This script is a Bash script that automates the installation of Miniconda, creates a Conda environment named "ray", installs various packages, and activates the environment.

```
cp temp5.txt ~/.bashrc
source ~/.bashrc
```

These lines copy the contents of <b>temp5.txt</b> to the <b>~/.bashrc</b> file and then sources the ~/.bashrc file to apply any changes to the current shell.

<b>temp5.txt</b> file consists of contents of <b>.bashrc</b> file just before the installation of all the packages in the environment. So make sure you copy the content of the bashrc and save it in the <b>temp5.txt</b>

```
rm -rf ~/miniconda
rm miniconda.sh
```
These lines remove any existing Miniconda installation and the miniconda.sh installation file.

```
if command -v conda >/dev/null 2>&1 ; then
    echo "Miniconda is already installed on this system."
else
    # Download the latest version of Miniconda for Linux
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

    # Install Miniconda
    bash ~/miniconda.sh -b -p $HOME/miniconda

    # Add Miniconda to PATH
    conda_dir="/home/windows/miniconda"

    # Create a backup of the existing bashrc file
    cp ~/.bashrc ~/.bashrc.backup

    # Append the conda initialization code to the bashrc file
    echo "# >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup=\"\$('$conda_dir/bin/conda' 'shell.bash' 'hook' 2> /dev/null)\"
    if [ \$? -eq 0 ]; then
        eval \"\$__conda_setup\"
    else
        if [ -f \"$conda_dir/etc/profile.d/conda.sh\" ]; then
            . \"$conda_dir/etc/profile.d/conda.sh\"
        else
            export PATH=\"$conda_dir/bin:\$PATH\"
        fi
    fi
    unset __conda_setup
# <<< conda initialize <<<
conda activate ray
export NCCL_SOCKET_IFNAME=enp3s0" >> ~/.bashrc

    # Source the updated bashrc file to apply the changes
    source ~/.bashrc

    echo "Miniconda has been installed."
fi
```

These lines check if Miniconda is already installed on the system by using the command -v conda command. If Miniconda is not installed, the script downloads the latest version of Miniconda for Linux from the official Anaconda repository using wget. It then installs Miniconda by running the <b><i>miniconda.sh</i></b> installation script with the -b and -p flags, which specify that the installation should be run in batch mode and that the installation path should be set to <b><i>$HOME/miniconda</i></b>.

Once Miniconda is installed, the script adds it to the system PATH variable by appending the conda initialization code to the <b><i>~/.bashrc file</b></i>. The conda initialization code is a block of code that enables the conda environment to be activated automatically when a new terminal session is started. This is done by defining the <b><i>__conda_setup</b></i> variable to store the output of the conda <b><i>shell.bash</b></i> hook command. The eval command then evaluates the <b><i>__conda_setup</b></i> variable, which activates the conda environment. The unset command then removes the <b><i>__conda_setup</b></i> variable.

The script then <b><i>sources the updated ~/.bashrc</b></i> file to apply the changes.

Next, the script activates the ray environment by running the conda activate ray command. <b>It then checks if the environment is already present in conda</b>. If it is, the script prints a message indicating that the environment is already present. <b>If it is not, the script creates the environment by running the `conda create -y --name ray command`. The -y option specifies that the user should not be prompted for confirmation before proceeding with the installation.</b>

Once the environment is created, the script activates it by running the conda activate ray command. It then installs <b>Python 3.10.8</b> by running the `conda install -y python='3.10.8'` command. It also installs the <b>Ray package</b> by running the `pip install -U 'ray[default]'` command.

The script then installs <b><i>PyTorch 1.13.1</b></i>, <b><i>torchvision 0.14.1</b></i>, and <b><i>torchaudio 0.13.1</b></i> by running the `conda install -y pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia` command. This command specifies that the PyTorch packages should be installed from the pytorch and nvidia channels.

The script then checks if a <b><i>requirements.txt</b></i> file exists in the current directory. If the file does not exist, the script prints an error message and exits with a status code of 1. <b>If the file exists, the script installs the packages listed in the requirements.txt file by running the `pip install -r requirements.txt` command</b>.