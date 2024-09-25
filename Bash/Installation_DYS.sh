#!/usr/bin/bash

##############################################################################################
###                                                                                        ###
### Script d'installation rapide après mise en route d'une distribution basée sur Debian   ###
###           Rédigé par YehneeN d'après les scripts d'itsPoipoi <3                        ###
###                                                                                        ###
##############################################################################################

# Color
# -----------
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m'

# Fonctions
# -----------

sys_update() {
    sudo apt-get update && sudo apt-get upgrade -y
}

install_basicTools() {
    sudo apt-get install trash git curl wget bat unzip font-config -y
}

install_netTools() {
    sudo apt-get install procps util-linux sysstat iproute2 numactl -y
    sudo apt-get install tcpdump nicstat ethtool -y
    sudo apt-get install linux-tools-common linux-tools-$(uname -r) bpfcc-tools bpftrace trace-cmd -y
}

install_dufNdust() {
    sudo apt-get install duf -y
    brew -q install dust
}

install_flatpak() {
    sudo add-apt-repository ppa:flatpak/stable
    sudo apt-get update
    sudo apt-get install flatpak -y
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

install_keepassXC() {
    sudo add-apt-repository ppa:phoerious/keepassxc
    sudo apt-get update
    sudo apt-get install keepassxc -y
}

install_Nala() {
    sudo apt-get install nala -y
}

switch_toZsh() {
    sudo apt-get install zsh -y
    # Change default shell to zsh
    if [ ! "{{$SHELL}}" = "{{/usr/bin/zsh}}" ]; then
        echo "${YELLOW}Switcher vers zsh ?${NC} "
        select yn in "Yes" "No"; do
	        case $yn in
	  	        Yes ) chsh -s $(which zsh); break;;
 		        No ) break;;
	        esac
        done
    fi
}

install_fireCodeFont() {
    if [ ! -f ~/.local/share/fonts/FiraCodeNerdFont-Medium.ttf ]; then
	    echo "${GREEN}Installation de FiraCode Nerd Font...${NC}"
	    mkdir -p ~/.local/share/fonts/
	    curl -#L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip -o ~/.local/share/fonts/FiraCode.zip
	    unzip -oq ~/.local/share/fonts/FiraCode.zip  -d ~/.local/share/fonts/
	    rm ~/.local/share/fonts/FiraCode.zip
	    fc-cache -f ~/.local/share/fonts/
	    echo "${RED}Police d'écriture installée.${NC}"
 	else echo "${GREEN}Cette police d'écriture est déjà installée.${NC}"
    fi
}

install_homeBrew() {
    if [ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        echo "${YELLOW}Installation d'Homebrew...${NC}"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else echo "${YELLOW}Homebrew est déjà installé.${NC}"
    fi
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

install_fzf() {
    if [ ! -f /home/linuxbrew/.linuxbrew/bin/fzf ]; then
        brew install -q fzf
        else echo "${GREEN}Fzf est déjà installé.${NC}"
    fi
}

install_eza() {
    if [ ! -f /home/linuxbrew/.linuxbrew/bin/eza ]; then
        brew install -q eza
    else echo "${YELLOW}Eza est déjà installé.${NC}"
    fi
}

install_zoxide() {
    if [ ! -f ~/.local/bin/zoxide ]; then
        /bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh)"
    else echo "${GREEN}Zoxide est déjà installé.${NC}"
    fi
}

install_fastfetch() {
    if [ ! -f /usr/bin/fastfetch ]; then
        FASTFETCH_URL=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep "browser_download_url.*linux-amd64.deb" | cut -d '"' -f 4)
        curl -sL $FASTFETCH_URL -o /tmp/fastfetch_latest_amd64.deb
        sudo apt-get install /tmp/fastfetch_latest_amd64.deb -y
    else sudo apt-get install fastfetch -y
    fi
}

overwrite_fastfetchConfig() {
    if [ ! -f ~/.config/fastfetch/config.jsonc ]; then
	    fastfetch --gen-config ~/.config/fastfetch/config.jsonc
	    curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/config.jsonc -o ~/.config/fastfetch/config.jsonc
    else
	echo "${GREEN}Faut il écraser la configuration déjà présente de fastfetch?${NC} "
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) echo "${YELLOW}Configuration en cours de modification...${NC}"; curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/main/config.jsonc -o ~/.config/fastfetch/config.jsonc; break;;
 			No ) break;;
		esac
 	done
fi
}

needs_nvidia() {
    if lspci | grep -q NVIDIA; then
        read -r -p "Un GPU Nvidia a été détecté. Souhaitez-vous installer les drivers Nvidia (akmod-nvidia)?" wants_nvidia
        if [[ $wants_nvidia == "Yes" || $wants_nvidia == "Y" || $wants_nvidia == "y" || $wants_nvidia == "Oui" || $wants_nvidia == "O" || $wants_nvidia == "o"]]
        then
            sudo apt-get install akmod-nvidia -y
            echo "Done!"
        else
            echo "Skipping..."
        fi
    else
        echo "..."
    fi
}

install_supplement() {
    for package in "$@"; do
        if sudo apt-get install -y "$package"; then
            echo "Package '$package' installé correctement."
        else
            echo "Package '$package' non découvert..."
            sleep 1
        fi
    done
}

install_p10k() {
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
}


# Scripts
# ------------

echo "##############################################################################################"
echo "###                                                                                        ###"
echo "### Script d'installation rapide après mise en route d'une distribution basée sur Debian   ###"
echo "###           Rédigé par YehneeN d'après les scripts d'itsPoipoi <3                        ###"
echo "###                                                                                        ###"
echo "##############################################################################################"
echo

read -r -p "Démarrer l'installation ?" startupScript
if [[ $startupScript == "Oui" || $startupScript == "y" ||  $startupScript == "Y" ||  $startupScript == "O" ||  $startupScript == "Yes" ||  $startupScript == "o" ]]; then

# Mises à jours
    echo "Mise à jour du système..."
    sys_update
    sleep 1

# Installatio git, curl etc..
    echo "Mise à jour des outils..."
    install_basicTools
    sleep 1

# Installation Keepass <3
    echo "Installation de KeepassXC"
    install_keepassXC
    sleep 1

# Installation des outils réseaux
    echo "Installation des outils réseaux"
    install_netTools
    sleep 1

# Check installation Nvidia
    needs_nvidia
    sleep 1
    
# Installation Flatpak + Flathub ref.
    install_flatpak

# Choix persos
    echo "Lisez attentivement les prochaines questions et choisissez quoi installer."
    sleep 2
    echo

    # ZSH
    read -r -p "Voulez-vous installer zsh ? (Y/n)" zsh_install
    if [[ $zsh_install == "n" || $zsh_install == "N" ]]; then
        echo "Ok.. on oublie zsh =("
    else
        switch_toZsh
        source ~/.zshrc
    fi
    sleep 1

    # Theme Powerlevel10k pour Zsh
    if [ "{{$SHELL}}" = "{{/usr/bin/zsh}}" ]; then
        read -r -p "Voulez-vous utiliser le theme zsh PowerLevel10K ? (Y/n)" pow10k
        if [[ $pow10k == "n" || $pow10k == "N" ]]; then
            echo "C'est bien dommage =("
        else
            install_p10k
            sleep 1
            source ~/.zshrc
            echo "Police d'écriture recommandée : https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"
        fi
    fi
    sleep 1

    # Installation \ Switch Nala
    read -r -p "Voulez-vous installer le gestionnaire Nala ? (Y/n)" nala_install
    if [[ $nala_install == "n" || $nala_install == "N" ]]; then
        echo "Ok, on reste sur APT"
    else
        install_Nala
        if [ "{{$SHELL}}" = "{{/usr/bin/zsh}}" ]; then
            read -r -p "On switch d'APT vers Nala ? (Y/n)" nala_switch
                if [[ $nala_switch == "n" || $nala_switch == "N" ]]; then
                    echo "On garde APT '' par défaut ''"
                else 
                    echo "alias apt=\"nala\"" >> ~/.zshrc
                fi
        fi
    fi
    sleep 1

    # Installation homebrew + zoxide + fzf
    read -r -p "Voulez-vous installer Homebrew, Zoxide et Fzf ? (Y/n)" hmzf_install
    if [[ $hmzf_install == "n" || $hmzf_install == "N" ]]; then
        echo "On les laisse de côté.."
    else
        install_homeBrew
        sleep 1
        install_fzf
        sleep 1
        install_zoxide
    fi

    # Installation eza
    if [ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        read -r -p "Faut-il ajouter également eza ? (Y/n)" eza_install
            if [[ $eza_install == "n" || $eza_install == "N" ]]; then
                echo "On installe pas eza."
            else
                install_eza
            fi
        sleep 1
        read -r -p "On installe duf et dust ? (Y/n)" dufndust_install
            if  [[ $dufndust_install == "n" || $dufndust_install == "N" ]]; then
                echo "Osef.."
            else
                install_dufNdust
            fi
        sleep 1
    else
        sleep 1
    fi    

    # Installation Fast Fetch
    read -r -p "Voulez-vous installer fastfetch ? (Y/n)" ff_install
        if [[ $ff_install == "n" || $ff_install "N" ]]; then
            echo "On laisse Fast Fetch dans son coin."
        else
            install_fastfetch
            sleep 1
            read -r -p "Faut-il copier la configuration de Poipoi ? (Y/n)" pwapwa_ff
                if [[ $pwapwa_ff == "n" || $pwapwa_ff == "N" ]]; then
                    echo "Osef de sa configuration...."
                else
                    overwrite_fastfetchConfig
                fi
        fi


    # Installations autres....
    read -r -p "Voulez-vous installer autre chose ? (y/N) " install_supp
    if [[ $install_supp == "y" || $install_supp == "Y" || $install_supp == "Yes" ]]; then
        read -r -p "On ajoute quoi de plus ? (Ajoutez des espace entre chaque nom de paquet) " soft
        echo "Installation de $soft en cours..."
        install_supplement $soft
        echo "Installation OK !"
        sleep 1
    else
        echo "On installe rien de plus ;)"
    fi
    echo
           
else
    echo "On stop l'installation.."
fi