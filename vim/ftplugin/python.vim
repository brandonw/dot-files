:python << EOF
import os
virtualenv = os.environ.get('VIRTUAL_ENV')
if virtualenv:
    activate_this = os.path.join(virtualenv, 'bin', 'activate_this.py')
if os.path.exists(activate_this):
    execfile(activate_this, dict(__file__=activate_this))
EOF

function! LoadRope()
python << EOF
import ropevim
EOF
endfunction

call LoadRope()
set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4
filetype indent on
