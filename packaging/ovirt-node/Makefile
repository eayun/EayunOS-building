repo = ovirt-node
package = ovirt-node
version = 3.1.0_master

sources:
	cd ../../ ;\
		git submodule init packaging/$(repo)/upstream ;\
		git submodule update packaging/$(repo)/upstream ;\
	cd packaging/$(repo)/upstream ;\
	git config user.name "Zhao Chao" ;\
	git config user.email "chao.zhao@eayun.com" ;\
	cd ..; \
	for file in *.patch; do \
		if [ -f $$file ]; then \
			cd upstream; \
			git am ../$$file; \
			cd ..; \
		fi; \
	done; \
	cd upstream; \
	./autogen.sh; \
	make dist; \
	cp $(repo)-$(version).tar.gz ../
