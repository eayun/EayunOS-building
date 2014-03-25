# virt-p2v Node image recipe

%include common-install.ks

%packages --excludedocs --nobase
%include common-pkgs.ks
%end

%post
%include common-post.ks
%include p2v-post.ks
%end

%include common-minimizer.ks

%post --nochroot
%include common-post-nochroot.ks
%end

%include common-manifest-post.ks
