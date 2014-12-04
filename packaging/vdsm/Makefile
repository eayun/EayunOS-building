repo = vdsm
package = vdsm
version = 4.16.7

sources:
	cd ../../ ;\
		git submodule init packaging/$(repo)/upstream ;\
		git submodule update packaging/$(repo)/upstream ;\
	cd packaging/$(repo)/upstream ;\
	git reset --hard 2823f565f36912c145b91a9063b3e0923d107bf8; \
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
	sed -i '/^AX_PYTHON_MODULE.*fatal/d'  configure.ac; \
	sed -i '/AC_MSG_ERROR.*python-devel/s/AC_MSG_ERROR/AC_MSG_WARN/'  configure.ac; \
	sed -i '/AC_MSG_ERROR.*python-nose/s/AC_MSG_ERROR/AC_MSG_WARN/'  configure.ac; \
	./autogen.sh; \
	make dist; \
	cp $(repo).spec ../; \
	cp $(repo)-$(version).tar.gz ../
