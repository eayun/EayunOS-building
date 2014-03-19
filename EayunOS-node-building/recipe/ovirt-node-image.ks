# eayunos-node-3.3 Node image recipe

%include common-install.ks
%include eayunos-node-3.3-install.ks

%include repos.ks

%packages --excludedocs --nobase
%include common-pkgs.ks
%include eayunos-node-3.3-pkgs.ks

%end

%post
%include common-post.ks
%include eayunos-node-3.3-post.ks
%end

%post --nochroot
%include common-nochroot.ks

%end



%include common-manifest.ks

