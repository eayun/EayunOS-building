# EayunOS-4.1 Hypervisor image recipe

%include common-install.ks
%include EayunOS-4.1-install.ks

%include repos.ks

%packages --excludedocs --nobase
%include common-pkgs.ks
%include EayunOS-4.1-pkgs.ks

%end

%post
%include common-post.ks
%include EayunOS-4.1-post.ks
%end

%post --nochroot
%include common-nochroot.ks

%end



%include common-manifest.ks

