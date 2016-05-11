repo = vdsm
package = vdsm
version = 4.17.28

sources:
	cd ../../ ;\
		git submodule init packaging/$(repo)/upstream ;\
		git submodule update packaging/$(repo)/upstream ;\
	cd packaging/$(repo)/upstream ;\
	git reset --hard a3892514f1eab03e9842f46a3de63a59f9abb9eb; \
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
	make dist; \
	cp $(repo).spec ../; \
	cp $(repo)-$(version).tar.gz ../
