
-include ~/.makefilehelp

default.title = .hidden
default:
	echo Do nothing.  Serves as a stop to stop first target from running.

archive-zsh-tools.title = Create snapshot of current ZSH shell configuration
archive-zsh-tools:
	tar -czvf zsh-setup.tar.gz ~/.p10k.zsh ~/.oh-my-zsh ~/.makefilehelp ~/.zsh_aliases ~/.zshrc ~/.zshenv ~/.zsh_profile

unarchive-zsh-tools.title = Overwrite current ZSH shell configuration
unarchive-zsh-tools:
	tar -xzvf zsh-setup.tar.gz --strip-components=2 -C ~

install-zsh-tools-1.title = Install and switch to ZSH
install-zsh-tools-1:
	sudo apt update
	sudo apt install zsh
	sudo apt install fzf make gawk sed gh git
	chsh -s $(which zsh)

install-zsh-tools-2.title = Install ZSH helpers
install-zsh-tools-2:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	cd ~ && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	cd ~ && git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	cd ~ && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
	#
	@echo RUN make unarchive-zsh-tools to overlay stored configuration.
	#
	# No need to modify - step 3 will overwrite .zsrhc correct settings
	#
	## these are provided for completeness, but not necessary!
	## Modify .zshrc
	## ZSH_THEME="powerlevel10k/powerlevel10k"
	## plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

upgrade-quarto.title = Upgrade Quarto
qv = $(shell curl -s https://quarto.org/docs/download/_download.json | grep -oP '"version":\s*"\K[0-9.]+')
upgrade-quarto:
	echo $(qv)
	curl -L -o quarto-latest.deb https://github.com/quarto-dev/quarto-cli/releases/download/v$(qv)/quarto-$(qv)-linux-amd64.deb
	sudo dpkg -i quarto-latest.deb
	rm quarto-latest.deb

zScaler-notes.title = Zscaler notes for wsl
zScaler-notes:
	@echo Check for Zscaler certificates in /usr/local/share/ca-certificates
	@echo run sudo update-ca-certicates to install for wsl
	@echo set export REQUESTS_CA_CERTIFICATES=/usr/local/share/ca-certificates/cacert.pem

upgrade-ohmyzsh.title = Upgrade oh-my-zsh
upgrade-ohmyzsh:
	cd ~/.oh-my-zsh && git pull
	
