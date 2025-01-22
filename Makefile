
-include ~/.makefilehelp

default.title = .hide # don't show this target
default:
	echo Do nothing.  Serves as a stop to stop first target from running.

archive-zsh-tools.title = Create snapshot of current ZSH shell configuration
archive-zsh-tools:
	tar -czvf zsh-setup.tar.gz ~/.zshrc ~/.p10k.zsh ~/.oh-my-zsh ~/.makefilehelp ~/.zsh_aliases


unarchive-zsh-tools.title = Overwrite current ZSH shell configuration
unarchive-zsh-tools:
	tar -xzvf zsh-setup.tar.gz --strip-components=2 -C ~

install-zsh-tools-1.title = Install and switch to ZSH
install-zsh-tools-1:
	sudo apt update
	sudo apt install zsh
	chsh -s $(which zsh)

install-zsh-tools-2.title = Install ZSH helpers
install-zsh-tools-2:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
	#
	@echo RUN make unarchive-zsh-tools to overlay stored configuration.
	#
	# No need to modify - step 3 will overwrite .zsrhc correct settings
	#
	## these are provided for completeness, but not necessary!
	## Modify .zshrc
	## ZSH_THEME="powerlevel10k/powerlevel10k"
	## plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
