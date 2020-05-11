setup_git()
{
	echo "What is the email address associated with your github account"
	read github_email
	local file_path="$HOME/.ssh/id_rsa"
	ssh-keygen -t rsa -b 4096 -C $github_email -f $file_path
	eval "$(ssh-agent -s)"
	ssh-add $file_path
}

setup_git
