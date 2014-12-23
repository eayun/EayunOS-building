repo = ovirt-node-plugin-hosted-engine
package = ovirt-node-plugin-hosted-engine
version = 0.2.1_ovirt35

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
