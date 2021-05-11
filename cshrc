bindkey '\e[1~' beginning-of-line      # Home
bindkey '\e[3~' delete-char            # Delete
bindkey '\e[4~' end-of-line            # End
bindkey "^W" backward-delete-word      # Delete
bindkey -k up history-search-backward  # PageUp
bindkey -k down history-search-forward # PageDown

setenv LANG en_US.UTF-8

set cc = "%{\e[36m%}" #cyan
set cr = "%{\e[31m%}" #red
set cg = "%{\e[32m%}" #green
set c0 = "%{\e[0m%}"  #default

# Set some variables for interactive shells
if ( $?prompt ) then
    if ( "$uid" == "0" ) then
	set prompt = "$cc%B[%@]%b %B%U%n%u@%m.$cr%l$c0%b %c2 %B%#%b " 
    else if ( `uname` == "SunOS" ) then
	set prompt = "$cc%B[%@]%b %B%U%n%u@%m.$cr%l$c0%b %c2 %B%%%b "
    else if (`cat /etc/redhat-release | grep release\ 4 | wc -l`) then
	set prompt = "$cc%B[%@]%b %B%U%n%u@%m.$cg%l$c0%b %c2 %B%%%b "
    else
	set prompt = "$cc%B[%@]%b %B%U%n%u@%m.$cc%l$c0%b %c2 %B%%%b "
    endif
endif
#ls color on
setenv LSCOLORS ExGxFxdxCxegedabagExEx
setenv CLICOLOR yes
#grep match color on 
setenv GREP_OPTIONS --color=auto
#tab 
set autolist
#history
set autoexpand
set history = 100
set savehist = 10
#svn alias
alias   pushd   'pushd \!* > /dev/null; pwd; ls'
alias   popd   'popd \!* > /dev/null; pwd; ls'
alias	cd	'set old=$cwd; chdir \!*;pwd;ls'
alias -	    'cd -'        #back to the up flood
alias ..    'cd ..'       #back to the top flood
alias rm    'rm -i'       
alias del   'rm -r'       
alias mv    'mv -i'       
alias la    'ls -a'      
alias ll    'ls -h -l' 
