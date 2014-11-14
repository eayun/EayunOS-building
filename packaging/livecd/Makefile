repo = livecd
package = livecd-tools
version = 20.6

sources:
	cd ../../ ;\
		git submodule init packaging/$(repo)/upstream ;\
		git submodule update packaging/$(repo)/upstream ;\
	cd packaging/$(repo)/upstream ;\
	git config user.name "Zhao Chao" ;\
	git config user.email "chao.zhao@eayun.com" ;\
	cd ..; \
	for file in *.patch; do \
		cd upstream; \
		git apply ../$$file; \
		git commit -am "applying $$file"; \
		cd ..; \
	done; \
	cd upstream; \
	git archive --format=tar --prefix=$(package)-$(version)/ HEAD | bzip2 -9v > ../$(package)-$(version).tar.bz2
