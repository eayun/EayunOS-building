# EayunOS 4 Node image recipe

%include common-install.ks
%include eayunos4-install.ks

%include repos.ks

%packages --excludedocs --nobase
%include common-pkgs.ks
%include eayunos4-pkgs.ks

%end

%post
%include common-post.ks
%include eayunos4-post.ks
%end

%post --nochroot
%include common-nochroot.ks

%end



%include common-manifest.ks

