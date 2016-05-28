repo = ovirt-hosted-engine-setup
package = ovirt-hosted-engine-setup
version = 1.3.6.1

sources:
	cd ../../ ;\
		git submodule init packaging/$(repo)/upstream ;\
		git submodule update packaging/$(repo)/upstream ;\
	cd packaging/$(repo)/upstream ;\
	git config user.name "Pan Liyang" ;\
	git config user.email "liyang.pan@eayun.com" ;\
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
	./configure; \
	make dist; \
	cp $(repo)-$(version).tar.gz ../
